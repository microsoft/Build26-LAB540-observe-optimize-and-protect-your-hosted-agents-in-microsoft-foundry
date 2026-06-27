# Activate Copilot

You'll drive the optimize loop by talking to **GitHub Copilot**, which uses the
**Foundry MCP** and the `microsoft-foundry` skill to do the work.

1. [] Open **Copilot Chat** (Ctrl+Alt+I) and switch to **Agent** mode.
1. [] Say hello to confirm it's responding - wait till it's ready:

   ++Hello!++

1. [] Make sure the **Foundry MCP server** is enabled (check the tools/MCP
   picker in Copilot Chat).

   When you say hello, the chat will prompt you to **activate the Foundry MCP
   server** — choose **Yes**. This starts an authentication flow; **sign in with
   the same credential you used for Azure**.

   ![The Foundry MCP server activation prompt and sign-in flow](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-03-mcp-activation.png)
1. [] Set the chat **model** to **Claude Sonnet 4.6**.

>[!Alert] You may see Copilot try to enforce **Codestral** as the default model
> and show an error. Ignore it — **start a new chat session** and explicitly
> pick **Claude Sonnet 4.6** as the model.

![Copilot Chat in Agent mode with the Foundry MCP enabled](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-03-open-copilot-chat.png)

1. [] **Speed things up.** Below the Copilot Chat input box, click the
   **Default Approvals** control and switch it to **Bypass Approvals**. The
   Observe skill runs many steps, and this lets Copilot run tools without asking
   you to confirm each one.

![Switching from Default Approvals to Bypass Approvals in Copilot Chat](https://raw.githubusercontent.com/microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry/aiewf26-refresh/workshop/self-guided/images/03-optimize-03-bypass-approvals.png)

---

> ✅ **Success:** Copilot is in Agent mode, the Foundry MCP is enabled, the model
> is set, and approvals are bypassed.
