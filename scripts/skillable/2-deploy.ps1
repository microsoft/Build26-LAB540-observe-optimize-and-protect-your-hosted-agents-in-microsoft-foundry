# =============================================================================
# 2-deploy.ps1 — LAB540 Skillable lifecycle: DEPLOY phase
#
# Runs after 1-install.ps1 has installed azd and downloaded the repo.
# Performs the full azd deployment and post-deploy RBAC setup:
#
#   1. Authenticates to Azure using the Skillable lab service principal.
#   2. Resolves the lab user's Entra object ID (needed for RBAC grants).
#   3. Creates an azd environment and runs `azd up` from C:\Build26-Lab540\zava
#      (where the project's azure.yaml lives) to provision the Foundry account,
#      project, model deployment, ACR, Container App, and Application Insights.
#   4. Grants the lab user, deployment SP, and agent managed identities the
#      required Foundry User / Foundry Project Manager roles so the user can
#      interact with the pre-deployed agent immediately when the lab starts.
#   5. Waits 120 s for RBAC propagation before completing.
#
# Skillable @lab tokens are substituted at runtime by the lab platform.
# Log is written to the Desktop at lifecycle-lab540.log.
# =============================================================================

$logPath = "C:\Users\LabUser\Desktop\lifecycle-lab540.log"
Start-Transcript -Path $logPath -Force

