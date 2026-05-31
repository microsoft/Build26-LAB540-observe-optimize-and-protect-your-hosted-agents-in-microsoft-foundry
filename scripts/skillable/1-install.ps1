# =============================================================================
# 1-install.ps1 — LAB540 Skillable lifecycle: INSTALL phase
#
# Runs once when the Skillable lab VM is first created.
# Performs two tasks:
#   1. Installs the Azure Developer CLI (azd) to C:\utils\azd using the
#      official Microsoft installer script (with retry logic).
#   2. Downloads the LAB540 GitHub repo and extracts it to C:\Build26-Lab540
#      so that 2-deploy.ps1 can find azure.yaml at C:\Build26-Lab540\zava.
#
# Log is written to the Desktop (or %TEMP% if Desktop is unavailable).
# =============================================================================

$ErrorActionPreference = "Stop"

function Get-LogPath {
    param([string]$Name)
    $desktop = [Environment]::GetFolderPath("Desktop")
    if ($desktop -and (Test-Path $desktop)) { return Join-Path $desktop $Name }
    return Join-Path $env:TEMP $Name
}

$logPath = Get-LogPath "install-lab540.log"
Start-Transcript -Path $logPath -Force | Out-Null

function Log($m){ Write-Host "$(Get-Date -Format o) $m" }

# ---------------------------------------------------------------------------
# Helper: download the official azd installer script with retry
# ---------------------------------------------------------------------------
function Download-AZD {
    param([string]$InstallerPath)

    for ($i = 1; $i -le 10; $i++) {
        try {
            Log ("Attempt {0}: Downloading AZD installer" -f $i)
            Invoke-RestMethod https://aka.ms/install-azd.ps1 `
                -OutFile $InstallerPath `
                -ErrorAction Stop
            return
        }
        catch {
            Log ("Attempt {0} failed: {1}" -f $i, $_.Exception.Message)
            Start-Sleep 10
        }
    }
    throw "Failed to download AZD installer after retries"
}

try {
    # -------------------------------------------------------------------------
    # Step 1: Install Azure Developer CLI (azd)
    # Installed to C:\utils\azd so 2-deploy.ps1 can add C:\utils\azd\bin to PATH.
    # -------------------------------------------------------------------------
    Log "Starting AZD installation"

    $script = Join-Path $env:TEMP "install-azd.ps1"
    Download-AZD -InstallerPath $script

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script -InstallFolder "C:\utils\azd"

    if ($LASTEXITCODE -ne 0) {
        throw "AZD installer failed"
    }

    $env:PATH += ";C:\utils\azd\bin"

    # Wait for azd to be usable (cmd wrapper avoids EAP issues in some PS versions)
    for ($i = 1; $i -le 10; $i++) {
        try {
            cmd /c azd version > $null 2>&1
            Log "AZD available"
            break
        }
        catch {
            if ($i -eq 10) { throw "AZD not available after install" }
            Start-Sleep 5
        }
    }

    Log "AZD installation complete"

    # -------------------------------------------------------------------------
    # Step 2: Download the LAB540 repo to C:\Build26-Lab540
    # The repo's azure.yaml is under the zava/ subdirectory, so 2-deploy.ps1
    # will set its working directory to C:\Build26-Lab540\zava before running
    # azd commands.
    # -------------------------------------------------------------------------
    Log "Downloading LAB540 repo"

    $zipUrl     = "https://github.com/microsoft/Build26-LAB540/archive/refs/heads/main.zip"
    $zipPath    = Join-Path $env:TEMP "Build26-LAB540.zip"
    $destPath   = "C:\Build26-Lab540"
    $tempExtract = Join-Path $env:TEMP "Build26-LAB540-extract"

    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing

    # GitHub zip contains a single top-level folder (e.g. Build26-LAB540-main).
    # Extract to a temp location, then move that folder to the exact target path.
    if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
    Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force

    $extracted = Get-ChildItem $tempExtract | Select-Object -First 1
    if (Test-Path $destPath) { Remove-Item $destPath -Recurse -Force }
    Move-Item $extracted.FullName $destPath

    Log "Repo available at $destPath"
    Log "Install phase complete"
}
catch {
    Log "ERROR: $($_.Exception.Message)"
    throw
}
finally {
    Stop-Transcript | Out-Null
}