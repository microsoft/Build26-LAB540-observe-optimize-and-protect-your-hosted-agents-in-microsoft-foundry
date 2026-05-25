# Self-Paced Setup (At-Home)

You're working through this workshop on your own — you'll deploy everything from scratch.

## What You Need

- **Azure subscription** with permissions to create resources (Contributor role)
- **GitHub account** with GitHub Copilot enabled
- **VS Code** with the GitHub Copilot extension installed
- **Azure CLI** (`az`) — [Install guide](https://learn.microsoft.com/cli/azure/install-azure-cli)
- **Azure Developer CLI** (`azd`) — [Install guide](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
- **Docker** — [Install guide](https://docs.docker.com/get-docker/)
- **Python 3.10+** — [Install guide](https://python.org)

## Get Started

### Step 1: Clone the Repository

```bash
git clone https://github.com/microsoft/Build26-LAB540.git
cd Build26-LAB540
```

Or open in a **GitHub Codespace** (recommended — all tools pre-installed):
- Click **Code** → **Codespaces** → **Create codespace on main**

### Step 2: Log in to Azure

```bash
# Log in to Azure CLI
az login

# Confirm your subscription
az account show --query '{name:name, id:id}' -o table

# If you need to switch subscriptions:
# az account set --subscription "YOUR_SUBSCRIPTION_NAME"
```

### Step 3: Log in to Azure Developer CLI

```bash
azd auth login
```

### Step 4: Set Up Environment Variables

```bash
# Run the discovery script — this creates your .env file
chmod +x scripts/discover-env.sh
./scripts/discover-env.sh
```

This will prompt you for:
- Resource group name
- Foundry project name
- Region

### Step 5: Verify Your Setup

```bash
# Source the environment
source .env

# Verify all required variables are set
echo "Resource Group: $RESOURCE_GROUP"
echo "Foundry Project: $FOUNDRY_PROJECT_NAME"
echo "Region: $AZURE_LOCATION"
```

## ✅ Checkpoint

Before moving to Lab 1, confirm:
- [ ] `az account show` returns your subscription
- [ ] `azd auth login` succeeded
- [ ] `.env` file exists with your resource details
- [ ] Docker is running (`docker info`)

**Next**: [Lab 1 — Deploy & Validate](../core/lab-1.md)
