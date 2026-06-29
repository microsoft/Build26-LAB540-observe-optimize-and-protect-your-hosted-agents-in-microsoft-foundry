# Activate Copilot

You'll drive the optimize loop by talking to **GitHub Copilot**, which uses the
**Foundry MCP** and the **microsoft-foundry** skill to do the work.

1. [] Open **Copilot Chat** (Ctrl+Alt+I) and switch to **Agent** mode.
1. [] Say hello to confirm it's responding - wait till it's ready:

   +++Hello!+++

## Enable Foundry MCP Server

1. [] Make sure the **Foundry MCP server** is enabled (check the tools/MCP
   picker in Copilot Chat).

   When you say hello, the chat will prompt you to **activate the Foundry MCP
   server** — choose **Yes**. This starts an authentication flow; **sign in with
   the same credential you used for Azure**.

   ![The Foundry MCP server activation prompt and sign-in flow](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-03-mcp-activation.png)

## Select Chat Model

>[!Alert] You may see Copilot try to enforce a different model (e.g., **Codestral** or **Fable**) as the default model
> and show an error related to downloads. Just dismiss these — **start a new chat session** and explicitly
> pick **Claude Sonnet 4.6** as the model.

1. [] Set the chat **model** to **Claude Sonnet 4.6**.

   ![Copilot Chat in Agent mode with the Foundry MCP enabled](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-03-open-copilot-chat.png)

1. [] **Speed things up.** Below the Copilot Chat input box, click the
   **Default Approvals** control and switch it to **Bypass Approvals**. The Observe skill runs many steps, and this lets Copilot run tools without asking you to confirm each one. *If you start a new Copilot session, you will need to repeat this action to change the default*.

   ![Switching from Default Approvals to Bypass Approvals in Copilot Chat](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-03-bypass-approvals.png)


## Use Copilot To Recreate **.azure**

Our infrastructure was _pre-provisioned_ by the Azure Developer CLI (azd) using the code under the **zava/** folder. We will need to _redeploy_ this during the optimize loop — but we lack the default **.azure** folder with the default configuration information.

Let's ask Copilot to help us recreate it before we begin optimization.

- [] Click to type this prompt into Copilot Chat: +++I just recreated the .env file for this project. I previously deployed my agent to this resource group from the zava/ folder Use "azd init" and "azd ai agent init --project-id" to refresh the "zava/.azure/" folder from my azd provisioned project. Set ENABLE_CAPABILITY_HOST="false" and ENABLE_HOSTED_AGENTS="true". Make sure these variables are also defined: AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID,  AZURE_AI_PROJECT_NAME, AZURE_AI_PROJECT_ID, AZURE_AI_PROJECT_ENDPOINT, AZURE_AI_PROJECT_ACR_CONNECTION_NAME,  AZURE_AI_FOUNDRY_PROJECT_ID, FOUNDRY_PROJECT_ENDPOINT, AZURE_ENV_NAME, AZURE_LOCATION, AZURE_OPENAI_ENDPOINT, and AZURE_RESOURCE_GROUP+++
- [] Verify that the **zava/.azure** folder is created and that a subfolder exists for the **rg-lab540-XXX** environment for your deployed project.

>[!Hint] The **azd** tool is evolving rapidly which means we may still encounter errors or undocumented behaviors. That's okay. GitHub Copilot is equipped with the right context (via MCP servers) to figure out alternative ways to get the task completed. Just give it time to finish.


>[!Alert] If GitHub Copilot execution itself fails for any reason, raise your hand and ask a proctor for help.

---

> ✅ **Success:** Copilot is in Agent mode, the Foundry MCP is enabled, the model
> is set, and approvals are bypassed.
