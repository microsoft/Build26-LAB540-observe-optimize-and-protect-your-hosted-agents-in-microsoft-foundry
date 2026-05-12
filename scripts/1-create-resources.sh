#!/usr/bin/env bash
# =======================================================================
#  Microsoft Foundry Observability Workshop — Create ACR & Assign Roles
# =======================================================================
#  This script automates section 0.5 (Create ACR & Roles) of Module 0:
#    1. Creates an Azure Container Registry (Basic SKU)
#       in the same resource group as your Foundry project
#    2. Discovers the Foundry managed identity
#    3. Assigns all required RBAC roles:
#       - Container Registry Repository Reader → ACR
#       - AcrPull → ACR (Foundry hosted agents need this to pull images)
#       - Cognitive Services OpenAI User → AI Services
#       - Monitoring Metrics Publisher → Resource Group
#    4. Creates a Log Analytics workspace + Application Insights
#       resource for Foundry tracing (if not pre-existing)
#    5. Logs into the ACR so Docker pushes work
#
#  Usage:
#    chmod +x scripts/create-acr.sh
#    ./scripts/create-acr.sh
#
#  Prerequisites:
#    - Azure CLI (az) installed and logged in
#    - .env file at the repo root (run scripts/setup-env.sh first)
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  🏕️ Foundry Observability Workshop —  Create ACR & Assign Roles  ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ────────────────────────────────────────────────────────────
#  Load .env
# ────────────────────────────────────────────────────────────
if [ -f "${ENV_FILE}" ]; then
    set -a
    # shellcheck disable=SC1090
    source "${ENV_FILE}"
    set +a
    echo -e "${GREEN}  ✓ Loaded .env${NC}"
else
    echo -e "${RED}  ✗ .env not found at ${ENV_FILE}${NC}"
    echo "    Run scripts/setup-env.sh first."
    exit 1
fi

# ────────────────────────────────────────────────────────────
#  Validate required variables
# ────────────────────────────────────────────────────────────
MISSING=0
for var in AZURE_RESOURCE_GROUP AZURE_AI_PROJECT_ENDPOINT AZURE_SUBSCRIPTION_ID; do
    val="${!var:-}"
    if [ -z "${val}" ]; then
        echo -e "${RED}  ✗ ${var} is not set in .env${NC}"
        MISSING=$((MISSING + 1))
    fi
done
if [ "${MISSING}" -gt 0 ]; then
    echo -e "${RED}  Fix the missing values in .env and re-run.${NC}"
    exit 1
fi

# ────────────────────────────────────────────────────────────
#  Step 1: Check Azure CLI login (note: total = 7 steps)
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[1/7]${NC} Checking Azure CLI authentication..."

if ! az account show &> /dev/null; then
    echo -e "${YELLOW}  ⚠ Not logged in. Running 'az login --use-device-code'...${NC}"
    az login --use-device-code || { echo -e "${RED}  ✗ Login failed.${NC}"; exit 1; }
fi

az account set --subscription "${AZURE_SUBSCRIPTION_ID}"
SUBSCRIPTION_NAME=$(az account show --query "name" -o tsv 2>/dev/null)
echo -e "${GREEN}  ✓ Subscription: ${SUBSCRIPTION_NAME} (${AZURE_SUBSCRIPTION_ID})${NC}"

# ────────────────────────────────────────────────────────────
#  Step 2: Determine ACR name
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[2/7]${NC} Determining ACR name..."

ACR_NAME="${AZURE_CONTAINER_REGISTRY_NAME:-}"

if [ -z "${ACR_NAME}" ]; then
    # Try to find an existing ACR in the resource group
    ACR_NAME=$(az acr list \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --query "[0].name" \
        -o tsv 2>/dev/null || echo "")

    if [ -n "${ACR_NAME}" ]; then
        echo -e "${GREEN}  ✓ Found existing ACR: ${ACR_NAME}${NC}"
    else
        # Generate a name from the resource group (only a-z0-9, max 50 chars)
        ACR_NAME=$(echo "${AZURE_RESOURCE_GROUP}" | tr -cd 'a-zA-Z0-9' | tr '[:upper:]' '[:lower:]')
        ACR_NAME="${ACR_NAME}acr"
        ACR_NAME="${ACR_NAME:0:50}"
        echo -e "${YELLOW}  No ACR found. Will create: ${ACR_NAME}${NC}"
    fi