try {
    # === Skillable lab variables (substituted at runtime) ===
    $appId     = "@lab.CloudSubscription.AppId"
    $appSecret = "@lab.CloudSubscription.AppSecret"
    $tenantId  = "@lab.CloudSubscription.TenantId"
    $subId     = "@lab.CloudSubscription.Id"
    $region    = "@lab.CloudResourceGroup(ResourceGroup1).Location"
    $envName   = "lab540-@lab.LabInstance.Id"  # unique per instance; azd creates rg-{envName}
    $rg        = "@lab.CloudResourceGroup(ResourceGroup1).Name"  # pre-existing Skillable RG (informational only)
    $userUpn   = "@lab.CloudPortalCredential(User1).Username"  # lab attendee — gets Foundry roles post-deploy

    $ErrorActionPreference = "Stop"

    # Run an external command, capture stderr to a file so the Python traceback
    # survives, and only throw after we've logged the full error.
    function Invoke-External($label, [ScriptBlock]$cmd) {
        Write-Host ">>> $label"
        $stderrFile = Join-Path $env:TEMP "extcmd-stderr.txt"
        if (Test-Path $stderrFile) { Remove-Item $stderrFile -Force }

        $prev = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        try {
            & $cmd 2> $stderrFile | ForEach-Object { Write-Host $_ }
        } finally {
            $ErrorActionPreference = $prev
        }

        if (Test-Path $stderrFile) {
            $err = Get-Content $stderrFile -Raw
            if ($err) { Write-Host "STDERR: $err" }
        }
        if ($LASTEXITCODE -ne 0) { throw "$label failed (exit $LASTEXITCODE)." }
    }

    function Grant-Role($principalId, $roleId, $scope, $label) {
        try {
            New-AzRoleAssignment -RoleDefinitionId $roleId -ObjectId $principalId -Scope $scope -ErrorAction Stop | Out-Null
            Write-Host "Granted $label to $principalId"
        } catch {
            if ($_.Exception.Message -match "already exists|RoleAssignmentExists|Conflict") {
                Write-Host "Skip (already exists): $label for $principalId"
            } else { throw }
        }
    }

    # Retry a scriptblock until it returns a non-null/non-empty result or throws after $maxAttempts
    function Invoke-WithRetry([ScriptBlock]$sb, [string]$label, [int]$maxAttempts = 12, [int]$delaySec = 15) {
        for ($i = 1; $i -le $maxAttempts; $i++) {
            try {
                $result = & $sb
                if ($result) { return $result }
                Write-Host "  $label attempt $i/${maxAttempts}: empty result, retrying in ${delaySec}s..."
            } catch {
                Write-Host "  $label attempt $i/${maxAttempts}: $($_.Exception.Message)"
                if ($i -eq $maxAttempts) { throw }
            }
            Start-Sleep -Seconds $delaySec
        }
        throw "$label did not return a result after $maxAttempts attempts."
    }

    # === Az PowerShell login (only auth we need) ===
    Write-Host ">>> Connect-AzAccount"
    $securePwd = ConvertTo-SecureString $appSecret -AsPlainText -Force
    $psCred    = New-Object System.Management.Automation.PSCredential ($appId, $securePwd)
    Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $psCred -Subscription $subId | Out-Null

    # === Resolve lab user object ID (with retry) ===
    Write-Host ">>> Resolve user $userUpn"
    $userId  = $null
    $retries = 0
    while (-not $userId -and $retries -lt 10) {
        try { $userId = (Get-AzADUser -UserPrincipalName $userUpn -ErrorAction Stop).Id }
        catch { Write-Host "  attempt $($retries+1): $($_.Exception.Message)" }
        if (-not $userId) { Start-Sleep -Seconds 15; $retries++ }
    }
    if (-not $userId) { throw "Could not resolve user '$userUpn'." }
    Write-Host "userId = $userId"

    # === Resolve deployment SP object ID ===
    $spObjectId = (Get-AzADServicePrincipal -ApplicationId $appId -ErrorAction Stop).Id
    Write-Host "spObjectId = $spObjectId"

    # === azd up ===
    # Add azd to PATH (installed to C:\utils\azd by 1-install.ps1)
    $env:PATH += ";C:\utils\azd\bin"

    # azure.yaml lives in the zava/ subdirectory — this is the azd project root for LAB540
    $labPath = "C:\Build26-Lab540\zava"
    if (-not (Test-Path $labPath)) { throw "Lab folder not found: $labPath" }
    Set-Location $labPath

    Invoke-External "azd auth login" {
        azd auth login --client-id $appId --client-secret $appSecret --tenant-id $tenantId
    }
    Invoke-External "azd env new" {
        azd env new $envName --location $region --subscription $subId
    }

    # Pass the lab user as the principal so Bicep can scope RBAC grants correctly
    azd env set AZURE_PRINCIPAL_ID   $userId
    azd env set AZURE_PRINCIPAL_TYPE "User"
    azd env set AZURE_TENANT_ID      $tenantId

    # Run azd up, capturing combined stdout+stderr so we can detect the known
    # post-provision race condition (agent version 404) and continue despite it.
    Write-Host ">>> azd up"
    $azdOutput = & azd up -e $envName --no-prompt 2>&1
    $azdOutput | ForEach-Object { Write-Host $_ }

    if ($LASTEXITCODE -ne 0) {
        $outputStr = ($azdOutput | Out-String)
        if ($outputStr -match 'event-postprovision|event-postdeploy' -and $outputStr -match 'not_found|404') {
            Write-Host "WARNING: azd up exited $LASTEXITCODE due to known post-provision race condition (agent version 404). All Azure resources provisioned successfully - continuing with RBAC setup."
        } else {
            throw "azd up failed (exit $LASTEXITCODE)."
        }
    }

    Write-Host ">>> azd up complete"

    # === Post-deploy role assignments ===
    # Stable Azure built-in role GUIDs — no runtime lookup needed.
    $foundryUserRoleId           = "53ca6127-db72-4b80-b1b0-d745d6d5456d"  # Azure AI Foundry User
    $foundryProjectManagerRoleId = "eadc314b-1a2d-4efa-be10-5d325db5065e"  # Azure AI Foundry Project Manager
    $openAIContributorRoleId     = "a001fd3d-188f-4b5d-821b-7da978bf7442"  # Cognitive Services OpenAI Contributor (needed for prompt optimizer)
    # Cognitive Services OpenAI User for the AI project's system-assigned managed identity.
    # Required so the Foundry evaluation service can call the LLM judge model (task_completion,
    # coherence, etc.) using the project MI. Without this, eval runs fail with AuthenticationError.
    # Also set in ai-project.bicep — this grant ensures it survives any post-deploy RBAC drift.
    $openAIUserRoleId            = "5e0bd9bd-7b93-4f28-af87-19fc36ad61bd"  # Cognitive Services OpenAI User (eval runner / project MI)
    # Log Analytics Data Reader for the project MI on the Log Analytics workspace.
    # Required for the evaluations feature to read agent trace data from the workspace.
    # Per https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agent-permissions
    # Also set in applicationinsights.bicep — this grant ensures it survives RBAC drift.
    $logAnalyticsDataReaderRoleId = "3b03c2da-16b3-4a49-8834-0f8130efdd3b"  # Log Analytics Data Reader (evaluations)
    # Monitoring Reader for the lab user on Application Insights.
    # Required for the Observe skill to view agent traces — Foundry User alone sees metrics but not traces.
    # Per https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agent-permissions#viewing-telemetry-data
    # Also set in applicationinsights.bicep — this grant ensures it survives RBAC drift.
    $monitoringReaderRoleId       = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"  # Monitoring Reader (Observe skill)

    # azd provisions into a new resource group rg-{envName}, separate from the Skillable pre-existing RG
    $azdRg = "rg-$envName"
    Write-Host "azd resource group: $azdRg"

    $aiResource = Invoke-WithRetry {
        Get-AzCognitiveServicesAccount -ResourceGroupName $azdRg -ErrorAction Stop | Select-Object -First 1
    } "Get Foundry account"
    if (-not $aiResource) { throw "No Foundry account found in RG '$rg'." }
    $aiResourceId = $aiResource.Id
    $accountName  = $aiResource.AccountName
    Write-Host "aiResourceId = $aiResourceId"

    $aiProject = Invoke-WithRetry {
        $proj = Get-AzResource `
            -ResourceType "Microsoft.CognitiveServices/accounts/projects" `
            -ResourceGroupName $azdRg `
            -ExpandProperties -ErrorAction Stop | Select-Object -First 1
        if ($proj -and $proj.Identity.PrincipalId) { return $proj }
        return $null  # triggers retry
    } "Get project managed identity"
    $projectIdentityPrincipalId = $aiProject.Identity.PrincipalId

    Grant-Role $spObjectId               $foundryUserRoleId           $aiResourceId "Foundry User (deployment SP)"
    Grant-Role $userId                   $foundryUserRoleId           $aiResourceId "Foundry User (user)"
    Grant-Role $userId                   $foundryProjectManagerRoleId $aiResourceId "Foundry Project Manager (user)"
    Grant-Role $userId                   $openAIContributorRoleId     $aiResourceId "OpenAI Contributor (user — prompt optimizer)"
    Grant-Role $projectIdentityPrincipalId $foundryUserRoleId         $aiResourceId "Foundry User (project MI)"
    Grant-Role $projectIdentityPrincipalId $openAIUserRoleId          $aiResourceId "OpenAI User (project MI — eval LLM judges)"

    # Log Analytics Data Reader for project MI — scoped to the workspace (not the AI account)
    $logAnalyticsWorkspace = Invoke-WithRetry {
        Get-AzOperationalInsightsWorkspace -ResourceGroupName $azdRg -ErrorAction Stop | Select-Object -First 1
    } "Get Log Analytics workspace"
    if ($logAnalyticsWorkspace) {
        Grant-Role $projectIdentityPrincipalId $logAnalyticsDataReaderRoleId $logAnalyticsWorkspace.ResourceId "Log Analytics Data Reader (project MI — evaluations)"
    } else {
        Write-Host "WARNING: No Log Analytics workspace found in '$azdRg' — skipping Log Analytics Data Reader grant."
    }

    # Monitoring Reader for the lab user — scoped to App Insights (required for the Observe skill / agent trace viewing)
    $appInsights = Invoke-WithRetry {
        Get-AzApplicationInsights -ResourceGroupName $azdRg -ErrorAction Stop | Select-Object -First 1
    } "Get Application Insights"
    if ($appInsights) {
        Grant-Role $userId $monitoringReaderRoleId $appInsights.Id "Monitoring Reader (user — Observe skill / agent traces)"
    } else {
        Write-Host "WARNING: No Application Insights found in '$azdRg' — skipping Monitoring Reader grant."
    }

    $deadline = (Get-Date).AddMinutes(5)
    $agentSps = @()
    do {
        $agentSps = Get-AzADServicePrincipal -SearchString $accountName |
            Where-Object {
                $_.ServicePrincipalType -eq "ServiceIdentity" -and
                $_.DisplayName -like "*-AgentIdentity"
            }
        if ($agentSps.Count -gt 0) { break }
        Write-Host "Waiting for agent identities..."
        Start-Sleep -Seconds 20
    } while ((Get-Date) -lt $deadline)

    if ($agentSps.Count -eq 0) {
        Write-Host "WARNING: no agent identities found for '$accountName' after 5 minutes."
    } else {
        foreach ($sp in $agentSps) {
            Grant-Role $sp.Id $foundryUserRoleId $aiResourceId "Foundry User ($($sp.DisplayName))"
        }
    }

    # Allow Azure RBAC assignments time to propagate before any agent data-plane calls
    Write-Host ">>> Waiting 120 s for RBAC propagation..."
    Start-Sleep -Seconds 120

    Write-Host ">>> Lifecycle action complete."
}
catch {
    Write-Host "FATAL: $($_.Exception.Message)"
    Write-Host $_.ScriptStackTrace
    throw
}
finally {
    Stop-Transcript
}