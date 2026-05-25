# Self-Guided Step 2 — Sign in to Azure

You need to be signed in to **both** Azure CLI (`az`) and Azure Developer
CLI (`azd`) — they maintain separate auth contexts.

## 2.1 — Sign in to Azure CLI

```bash
az login
```

If you're in a Codespace (no local browser):

```bash
az login --use-device-code
```

Then pick the subscription you'll provision resources into:

```bash
# Show all subscriptions you can access
az account list --query '[].{name:name, id:id, default:isDefault}' -o table

# Set the active subscription (use the name or id from the list above)
az account set --subscription "<NAME_OR_ID>"

# Confirm
az account show --query '{name:name, id:id}' -o table
```

## 2.2 — Sign in to Azure Developer CLI

```bash
azd auth login
```

(Or `azd auth login --use-device-code` in a Codespace.)

## 2.3 — Confirm `azd` ≥ 1.25 + AI extension

This workshop uses the hosted-agent features in the
`azure.ai.agents` extension (preview).

```bash
azd version
```

You should see `1.25.x` or later. If `azd` is older, update before
continuing.

## ✅ Checkpoint

- [ ] `az account show` returns the subscription you want
- [ ] `azd auth login` succeeded
- [ ] `azd version` is ≥ 1.25

---

**Next**: [Step 3 — Provision with `azd up` →](./3-azd-up.md)
