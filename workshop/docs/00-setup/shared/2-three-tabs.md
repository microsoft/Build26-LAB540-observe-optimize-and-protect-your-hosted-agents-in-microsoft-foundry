# Shared Step 2 — Open the Three Browser Tabs

Throughout the labs you'll move between three places. Open all three now
so you can switch quickly with <kbd>Cmd/Ctrl</kbd>+<kbd>Tab</kbd>.

## Tab 1 — Codespace (or local VS Code)

You should already have this open. Keep the integrated terminal visible —
most lab steps run there.

## Tab 2 — Microsoft Foundry portal

Open your Foundry project in the browser. The discover script already
stashed a direct link in your `.env`:

```bash
echo "$FOUNDRY_PORTAL_URL"
```

Copy the URL and open it in a new tab. Sign in with the same account
you used for `az login`. You should see your project, the
`gpt-4.1-mini` deployment, and the **Agents** section listing the
Zava Travel Concierge.

> **Self-Guided heads-up**: `azd up` also printed a portal link at the
> end of provisioning — either link works.

## Tab 3 — Azure Portal

Open the direct link to your resource group:

```bash
echo "$AZURE_PORTAL_RG_URL"
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
