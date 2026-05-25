## Populate the .env file

Most workshop scripts and labs read settings from a `.env` file at the
repo root. The `discover-env.sh` script inspects your pre-provisioned
resource group and writes that file for you.

### 1. Run the discovery script

From the **repo root** in your Codespace terminal:

++chmod +x scripts/discover-env.sh && ./scripts/discover-env.sh++

The script will detect that no `azd` environment exists (because the lab
is pre-provisioned rather than provisioned by you), and will prompt you
for the resource group name. Use:

++@lab.CloudResourceGroup(ResourceGroup1).Name++

It then auto-discovers the Foundry project endpoint, ACR name, App
Insights connection string, and the `gpt-4.1-mini` model deployment
name — no further prompts.

- [] `discover-env.sh` finished without errors.

### 2. Verify the .env

Load the file and spot-check the key values:

++set -a; source .env; set +a++

++echo "RG:         $AZURE_RESOURCE_GROUP" && echo "Endpoint:   $AZURE_AI_PROJECT_ENDPOINT" && echo "Deployment: $AZURE_AI_MODEL_DEPLOYMENT_NAME" && echo "ACR:        $AZURE_CONTAINER_REGISTRY_NAME"++

All four lines should print a non-empty value.

> [!Knowledge] What's in .env
> The script writes these variables: `AZURE_SUBSCRIPTION_ID`,
> `AZURE_RESOURCE_GROUP`, `AZURE_LOCATION`,
> `AZURE_AI_PROJECT_ENDPOINT`, `AZURE_AI_MODEL_DEPLOYMENT_NAME`,
> `AZURE_CONTAINER_REGISTRY_NAME`, `APPLICATIONINSIGHTS_CONNECTION_STRING`,
> and `FOUNDRY_AGENT_ID`.

> [!Alert] .env is gitignored
> Never commit `.env`. It contains endpoint URLs (not secrets) but
> still shouldn't be checked in.

- [] All four spot-check values are populated.

===

