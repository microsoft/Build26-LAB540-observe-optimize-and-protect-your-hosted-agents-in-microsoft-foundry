# Skill: setup-env

## Description

Automates environment setup for the workshop — Azure login, .env creation, connectivity validation, and prerequisite checks.

## When to Invoke

The learner says something like:
- "Set up my environment"
- "Configure my environment for the workshop"
- "Help me set up"
- "Run setup"

## Behavior

1. **Check current state**: Before making changes, check what's already configured:
   - Is Azure CLI logged in? (`az account show`)
   - Is azd authenticated? (`azd auth login --check-status`)
   - Does `.env` exist?
   - Is Docker running? (`docker info`)

2. **Fix what's missing**: For each missing piece, guide the learner:
   - Azure login: `az login`
   - azd auth: `azd auth login`
   - .env creation: Run `scripts/discover-env.sh` or create manually
   - Docker: Remind to start Docker Desktop

3. **Validate**: After setup, run validation checks:
   - Confirm Azure subscription access
   - Confirm required resource providers are registered
   - Confirm .env has all required variables
   - Confirm Docker can pull images

4. **Report**: Summarize what's ready and what (if anything) still needs attention.

## Resources

Scripts:
- `scripts/discover-env.sh` — Creates .env with required variables (path-aware: detects azd env from `zava/.azure/`, falls back to interactive)
- `scripts/sample.env` — Template showing required variables

## Required Environment Variables

The .env file should contain:
- `RESOURCE_GROUP` — Azure resource group name
- `FOUNDRY_PROJECT_NAME` — Microsoft Foundry project name
- `AZURE_LOCATION` — Azure region
- `ACR_LOGIN_SERVER` — Container registry server URL
- `AZURE_AI_MODEL_DEPLOYMENT_NAME` — Model deployment name

## Interaction Pattern

- Run checks silently first
- Report status clearly (✅ ready / ❌ needs action)
- Fix issues one at a time with clear instructions
- Validate after each fix
- End with a full readiness summary
