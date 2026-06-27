# Deploy Infrastructure

Now provision everything with a single command. `azd up` creates the resource
group, Foundry account and project, model deployment, container registry, and
Application Insights — then builds, pushes, and publishes the hosted agent.

1. Change into the `zava` folder:

   ```bash
   cd zava
   ```

2. Run the deployment:

   ```bash
   azd up
   ```

3. When prompted, provide:
   - An **environment name** (e.g. `lab540`).
   - A **region** — pick **`eastus2`** if you're unsure.
4. You should see a `zava/.azure/` folder created with config info

<!-- TODO screenshot: azd up output with endpoint and playground link -->

> [!NOTE]
> `azd up` does a lot in one shot: provisions the Bicep infrastructure, builds
> the container image (remote build in ACR — no local Docker needed), pushes it,
> and publishes the agent to Foundry as **`zava-concierge`**. This takes several
> minutes.

> [!IMPORTANT]
> When it finishes, the output prints the **Foundry project endpoint**, the
> **agent name**, and a **direct link to the playground**. Keep this handy — you
> just deployed the hosted agent.

<details>
   <summary> Click HERE to example and see sample output </summary>

   The output will look something like this - identifiers truncated for clarity.

   ```bash
   Provisioning and deploying (azd up)
   Packaging overlaps with provisioning for faster execution.

   
   You can view detailed progress in the Azure Portal:
   https://portal.azure.com/#view/HubsExtension/DeploymentDetailsBlade/~/overview/id/%2Fsubscriptions%....

   (✓) Done: Resource group: rg-lab540-aiewf26 (618ms)
   (✓) Done: Foundry: ai-account-syjnqq4yulcf2 (25.949s)
   (✓) Done: Log Analytics workspace: logs-syjnqq4yulcf2 (20.919s)
   (✓) Done: Azure AI Services Model Deployment: ai-account-syjnqq4yulcf2/gpt-5.4-mini (1.81s)
   (✓) Done: Foundry project: ai-account-syjnqq4yulcf2/ai-project-lab540-aiewf26 (8.544s)
   (✓) Done: Application Insights: appi-syjnqq4yulcf2 (2.219s)
   (✓) Done: Foundry project connection: ai-account-syjnqq4yulcf2/ai-project-lab540-aiewf26/appi-syjnqq4yulcf2 (5.756s)
   (✓) Done: Container Registry: crsyjnqq4yulcf2 (22.566s)
   (✓) Done: Foundry project connection: ai-account-syjnqq4yulcf2/ai-project-lab540-aiewf26/acr-uftasuq5gftsy (642ms)

   Service         Status        Duration
   ──────────────  ────────────  ──────────
   ● zava-concierge  Done          2m43s
   - Agent playground (portal): https://ai.azure.com/nextgen/.... 
   - Agent endpoint (responses): https://ai-account-...
      
   Next:
   azd ai agent show zava-concierge
   verify it's running

   see src/zava-travel-concierge/README.md
   find the sample-specific payload

   azd ai agent invoke zava-concierge '<payload>'
   test with the sample-specific payload


   SUCCESS: Your application was provisioned and deployed to Azure in 2 minutes 51 seconds.
   Provisioning: 1 minute 43 seconds
   Deploying:    2 minutes 50 seconds
   ```
   </details>

---

> ✅ **Success:** — the Zava Travel Concierge is deployed to Foundry.

---

[← Prev: Sign in to Azure](./01-setup-04.md) &nbsp;•&nbsp; 🏠 [Contents](./README.md) &nbsp;•&nbsp; [Next: Azure Portal →](./01-setup-06.md)
