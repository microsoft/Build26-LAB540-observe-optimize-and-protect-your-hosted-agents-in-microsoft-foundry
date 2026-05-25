# Shared Step 2 — Open the Three Browser Tabs

Throughout the labs you'll move between three places. Open all three now
so you can switch quickly with <kbd>Cmd/Ctrl</kbd>+<kbd>Tab</kbd>.

## Tab 1 — Codespace (or local VS Code)

You should already have this open. Keep the integrated terminal visible —
most lab steps run there.

## Tab 2 — Microsoft Foundry portal

Open your Foundry project in the browser.

**Self-Guided**: `azd up` printed a Foundry portal link at the end.
Open it.

**Skillable**: The portal URL is embedded in your `.env`:

```bash
# Print the portal URL derived from your project endpoint
PROJECT_NAME="${AZURE_AI_PROJECT_ENDPOINT#https://}"
PROJECT_NAME="${PROJECT_NAME%%.*}"
echo "https://ai.azure.com/build/overview?wsid=/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_RESOURCE_GROUP}/providers/Microsoft.CognitiveServices/accounts/${PROJECT_NAME}"
```

Sign in with the same account you used for `az login`. You should see
your project, the `gpt-4.1-mini` deployment, and the **Agents** section
listing the Zava Travel Concierge.

## Tab 3 — Azure Portal

Open <https://portal.azure.com>, sign in, and pin your resource group:

```bash
# Print the direct RG link
echo "https://portal.azure.com/#@/resource/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_RESOURCE_GROUP}/overview"
```

You'll use this to check **Application Insights** traces and **Azure
Container Registry** during the labs.

## ✅ Final Setup Checkpoint

You're ready to start Lab 1 when:

- [ ] Codespace + terminal open
- [ ] `.env` populated and sourced
- [ ] Foundry portal open and showing your project + agent
- [ ] Azure portal open on your resource group
- [ ] Docker is running (`docker info` succeeds)

---

**Next**: [Lab 1 — Deploy & Validate →](../../core/lab-1.md)
