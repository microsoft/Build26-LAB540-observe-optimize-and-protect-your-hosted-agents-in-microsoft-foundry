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

   <!-- TODO screenshot: Foundry MCP activation prompt / sign-in flow -->
1. [] Set the chat **model** to **Claude Sonnet 4.6**.

>[!Alert] You may see Copilot try to enforce **Codestral** as the default model
> and show an error. Ignore it — **start a new chat session** and explicitly
> pick **Claude Sonnet 4.6** as the model.

<!-- TODO screenshot: Copilot Chat in Agent mode with Foundry MCP enabled -->

1. [] **Speed things up.** Below the Copilot Chat input box, click the
   **Default Approvals** control and switch it to **Bypass Approvals**. The
   Observe skill runs many steps, and this lets Copilot run tools without asking
   you to confirm each one.

<!-- TODO screenshot: Default Approvals → Bypass Approvals toggle -->

---

> ✅ **Success:** Copilot is in Agent mode, the Foundry MCP is enabled, the model
> is set, and approvals are bypassed.
