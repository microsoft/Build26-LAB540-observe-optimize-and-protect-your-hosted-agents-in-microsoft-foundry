# Self-Guided Step 3 — Provision with `azd up`

`azd up` reads the Bicep templates in `zava/infra/` and the agent manifest
in `zava/src/zava-travel-concierge/agent.manifest.yaml`. In one command it:

1. Creates a Microsoft Foundry project, model deployment, ACR, App Insights
   and supporting resources.
2. Builds and pushes the Zava Travel Concierge container image to ACR.
3. Registers and starts the hosted agent in Foundry.

## 3.1 — Choose a region

This workshop is region-restricted to three Foundry **Hosted Agents**
preview regions, all of which have `gpt-4.1-mini` GlobalStandard quota:

| Region | Best for | Notes |
|--------|----------|-------|
| `eastus2` *(default)* | US — broad tool support | Default; widest hosted-agent tool surface |
| `swedencentral` | Europe — data residency | Full hosted-agent feature parity |
| `northcentralus` | US — backup capacity | Use if `eastus2` quota is tight |

> 📚 See [`zava/README.md`](../../../../zava/README.md) §4.4 for the source
> Microsoft Learn references.

## 3.2 — Initialize the azd environment

From the repo root:

```bash
cd zava
azd env new lab540   # name can be anything; "lab540" is fine
```

You'll be asked for:

- Azure subscription → pick yours
- Region → press Enter to accept `eastus2`, or type one of the three
  supported regions above

## 3.3 — Provision + deploy

Still inside `zava/`:

```bash
azd up
```

This takes ~5–8 minutes. You'll see Bicep provisioning, then a Docker
build + push, then the agent registration.

## 3.4 — Confirm the agent is running

```bash
azd env get-values | grep -E '^(AZURE_AI_PROJECT_ENDPOINT|FOUNDRY_AGENT_ID)='
```

You should see both variables populated. Visit the **Foundry portal** link
printed at the end of `azd up` to see your project and the running agent.

## ✅ Checkpoint

- [ ] `azd up` completed without errors
- [ ] `AZURE_AI_PROJECT_ENDPOINT` is set in the azd env
- [ ] `FOUNDRY_AGENT_ID` is set in the azd env
- [ ] The Foundry portal shows your project and agent

---

**Next**: [Shared Step 1 — Populate `.env` →](../shared/1-discover-env.md)