fi

# ────────────────────────────────────────────────────────────
#  Step 3: Create ACR (if it doesn't exist)
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[3/7]${NC} Creating Azure Container Registry..."

if az acr show --name "${ACR_NAME}" --resource-group "${AZURE_RESOURCE_GROUP}" &>/dev/null; then
    echo -e "${GREEN}  ✓ ACR '${ACR_NAME}' already exists${NC}"
else
    # Get the region from the resource group
    REGION=$(az group show --name "${AZURE_RESOURCE_GROUP}" --query "location" -o tsv 2>/dev/null)
    echo -e "  Creating ACR '${ACR_NAME}' in ${REGION} (Basic SKU)..."

    az acr create \
        --name "${ACR_NAME}" \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --location "${REGION}" \
        --sku Basic \
        -o none

    echo -e "${GREEN}  ✓ ACR '${ACR_NAME}' created${NC}"
fi

# Update .env with ACR name if empty
CURRENT_ACR=$(grep "^AZURE_CONTAINER_REGISTRY_NAME=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"' || echo "")
if [ -z "${CURRENT_ACR}" ]; then
    sed -i "s|^AZURE_CONTAINER_REGISTRY_NAME=.*|AZURE_CONTAINER_REGISTRY_NAME=\"${ACR_NAME}\"|" "${ENV_FILE}"
    echo -e "${GREEN}  ✓ Updated .env with AZURE_CONTAINER_REGISTRY_NAME=${ACR_NAME}${NC}"
fi

# ────────────────────────────────────────────────────────────
#  Step 4: Discover the Foundry managed identity
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[4/7]${NC} Discovering Foundry managed identity..."

# Extract the AI Services account name from the project endpoint
# Format: https://<account>.services.ai.azure.com/api/projects/<project>
AI_ACCOUNT_NAME=$(echo "${AZURE_AI_PROJECT_ENDPOINT}" | sed -n 's|https://\([^.]*\)\.services\.ai\.azure\.com.*|\1|p')

if [ -z "${AI_ACCOUNT_NAME}" ]; then
    echo -e "${RED}  ✗ Could not parse AI Services account from AZURE_AI_PROJECT_ENDPOINT${NC}"
    echo "    Expected format: https://<account>.services.ai.azure.com/api/projects/<project>"
    exit 1
fi

echo -e "${GREEN}  ✓ AI Services account: ${AI_ACCOUNT_NAME}${NC}"

# Get the principal ID of the system-assigned managed identity
PRINCIPAL_ID=$(az cognitiveservices account show \
    --name "${AI_ACCOUNT_NAME}" \
    --resource-group "${AZURE_RESOURCE_GROUP}" \
    --query "identity.principalId" \
    -o tsv 2>/dev/null || echo "")

if [ -z "${PRINCIPAL_ID}" ]; then
    echo -e "${YELLOW}  ⚠ No system-assigned identity found. Enabling it...${NC}"
    az cognitiveservices account identity assign \
        --name "${AI_ACCOUNT_NAME}" \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --system-assigned \
        -o none 2>/dev/null || true

    PRINCIPAL_ID=$(az cognitiveservices account show \
        --name "${AI_ACCOUNT_NAME}" \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --query "identity.principalId" \
        -o tsv 2>/dev/null || echo "")
fi

if [ -z "${PRINCIPAL_ID}" ]; then
    echo -e "${RED}  ✗ Could not retrieve managed identity principal ID.${NC}"
    exit 1
fi

echo -e "${GREEN}  ✓ Principal ID: ${PRINCIPAL_ID}${NC}"

# ────────────────────────────────────────────────────────────
#  Step 5: Assign RBAC roles
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[5/7]${NC} Assigning RBAC roles..."

assign_role() {
    local role="$1"
    local scope="$2"
    local label="$3"

    EXISTING=$(az role assignment list \
        --assignee "${PRINCIPAL_ID}" \
        --role "${role}" \
        --scope "${scope}" \
        --query "length([])" \
        -o tsv 2>/dev/null || echo "0")

    if [ "${EXISTING}" -gt 0 ]; then
        echo -e "${GREEN}  ✓ ${label}: already assigned${NC}"
    else
        az role assignment create \
            --assignee-object-id "${PRINCIPAL_ID}" \
            --assignee-principal-type ServicePrincipal \
            --role "${role}" \
            --scope "${scope}" \
            -o none 2>/dev/null
        echo -e "${GREEN}  ✓ ${label}: assigned${NC}"
    fi
}

# Role 1: Container Registry Repository Reader → ACR
ACR_ID=$(az acr show \
    --name "${ACR_NAME}" \
    --resource-group "${AZURE_RESOURCE_GROUP}" \
    --query "id" -o tsv 2>/dev/null)

assign_role \
    "Container Registry Repository Reader" \
    "${ACR_ID}" \
    "Container Registry Repository Reader → ACR"

# Role 1b: AcrPull → ACR (needed for Foundry hosted agents to pull container images)
assign_role \
    "AcrPull" \
    "${ACR_ID}" \
    "AcrPull → ACR"

# Role 2: Cognitive Services OpenAI User → AI Services account
AI_ACCOUNT_ID=$(az cognitiveservices account show \
    --name "${AI_ACCOUNT_NAME}" \
    --resource-group "${AZURE_RESOURCE_GROUP}" \
    --query "id" -o tsv 2>/dev/null)

assign_role \
    "Cognitive Services OpenAI User" \
    "${AI_ACCOUNT_ID}" \
    "Cognitive Services OpenAI User → AI Services"

# Role 3: Monitoring Metrics Publisher → Resource Group
RG_ID="/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_RESOURCE_GROUP}"

assign_role \
    "Monitoring Metrics Publisher" \
    "${RG_ID}" \
    "Monitoring Metrics Publisher → Resource Group"

# ────────────────────────────────────────────────────────────
#  Step 6: Create Log Analytics workspace + Application Insights
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[6/7]${NC} Setting up Application Insights for Foundry tracing..."

# Ensure the application-insights CLI extension is available
az extension add --name application-insights --yes 2>/dev/null || true

REGION="${REGION:-$(az group show --name "${AZURE_RESOURCE_GROUP}" --query location -o tsv 2>/dev/null)}"

# ── Determine names (reuse existing if present, otherwise derive from RG) ──
RG_SLUG=$(echo "${AZURE_RESOURCE_GROUP}" | tr -cd 'a-zA-Z0-9-' | tr '[:upper:]' '[:lower:]')
LAW_NAME="${AZURE_LOG_ANALYTICS_WORKSPACE_NAME:-}"
APPINSIGHTS_NAME="${AZURE_APPLICATION_INSIGHTS_NAME:-}"

if [ -z "${LAW_NAME}" ]; then
    LAW_NAME=$(az monitor log-analytics workspace list \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --query "[0].name" -o tsv 2>/dev/null || echo "")
    if [ -z "${LAW_NAME}" ]; then
        LAW_NAME="${RG_SLUG}-law"
        LAW_NAME="${LAW_NAME:0:63}"
    fi
fi

if [ -z "${APPINSIGHTS_NAME}" ]; then
    APPINSIGHTS_NAME=$(az resource list \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --resource-type "Microsoft.Insights/components" \
        --query "[0].name" -o tsv 2>/dev/null || echo "")
    if [ -z "${APPINSIGHTS_NAME}" ]; then
        APPINSIGHTS_NAME="${RG_SLUG}-appi"
        APPINSIGHTS_NAME="${APPINSIGHTS_NAME:0:255}"
    fi
fi

# ── Create Log Analytics workspace (workspace-based App Insights requires one) ──
if az monitor log-analytics workspace show \
     --resource-group "${AZURE_RESOURCE_GROUP}" \
     --workspace-name "${LAW_NAME}" &>/dev/null; then
    echo -e "${GREEN}  ✓ Log Analytics workspace '${LAW_NAME}' already exists${NC}"
else
    echo -e "  Creating Log Analytics workspace '${LAW_NAME}' in ${REGION}..."
    az monitor log-analytics workspace create \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --workspace-name "${LAW_NAME}" \
        --location "${REGION}" \
        -o none
    echo -e "${GREEN}  ✓ Log Analytics workspace '${LAW_NAME}' created${NC}"
fi

LAW_ID=$(az monitor log-analytics workspace show \
    --resource-group "${AZURE_RESOURCE_GROUP}" \
    --workspace-name "${LAW_NAME}" \
    --query id -o tsv)

# ── Create Application Insights (workspace-based) ──
if az monitor app-insights component show \
     --app "${APPINSIGHTS_NAME}" \
     --resource-group "${AZURE_RESOURCE_GROUP}" &>/dev/null; then
    echo -e "${GREEN}  ✓ Application Insights '${APPINSIGHTS_NAME}' already exists${NC}"
else
    echo -e "  Creating Application Insights '${APPINSIGHTS_NAME}' in ${REGION}..."
    az monitor app-insights component create \
        --app "${APPINSIGHTS_NAME}" \
        --resource-group "${AZURE_RESOURCE_GROUP}" \
        --location "${REGION}" \
        --kind web \
        --application-type web \
        --workspace "${LAW_ID}" \
        -o none
    echo -e "${GREEN}  ✓ Application Insights '${APPINSIGHTS_NAME}' created${NC}"
fi

APPINSIGHTS_CONNECTION_STRING=$(az monitor app-insights component show \
    --app "${APPINSIGHTS_NAME}" \
    --resource-group "${AZURE_RESOURCE_GROUP}" \
    --query connectionString -o tsv 2>/dev/null || echo "")

# ── Persist names + connection string to .env (only if empty) ──
upsert_env() {
    local key="$1"
    local value="$2"
    if grep -q "^${key}=" "${ENV_FILE}"; then
        local current
        current=$(grep "^${key}=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"')
        if [ -z "${current}" ]; then
            # Escape | and & for sed replacement
            local escaped
            escaped=$(printf '%s' "${value}" | sed -e 's/[\/&|]/\\&/g')
            sed -i "s|^${key}=.*|${key}=\"${escaped}\"|" "${ENV_FILE}"
            echo -e "${GREEN}  ✓ Updated .env: ${key}${NC}"
        fi
    else
        echo "${key}=\"${value}\"" >> "${ENV_FILE}"
        echo -e "${GREEN}  ✓ Added .env: ${key}${NC}"
    fi
}

upsert_env "AZURE_LOG_ANALYTICS_WORKSPACE_NAME" "${LAW_NAME}"
upsert_env "AZURE_APPLICATION_INSIGHTS_NAME" "${APPINSIGHTS_NAME}"
if [ -n "${APPINSIGHTS_CONNECTION_STRING}" ]; then
    upsert_env "TELEMETRY_CONNECTION_STRING" "${APPINSIGHTS_CONNECTION_STRING}"
fi

# ────────────────────────────────────────────────────────────
#  Step 7: Log in to ACR & summary
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[7/7]${NC} Logging in to ACR..."

az acr login --name "${ACR_NAME}" 2>/dev/null && \
    echo -e "${GREEN}  ✓ Docker logged in to ${ACR_NAME}.azurecr.io${NC}" || \
    echo -e "${YELLOW}  ⚠ ACR login skipped (Docker may not be available — this is OK in Codespaces)${NC}"

echo ""
echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
echo -e "${CYAN}  ✅ ACR, RBAC & App Insights setup complete!${NC}"
echo ""
echo -e "${CYAN}  ACR:           ${ACR_NAME}.azurecr.io${NC}"
echo -e "${CYAN}  Identity:      ${AI_ACCOUNT_NAME} (${PRINCIPAL_ID:0:8}...)${NC}"
echo -e "${CYAN}  Log Analytics: ${LAW_NAME}${NC}"
echo -e "${CYAN}  App Insights:  ${APPINSIGHTS_NAME}${NC}"
echo -e "${CYAN}  Roles:         Container Registry Repository Reader${NC}"
echo -e "${CYAN}                 AcrPull${NC}"
echo -e "${CYAN}                 Cognitive Services OpenAI User${NC}"
echo -e "${CYAN}                 Monitoring Metrics Publisher${NC}"
echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
echo ""
