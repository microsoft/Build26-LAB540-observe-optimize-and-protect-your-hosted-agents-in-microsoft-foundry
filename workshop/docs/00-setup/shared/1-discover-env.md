# Shared Step 1 — Populate `.env`

The `scripts/discover-env.sh` script inspects your live Azure environment
(either the Skillable-provisioned RG or your `azd up` result) and writes a
`.env` file at the repo root with everything the labs need.

## 1.1 — Run the discovery script

From the **repo root** (not `zava/`):

```bash
chmod +x scripts/discover-env.sh
./scripts/discover-env.sh
```

The script is **path-aware**:

- **Self-Guided path**: It detects `zava/.azure/<envname>/` and pulls
  values straight from your azd environment — no prompting.
- **Skillable path**: It falls back to interactive prompts (subscription,
  resource group) and discovers the rest (project endpoint, ACR, App
  Insights, model deployment name) automatically.

## 1.2 — What gets written

`.env` at the repo root contains:

```
AZURE_SUBSCRIPTION_ID=...
AZURE_RESOURCE_GROUP=...
AZURE_LOCATION=...
AZURE_AI_PROJECT_ENDPOINT=...
AZURE_AI_MODEL_DEPLOYMENT_NAME=gpt-4.1-mini
AZURE_CONTAINER_REGISTRY_NAME=...
AZURE_CONTAINER_REGISTRY_LOGIN_SERVER=...
APPLICATIONINSIGHTS_CONNECTION_STRING=...
FOUNDRY_AGENT_ID=...
```

> 🔒 `.env` is gitignored. Never commit it.

## 1.3 — Verify

```bash
# Load the file into your shell
set -a; source .env; set +a

# Spot-check
echo "RG:         $AZURE_RESOURCE_GROUP"
echo "Endpoint:   $AZURE_AI_PROJECT_ENDPOINT"
echo "Deployment: $AZURE_AI_MODEL_DEPLOYMENT_NAME"
echo "ACR:        $AZURE_CONTAINER_REGISTRY"
```

All four should print non-empty values.

## ✅ Checkpoint

- [ ] `.env` exists at the repo root
- [ ] All four spot-checked variables are populated
- [ ] No error messages from `discover-env.sh`

---

**Next**: [Step 2 — Open three browser tabs →](./2-three-tabs.md)
