# Step 2 — Sign in to Azure

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

The flow will end with you selecting the default subscription in your VS Code terminal. Verify that this was set correctly.

```bash
az account show --query '{name:name, id:id}' -o table
```

## 2.2 — Sign in to Azure Developer CLI

```bash
azd auth login
```

(Or `azd auth login --use-device-code` in a Codespace.)

## 2.3 — Confirm `azd` ≥ 1.25 + AI extension

This workshop uses the hosted-agent features in the
`azure.ai.agents` extension (preview). Check that this extension was installed in azd.

```bash
azd version
azd extension list
```

Else install it now - and verify.

```bash
azd extension install azure.ai.agents`
azd extension list
```

You should see azd version `1.25.x` or later - with extension version `0.1.34-preview` or later. If a newer azd version is available, you may be prompted to install it now.

## ✅ Checkpoint

- [ ] `az account show` returns the subscription you want
- [ ] `azd auth login` succeeded
- [ ] `azd extension list` shows `azure.ai.agents` is installed
- [ ] `azd version` is ≥ 1.25

---

**Next**: [Step 3 — Provision with `azd up` →](./3-azd-up.md)
