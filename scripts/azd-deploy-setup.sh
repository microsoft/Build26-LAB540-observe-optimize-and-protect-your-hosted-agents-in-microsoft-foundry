#!/usr/bin/env bash
 
# =============================================================================
# azd-deploy-setup.sh — Bootstrap azd environment for re-deployment
#
# When a Foundry project is provisioned outside of the dev-container's azd
# context (e.g. via the Skillable lab lifecycle scripts), the local azd
# environment is empty except for AZURE_ENV_NAME. This leaves `azd deploy`
# unable to find the registry, project, or endpoint it needs.
#
# This script reads the repo's .env file (auto-populated by
# scripts/discover-env.sh) and seeds all missing values into the azd
# environment so that `azd deploy` works without a full `azd provision`.
#
# Usage (from repo root or zava/):
#   bash zava/scripts/azd-deploy-setup.sh
#   # then:
#   cd zava && AZD_SKIP_FIRST_RUN=true azd deploy
#
# Requirements:
#   - .env exists at the repo root (run scripts/discover-env.sh first)
#   - You are logged in with `az login` / DefaultAzureCredential
#   - The Foundry project is already provisioned in Azure
# =============================================================================
 
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZAVA_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_ROOT="$(cd "${ZAVA_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"
 
 
# ---------------------------------------------------------------------------
# 1. Source .env
# ---------------------------------------------------------------------------
if [[ ! -f "${ENV_FILE}" ]]; then
  echo "ERROR: ${ENV_FILE} not found."
  echo "Run scripts/discover-env.sh from the repo root first."
  exit 1
fi
# shellcheck disable=SC1090
source "${ENV_FILE}"
 
# Validate required values are present
required_vars=(  AZURE_ENV_NAME  AZURE_SUBSCRIPTION_ID  AZURE_RESOURCE_GROUP  AZURE_AI_PROJECT_ENDPOINT  AZURE_CONTAINER_REGISTRY_NAME)
for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: ${var} is not set in ${ENV_FILE}."
    echo "Run scripts/discover-env.sh to populate it."
    exit 1
  fi
done
 
 
# ---------------------------------------------------------------------------
# 2. Ensure the azd environment exists (create it if .azure is missing)
# ---------------------------------------------------------------------------
cd "${ZAVA_DIR}"
AZD_ENV_DIR="${ZAVA_DIR}/.azure/${AZURE_ENV_NAME}"
if [[ ! -d "${AZD_ENV_DIR}" ]]; then
  echo "  azd environment '${AZURE_ENV_NAME}' not found — creating it..."
  azd env new "${AZURE_ENV_NAME}" --no-prompt
  echo "  ✓ azd environment created."
else
  echo "  ✓ azd environment '${AZURE_ENV_NAME}' already exists."
fi
echo ""
 
# ---------------------------------------------------------------------------
# 3. Derive values that azd deploy needs but .env doesn't capture directly  
# ---------------------------------------------------------------------------
# Registry login server (azd uses AZURE_CONTAINER_REGISTRY_ENDPOINT)
AZURE_CONTAINER_REGISTRY_ENDPOINT="${AZURE_CONTAINER_REGISTRY_LOGIN_SERVER:-${AZURE_CONTAINER_REGISTRY_NAME}.azurecr.io}"
# FOUNDRY_PROJECT_ENDPOINT — same as AZURE_AI_PROJECT_ENDPOINT in this setup
FOUNDRY_PROJECT_ENDPOINT="${AZURE_AI_PROJECT_ENDPOINT}"
# Derive the ARM resource ID for the Foundry project from the endpoint URL.
# Endpoint format: https://<account>.services.ai.azure.com/api/projects/<project>
ACCOUNT_NAME="$(echo "${AZURE_AI_PROJECT_ENDPOINT}" | sed -E 's|https://([^.]+)\..*|\1|')"
PROJECT_NAME="$(echo "${AZURE_AI_PROJECT_ENDPOINT}" | sed -E 's|.*/projects/([^/]+).*|\1|')"
AZURE_AI_PROJECT_ID="/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_RESOURCE_GROUP}/providers/Microsoft.CognitiveServices/accounts/${ACCOUNT_NAME}/projects/${PROJECT_NAME}"
echo "=== azd-deploy-setup: seeding environment '${AZURE_ENV_NAME}' ==="
echo "  Subscription : ${AZURE_SUBSCRIPTION_ID}"
echo "  Resource group: ${AZURE_RESOURCE_GROUP}"
echo "  Foundry project: ${AZURE_AI_PROJECT_ID}"
echo "  ACR endpoint : ${AZURE_CONTAINER_REGISTRY_ENDPOINT}"
echo ""
 
# ---------------------------------------------------------------------------
# 4. Set all required values in the azd environment
# ---------------------------------------------------------------------------
cd "${ZAVA_DIR}"
azd env set AZURE_SUBSCRIPTION_ID        "${AZURE_SUBSCRIPTION_ID}"         --environment "${AZURE_ENV_NAME}"
azd env set AZURE_RESOURCE_GROUP         "${AZURE_RESOURCE_GROUP}"           --environment "${AZURE_ENV_NAME}"
azd env set AZURE_LOCATION               "${AZURE_LOCATION:-eastus2}"        --environment "${AZURE_ENV_NAME}"
azd env set AZURE_AI_PROJECT_ENDPOINT    "${AZURE_AI_PROJECT_ENDPOINT}"      --environment "${AZURE_ENV_NAME}"
azd env set AZURE_AI_MODEL_DEPLOYMENT_NAME "${AZURE_AI_MODEL_DEPLOYMENT_NAME:-gpt-5.4-mini}" --environment "${AZURE_ENV_NAME}"
azd env set AZURE_CONTAINER_REGISTRY_NAME     "${AZURE_CONTAINER_REGISTRY_NAME}"     --environment "${AZURE_ENV_NAME}"
azd env set AZURE_CONTAINER_REGISTRY_ENDPOINT "${AZURE_CONTAINER_REGISTRY_ENDPOINT}" --environment "${AZURE_ENV_NAME}"
azd env set AZURE_AI_PROJECT_ID          "${AZURE_AI_PROJECT_ID}"            --environment "${AZURE_ENV_NAME}"
azd env set FOUNDRY_PROJECT_ENDPOINT     "${FOUNDRY_PROJECT_ENDPOINT}"       --environment "${AZURE_ENV_NAME}"
azd env set ENABLE_HOSTED_AGENTS         "true"                              --environment "${AZURE_ENV_NAME}"
azd env set ENABLE_CAPABILITY_HOST       "false"                             --environment "${AZURE_ENV_NAME}"
echo "=== Done. You can now run: ==="
echo "  cd ${ZAVA_DIR} && AZD_SKIP_FIRST_RUN=true azd deploy"