# @lab.Title

## Welcome to LAB540

You're about to take **Observe, Optimize and Protect Your Hosted Agents in
Microsoft Foundry** — a hands-on lab on how Microsoft Foundry Observability
helps you move agents from prototype to production.

> [!Knowledge] What's already done for you
> Your Skillable lab environment has pre-provisioned everything you need to
> start the workshop:
>
> - An Azure resource group: ++@lab.CloudResourceGroup(ResourceGroup1).Name++
> - A Microsoft Foundry project with the `gpt-4.1-mini` model deployment
> - The Zava Travel Concierge **hosted agent** running in your project
> - An Azure Container Registry with the agent image
> - Application Insights for telemetry

### How instructions work in Skillable

Throughout these instructions, you'll see two kinds of formatted text:

- Text like +++example+++ is **type text** — clicking it inserts the
  text at your cursor in the VM (no typing errors).
- Text like ++example++ is **copy text** — clicking it copies the text
  to your clipboard.

Use these on every command — it's faster and prevents typos.

### Lab structure

| Lab | What you'll do |
|-----|----------------|
| **Lab 0 — Setup (this section)** | Open your Codespace, populate `.env`, open three browser tabs |
| Lab 1 — Deploy & Validate | Validate the pre-deployed Zava Travel Concierge in the Foundry portal |
| Lab 2 — Observe & Evaluate | Auto-generate a test dataset, run evaluators, get optimization recommendations |
| Lab 3 — Optimize & Verify | Apply the top recommendation, redeploy, prove the agent improved |
| Lab 4 — Explore MORE | Pick one MORE topic (datasets, evaluators, continuous-eval, red-teaming, tracing, prompt optimizer) |

> [!Hint] Tip
> The full workshop content lives in the GitHub repo you'll open next —
> these Skillable pages are just the setup wrapper. Once your Codespace
> is open, all the labs are in `workshop/docs/core/`.

- [] I've read the welcome and understand the lab structure.

===

## Open your Codespace

In this step you'll open the GitHub Codespace where you'll do the rest of
the workshop.

### 1. Sign in to GitHub from the VM

Open a browser inside the lab VM and go to:

<[GitHub SSO sign-in](https://github.com/enterprises/skillable-events/sso)

Sign in using the GitHub credentials shown in the **Resources** tab of
this lab. Keep this tab open — VS Code will use this session to
authenticate you in the Codespace.

- [] I'm signed in to GitHub on the SSO page.

### 2. Open the Codespace

Open the workshop repo and create / resume a Codespace:

<[Open the LAB540 repo](https://github.com/microsoft/Build26-LAB540)

Click the green **Code** button → **Codespaces** tab → **Create
codespace on `main`** (or **Open** an existing one if you see one
listed).

> [!Knowledge] First-load timing
> The first time a Codespace launches it can take 60–90 seconds to
> build the dev container. The container pre-installs `az`, `azd`,
> Docker, Python, and the Foundry tooling so you don't have to.

- [] My Codespace is open and the VS Code UI has loaded in the browser.

### 3. Open the integrated terminal

Inside the Codespace, open a terminal:

> [!Hint] Keyboard shortcut
> Press **Ctrl+`** (backtick) — or use the menu: **Terminal → New
> Terminal**.

### 4. Confirm Azure login

Skillable pre-configures Azure CLI with your lab subscription. Run:

++az account show --query '{name:name, id:id}' -o table++

You should see the lab subscription printed in a table. If not, run:

++az login --use-device-code++

…and use the device-code flow with the credentials in the **Resources**
tab.

- [] `az account show` returns the Skillable subscription.

> [!Alert] Stop here if Azure login isn't working
> The rest of the workshop assumes you're authenticated. If `az login`
> failed, ping the proctor before continuing.

===

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

## Open the three browser tabs

You'll move between three places throughout the workshop. Open all three
now so you can switch quickly.

### Tab 1 — Codespace (already open)

You should already have your Codespace open in a browser tab. Keep the
integrated terminal visible — most lab steps run there.

- [] Codespace tab is open with a terminal visible.

### Tab 2 — Microsoft Foundry portal

In your Codespace terminal, print your Foundry portal link:

++echo "$FOUNDRY_PORTAL_URL"++

Copy the URL it prints and open it in a new browser tab. Sign in with
the same account you're using for Azure CLI.

You should see:

- Your Foundry project
- The `gpt-4.1-mini` model deployment under **Models + endpoints**
- The **Zava Travel Concierge** under **Agents**

- [] Foundry portal is open and shows my project, model, and agent.

### Tab 3 — Azure Portal

Print the direct link to your resource group:

++echo "$AZURE_PORTAL_RG_URL"++

Open the URL in another new tab. Sign in with the Azure portal
credentials from the **Resources** tab:

- Username: ++@lab.CloudPortalCredential(User1).Username++
- Password: ++@lab.CloudPortalCredential(User1).Password++

You'll use this tab during the labs to inspect **Application Insights**
traces and the **Azure Container Registry**.

- [] Azure portal is open on my resource group.

> [!Knowledge] Why three tabs?
> Foundry runs your agent and shows eval results. Codespace runs your
> code and scripts. Azure portal shows raw telemetry. You'll bounce
> between all three during evaluation and optimization.

### ✅ Final setup checkpoint

Before moving to Lab 1, confirm:

- [] Codespace + terminal open
- [] `.env` populated and sourced
- [] Foundry portal shows my project + agent
- [] Azure portal shows my resource group
- [] Docker is running (++docker info++ succeeds)

### Next step — start Lab 1

In your Codespace, open this file and follow it:

++workshop/docs/core/lab-1.md++

Or, in any GitHub Copilot Chat window, just say:

+++Run the workshop+++

…and the `run-workshop` skill will take it from here.
