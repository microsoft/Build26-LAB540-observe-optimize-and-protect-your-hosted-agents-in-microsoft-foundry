#!/usr/bin/env bash
# =======================================================================
#  Microsoft Foundry Observability Workshop — Environment Configuration
# =======================================================================
#  This script:
#    1. Checks Azure CLI login status (prompts az login if needed)
#    2. Creates a .env file from sample.env (if it doesn't exist)
#    3. Auto-populates values it can discover via Azure CLI
#    4. Reports which values still need manual entry
#
#  Usage:
#    chmod +x scripts/setup-env.sh
#    ./scripts/setup-env.sh
#
#  Prerequisites:
#    - Azure CLI (az) installed and logged in
#    - A Microsoft Foundry project already created (see docs/README.md Module 0)
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"
SAMPLE_FILE="${SCRIPT_DIR}/sample.env"
AZD_ENV_DIR="${REPO_ROOT}/zava/.azure"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  🏕️ Foundry Observability Workshop — Environment Setup   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# ────────────────────────────────────────────────────────────
#  Step 1: Check Azure CLI login
# ────────────────────────────────────────────────────────────
echo -e "${BLUE}[1/6]${NC} Checking Azure CLI authentication..."

if ! command -v az &> /dev/null; then
    echo -e "${RED}  ✗ Azure CLI (az) is not installed.${NC}"
    echo "    Install it: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

if az account show &> /dev/null; then
    ACCOUNT_NAME=$(az account show --query "user.name" -o tsv 2>/dev/null || echo "unknown")
    SUBSCRIPTION_NAME=$(az account show --query "name" -o tsv 2>/dev/null || echo "unknown")
    echo -e "${GREEN}  ✓ Logged in as: ${ACCOUNT_NAME}${NC}"
    echo -e "${GREEN}  ✓ Subscription: ${SUBSCRIPTION_NAME}${NC}"
else
    echo -e "${YELLOW}  ⚠ Not logged in to Azure CLI.${NC}"
    echo -e "${YELLOW}    Running 'az login --use-device-code'...${NC}"
    echo ""
    az login --use-device-code || true
    echo ""
    if ! az account show &> /dev/null; then
        echo -e "${RED}  ✗ Azure login failed. Please try again.${NC}"
        exit 1
    fi
    ACCOUNT_NAME=$(az account show --query "user.name" -o tsv 2>/dev/null || echo "unknown")
    SUBSCRIPTION_NAME=$(az account show --query "name" -o tsv 2>/dev/null || echo "unknown")
    echo -e "${GREEN}  ✓ Login successful!${NC}"
    echo -e "${GREEN}  ✓ Logged in as: ${ACCOUNT_NAME}${NC}"
    echo -e "${GREEN}  ✓ Subscription: ${SUBSCRIPTION_NAME}${NC}"
fi

# ────────────────────────────────────────────────────────────
#  Step 2: Create .env from sample.env if it doesn't exist
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[2/6]${NC} Checking .env file..."

if [ ! -f "${SAMPLE_FILE}" ]; then
    echo -e "${RED}  ✗ sample.env not found at: ${SAMPLE_FILE}${NC}"
    echo "    Make sure you're running this script from the repository root."
    exit 1
fi

if [ ! -f "${ENV_FILE}" ]; then
    cp "${SAMPLE_FILE}" "${ENV_FILE}"
    echo -e "${GREEN}  ✓ Created .env from sample.env${NC}"
