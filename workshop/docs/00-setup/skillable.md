# Skillable Setup (In-Venue)

You're attending the lab at Microsoft Build — your environment is pre-configured.

## What's Already Done For You

- ✅ Azure subscription provisioned
- ✅ Zava Travel agent **pre-deployed** to Microsoft Foundry
- ✅ Azure Container Registry created with agent image pushed

## Get Started

### Step 1: Open Your Codespace

1. Navigate to the repository URL provided by your instructor
2. Click **Code** → **Codespaces** → **Open in Codespace**
3. Wait for the environment to fully load (VS Code in browser)

### Step 2: Verify Your Environment

Open the terminal (`Ctrl+`` `) and run:

```bash
# Check Azure login
az account show --query name -o tsv

# Check environment variables
cat .env | head -5
```

You should see your assigned subscription name and resource details.

### Step 3: Validate the Pre-deployed Agent

Your Zava Travel agent is already running. Let's confirm:

```bash
# Source environment variables
source .env

# Quick test — invoke the agent
python scripts/load-test.py --quick
```

You should see a successful response from the Zava Travel Concierge.

## ✅ Checkpoint

Before moving to Lab 2, confirm:
- [ ] Codespace is running
- [ ] `az account show` returns your subscription
- [ ] Agent responds to a test query

**Next**: [Lab 2 — Observe & Evaluate](../core/lab-2.md)

> **Note**: Since your agent is pre-deployed, you skip Lab 1's deployment steps and go directly to evaluation. If you want to understand the deployment process, revisit [Lab 1](../core/lab-1.md) during the MORE section or at home.
