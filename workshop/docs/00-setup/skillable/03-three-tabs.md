## Open the three browser tabs

You'll move between three places throughout the workshop. Open all three
now so you can switch quickly.

### Tab 1 — Codespace (already open)

You should already have your Codespace open in a browser tab. Keep the
integrated terminal visible — most lab steps run there.

- [] Codespace tab is open with a terminal visible.

### Tab 2 — Microsoft Foundry portal

In your Codespace terminal, print your Foundry portal link:

++echo "$FOUNDRY_PORTAL_URL"++

Copy the URL it prints and open it in a new browser tab. Sign in with
the same account you're using for Azure CLI.

You should see:

- Your Foundry project
- The `gpt-4.1-mini` model deployment under **Models + endpoints**
- The **Zava Travel Concierge** under **Agents**

- [] Foundry portal is open and shows my project, model, and agent.

### Tab 3 — Azure Portal

Print the direct link to your resource group:

++echo "$AZURE_PORTAL_RG_URL"++

Open the URL in another new tab. Sign in with the Azure portal
credentials from the **Resources** tab:

- Username: ++@lab.CloudPortalCredential(User1).Username++
- Password: ++@lab.CloudPortalCredential(User1).Password++

You'll use this tab during the labs to inspect **Application Insights**
traces and the **Azure Container Registry**.

- [] Azure portal is open on my resource group.

> [!Knowledge] Why three tabs?
> Foundry runs your agent and shows eval results. Codespace runs your
> code and scripts. Azure portal shows raw telemetry. You'll bounce
> between all three during evaluation and optimization.

### ✅ Final setup checkpoint

Before moving to Lab 1, confirm:

- [] Codespace + terminal open
- [] `.env` populated and sourced
- [] Foundry portal shows my project + agent
- [] Azure portal shows my resource group
- [] Docker is running (++docker info++ succeeds)

### Next step — start Lab 1

In your Codespace, open this file and follow it:

++workshop/docs/core/lab-1.md++

Or, in any GitHub Copilot Chat window, just say:

+++Run the workshop+++

…and the `run-workshop` skill will take it from here.