else
    echo -e "${GREEN}  ✓ .env already exists (will update empty values)${NC}"
    while IFS='=' read -r key value; do
        [[ "${key}" =~ ^#.*$ ]] && continue
        [[ -z "${key}" ]] && continue
        if ! grep -q "^${key}=" "${ENV_FILE}" 2>/dev/null; then
            echo "${key}=${value}" >> "${ENV_FILE}"
            echo -e "${GREEN}  + Added new key: ${key}${NC}"
        fi
    done < <(grep "^[A-Z]" "${SAMPLE_FILE}")
fi

# ────────────────────────────────────────────────────────────
#  Helper: set a value in .env only if currently empty
# ────────────────────────────────────────────────────────────
set_env_if_empty() {
    local key="$1"
    local value="$2"
    if ! grep -q "^${key}=" "${ENV_FILE}" 2>/dev/null; then
        echo "${key}=" >> "${ENV_FILE}"
    fi
    local current
    current=$(grep "^${key}=" "${ENV_FILE}" | cut -d'=' -f2-)
    if [ -z "${current}" ] && [ -n "${value}" ]; then
        sed -i "s|^${key}=.*|${key}=\"${value}\"|" "${ENV_FILE}"
        echo -e "${GREEN}  ✓ ${key} → ${value:0:60}${NC}"
        return 0
    elif [ -n "${current}" ]; then
        echo -e "${GREEN}  ✓ ${key} already set${NC}"
        return 0
    else
        return 1
    fi
}

# ────────────────────────────────────────────────────────────
#  Step 3: Detect azd env (self-guided path) and seed values
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[3/6]${NC} Looking for an existing azd environment..."

AZD_RG=""
AZD_LOCATION=""
AZD_SUB=""

if command -v azd &>/dev/null && [ -d "${AZD_ENV_DIR}" ]; then
    # `azd env get-values` must be run from the azd project dir (zava/).
    AZD_VALUES=$(cd "${REPO_ROOT}/zava" && azd env get-values 2>/dev/null || true)
    if [ -n "${AZD_VALUES}" ]; then
        AZD_ENV_NAME=$(cd "${REPO_ROOT}/zava" && azd env get-value AZURE_ENV_NAME 2>/dev/null || echo "")
        echo -e "${GREEN}  ✓ Found azd environment: ${AZD_ENV_NAME:-<default>}${NC}"
        AZD_RG=$(echo "${AZD_VALUES}" | grep '^AZURE_RESOURCE_GROUP_NAME=' | cut -d'=' -f2- | tr -d '"' || echo "")
        if [ -z "${AZD_RG}" ]; then
            AZD_RG=$(echo "${AZD_VALUES}" | grep '^AZURE_RESOURCE_GROUP=' | cut -d'=' -f2- | tr -d '"' || echo "")
        fi
        AZD_LOCATION=$(echo "${AZD_VALUES}" | grep '^AZURE_LOCATION=' | cut -d'=' -f2- | tr -d '"' || echo "")
        AZD_SUB=$(echo "${AZD_VALUES}" | grep '^AZURE_SUBSCRIPTION_ID=' | cut -d'=' -f2- | tr -d '"' || echo "")
        [ -n "${AZD_RG}" ]       && echo -e "${GREEN}    • RG:    ${AZD_RG}${NC}"
        [ -n "${AZD_LOCATION}" ] && echo -e "${GREEN}    • Loc:   ${AZD_LOCATION}${NC}"
        [ -n "${AZD_SUB}" ]      && echo -e "${GREEN}    • Sub:   ${AZD_SUB:0:8}...${NC}"
    else
        echo -e "${YELLOW}  ⚠ azd env directory exists but no values yet. Did you run 'cd zava && azd up'?${NC}"
    fi
else
    echo -e "${YELLOW}  — No azd environment detected (skillable / instructor-led path)${NC}"
fi

# Apply azd-discovered values to .env (only if .env is empty for those keys)
if [ -n "${AZD_SUB}" ]; then
    set_env_if_empty "AZURE_SUBSCRIPTION_ID" "${AZD_SUB}" || true
fi
if [ -n "${AZD_RG}" ]; then
    set_env_if_empty "AZURE_RESOURCE_GROUP" "${AZD_RG}" || true
fi
if [ -n "${AZD_LOCATION}" ]; then
    set_env_if_empty "AZURE_LOCATION" "${AZD_LOCATION}" || true
fi

# ────────────────────────────────────────────────────────────
#  Step 4: Auto-populate subscription info (fallback to current az context)
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[4/6]${NC} Auto-populating subscription info..."

SUB_ID=$(az account show --query "id" -o tsv 2>/dev/null || echo "")
set_env_if_empty "AZURE_SUBSCRIPTION_ID" "${SUB_ID}" || true

# ────────────────────────────────────────────────────────────
#  Step 5: Discover resources in resource group
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[5/6]${NC} Resource group discovery..."

# Check if resource group is already set
EXISTING_RG=$(grep "^AZURE_RESOURCE_GROUP=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"' || echo "")
if [ -n "${EXISTING_RG}" ]; then
    SELECTED_RG="${EXISTING_RG}"
    echo -e "${GREEN}  ✓ Using resource group from .env: ${SELECTED_RG}${NC}"
else
    read -rp "  Enter your Azure resource group name: " SELECTED_RG
    if [ -z "${SELECTED_RG}" ]; then
        echo -e "${RED}  ✗ Resource group name cannot be empty.${NC}"
        exit 1
    fi
fi

if ! az group show --name "${SELECTED_RG}" &>/dev/null; then
    echo -e "${RED}  ✗ Resource group '${SELECTED_RG}' not found.${NC}"
    echo -e "${RED}    Check the name and subscription.${NC}"
    exit 1
fi

echo -e "${GREEN}  ✓ Using resource group: ${SELECTED_RG}${NC}"
set_env_if_empty "AZURE_RESOURCE_GROUP" "${SELECTED_RG}" || true

# ── Find AI Services account ──
ACCOUNT_AI=$(az cognitiveservices account list \
    --resource-group "${SELECTED_RG}" \
    --query "[?kind=='AIServices' || kind=='OpenAI'] | [0].name" \
    -o tsv 2>/dev/null || echo "")

if [ -z "${ACCOUNT_AI}" ]; then
    echo -e "${YELLOW}  ⚠ No AI Services accounts found in '${SELECTED_RG}'.${NC}"
    echo -e "${YELLOW}    Set AZURE_AI_PROJECT_ENDPOINT manually in .env${NC}"
else
    echo -e "${GREEN}  ✓ AI Services account: ${ACCOUNT_AI}${NC}"

    # ── Find Foundry project endpoint ──
    PROJECT_ENDPOINTS=$(az cognitiveservices account project list \
        --name "${ACCOUNT_AI}" \
        --resource-group "${SELECTED_RG}" \
        --query '[].properties.endpoints."AI Foundry API"' -o tsv 2>/dev/null || echo "")

    if [ -n "${PROJECT_ENDPOINTS}" ]; then
        PROJECT_COUNT=$(echo "${PROJECT_ENDPOINTS}" | wc -l)
        if [ "${PROJECT_COUNT}" -eq 1 ]; then
            PROJECT_ENDPOINT=$(echo "${PROJECT_ENDPOINTS}" | head -1)
            PROJECT_ENDPOINT="${PROJECT_ENDPOINT%/}"
            echo -e "${GREEN}  ✓ Foundry project endpoint: ${PROJECT_ENDPOINT}${NC}"
        else
            echo -e "${YELLOW}  Multiple projects found:${NC}"
            echo "${PROJECT_ENDPOINTS}" | while read -r p; do echo "     • $p"; done
            read -rp "  Enter the full project endpoint to use: " PROJECT_ENDPOINT
            PROJECT_ENDPOINT="${PROJECT_ENDPOINT%/}"
        fi
        set_env_if_empty "AZURE_AI_PROJECT_ENDPOINT" "${PROJECT_ENDPOINT}" || true
    else
        echo -e "${YELLOW}  ⚠ No Foundry project found. Set AZURE_AI_PROJECT_ENDPOINT manually.${NC}"
    fi

    # ── Find model deployment name (first GlobalStandard chat model) ──
    MODEL_DEPLOYMENT=$(az cognitiveservices account deployment list \
        --name "${ACCOUNT_AI}" \
        --resource-group "${SELECTED_RG}" \
        --query "[?sku.name=='GlobalStandard'] | [0].name" \
        -o tsv 2>/dev/null || echo "")
    if [ -z "${MODEL_DEPLOYMENT}" ]; then
        # Fall back to any deployment
        MODEL_DEPLOYMENT=$(az cognitiveservices account deployment list \
            --name "${ACCOUNT_AI}" \
            --resource-group "${SELECTED_RG}" \
            --query "[0].name" \
            -o tsv 2>/dev/null || echo "")
    fi
    if [ -n "${MODEL_DEPLOYMENT}" ]; then
        echo -e "${GREEN}  ✓ Model deployment: ${MODEL_DEPLOYMENT}${NC}"
        set_env_if_empty "AZURE_AI_MODEL_DEPLOYMENT_NAME" "${MODEL_DEPLOYMENT}" || true
    else
        echo -e "${YELLOW}  ⚠ No model deployment found. Set AZURE_AI_MODEL_DEPLOYMENT_NAME manually.${NC}"
    fi
fi

# ── Find Azure Container Registry ──
ACR_NAME=$(az acr list \
    --resource-group "${SELECTED_RG}" \
    --query "[0].name" \
    -o tsv 2>/dev/null || echo "")

if [ -n "${ACR_NAME}" ]; then
    echo -e "${GREEN}  ✓ Container Registry: ${ACR_NAME}${NC}"
    set_env_if_empty "AZURE_CONTAINER_REGISTRY_NAME" "${ACR_NAME}" || true
    # Also write the login server (FQDN) — needed for docker tag/push.
    ACR_LOGIN_SERVER=$(az acr show \
        --name "${ACR_NAME}" \
        --resource-group "${SELECTED_RG}" \
        --query "loginServer" \
        -o tsv 2>/dev/null || echo "")
    if [ -n "${ACR_LOGIN_SERVER}" ]; then
        set_env_if_empty "AZURE_CONTAINER_REGISTRY_LOGIN_SERVER" "${ACR_LOGIN_SERVER}" || true
    fi
else
    echo -e "${YELLOW}  ⚠ No ACR found in '${SELECTED_RG}'. Set AZURE_CONTAINER_REGISTRY_NAME manually.${NC}"
fi

# ── Find Application Insights ──
az extension add --name application-insights --yes 2>/dev/null || true
APPINSIGHTS_CS=$(az resource list \
    --resource-group "${SELECTED_RG}" \
    --resource-type "Microsoft.Insights/components" \
    --query "[0].name" \
    -o tsv 2>/dev/null || echo "")

if [ -n "${APPINSIGHTS_CS}" ]; then
    CS=$(az monitor app-insights component show \
        --app "${APPINSIGHTS_CS}" \
        --resource-group "${SELECTED_RG}" \
        --query "connectionString" \
        -o tsv 2>/dev/null || echo "")
    if [ -n "${CS}" ]; then
        echo -e "${GREEN}  ✓ Application Insights: ${APPINSIGHTS_CS}${NC}"
        set_env_if_empty "APPLICATIONINSIGHTS_CONNECTION_STRING" "${CS}" || true
    fi
else
    echo -e "${YELLOW}  ⚠ No Application Insights found. Trace analysis will be unavailable.${NC}"
fi

# ── Derive convenience URLs (Foundry portal, Azure portal RG) ──
# These are computed from the values discovered above so users don't
# have to assemble URLs by hand or paste multi-line shell snippets.
PROJECT_HOST=$(grep "^AZURE_AI_PROJECT_ENDPOINT=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"' | sed -E 's#^https?://##' | cut -d'/' -f1 || echo "")
PROJECT_ACCT="${PROJECT_HOST%%.*}"
SUB_ID_VAL=$(grep "^AZURE_SUBSCRIPTION_ID=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"' || echo "")
RG_VAL=$(grep "^AZURE_RESOURCE_GROUP=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"' || echo "")

if [ -n "${PROJECT_ACCT}" ] && [ -n "${SUB_ID_VAL}" ] && [ -n "${RG_VAL}" ]; then
    FOUNDRY_URL="https://ai.azure.com/build/overview?wsid=/subscriptions/${SUB_ID_VAL}/resourceGroups/${RG_VAL}/providers/Microsoft.CognitiveServices/accounts/${PROJECT_ACCT}"
    set_env_if_empty "FOUNDRY_PORTAL_URL" "${FOUNDRY_URL}" || true
fi

if [ -n "${SUB_ID_VAL}" ] && [ -n "${RG_VAL}" ]; then
    AZ_PORTAL_URL="https://portal.azure.com/#@/resource/subscriptions/${SUB_ID_VAL}/resourceGroups/${RG_VAL}/overview"
    set_env_if_empty "AZURE_PORTAL_RG_URL" "${AZ_PORTAL_URL}" || true
fi

# ────────────────────────────────────────────────────────────
#  Step 6: Summary
# ─────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[6/6]${NC} Checking .env completeness..."
echo ""

MISSING=0
while IFS='=' read -r key _; do
    [[ "${key}" =~ ^#.*$ ]] && continue
    [[ -z "${key}" ]] && continue
    current=$(grep "^${key}=" "${ENV_FILE}" | cut -d'=' -f2- | tr -d '"' || echo "")
    if [ -z "${current}" ]; then
        echo -e "${YELLOW}  ○ ${key} — still needs a value${NC}"
        MISSING=$((MISSING + 1))
    fi
done < <(grep "^[A-Z]" "${SAMPLE_FILE}")

echo ""
if [ "${MISSING}" -eq 0 ]; then
    echo -e "${GREEN}  ✅ All environment variables are set!${NC}"
else
    echo -e "${YELLOW}  ⚠ ${MISSING} variable(s) still need manual entry.${NC}"
    echo -e "${YELLOW}    Edit .env and fill in the missing values.${NC}"
fi

echo ""
echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
echo -e "${CYAN}  Your .env file is at: ${ENV_FILE}${NC}"
echo -e "${CYAN}  Next: open docs/README.md and start Module 1${NC}"
echo -e "${CYAN}──────────────────────────────────────────────────────────${NC}"
echo ""