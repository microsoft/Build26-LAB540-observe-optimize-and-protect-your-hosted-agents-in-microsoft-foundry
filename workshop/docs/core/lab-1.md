# Lab 1: Deploy & Validate

## Objective

Deploy the Zava Travel Concierge as a hosted agent on Microsoft Foundry and validate it responds correctly.

## Time Estimate

~15 minutes (self-guided path includes deployment; Skillable path skips to validation)

---

## Agent at a Glance

Before you deploy, here's what you're about to bring up:

```
             User prompt
                 │
                 ▼
    ┌──────────────────────────┐
    │  zava-concierge (host)   │ ← hosted agent, gpt-4.1-mini
    │  CONCIERGE_INSTRUCTIONS  │    routes + composes itinerary
    └─┬──────┬────────────┬───┘
      │      │              │
      ▼      ▼              ▼
  flight_   hotel_       car_rental_   ← specialist sub-agents
  agent     agent        agent            (each wraps a @tool fn)
      │      │              │
      ▼      ▼              ▼
  flights.csv hotels.csv car_rentals.csv   ← grounding data
```

All five pieces live in `zava/src/zava-travel-concierge/main.py`. The agent
is containerized (Dockerfile in the same folder), pushed to ACR, and run as
a Foundry hosted agent. You'll see all of this in Lab 2 when you trace a
call end-to-end.

---

## Path: Self-Guided (Deploy from Scratch)

> **Skillable attendees**: Your agent is pre-deployed. Skip to [Validate the Agent](#validate-the-agent) below.

### Step 1.1: Provision + Deploy with `azd up`

From the repo root:

```bash
cd zava
azd up
```

That single command:

- Provisions the Foundry account, project, model deployment, ACR, and
  Log Analytics + Application Insights (via the Bicep in `zava/infra/`)
- Builds the agent container and pushes it to ACR
- Publishes the hosted agent to Foundry

First-time prompts: pick an environment name and a region
(`eastus2` recommended — see [zava/README.md](../../../zava/README.md#44-supported-regions)).

### Step 1.2: Populate `.env` from the new resource group

From the repo root:

```bash
chmod +x scripts/discover-env.sh
./scripts/discover-env.sh
```

The script reads the azd environment that `azd up` just created and
populates `.env` with the project endpoint, model deployment name, ACR
name, and App Insights connection string.

### Step 1.3: (Optional) Inspect the deployed image

```bash
source .env
az acr repository list --name "${AZURE_CONTAINER_REGISTRY_NAME}" -o table
```

Wait for deployment to complete (typically 3–5 minutes during `azd up`).

---

## Validate the Agent

Both paths (Skillable and Self-Guided) continue here.

### Step 1.4: Open Microsoft Foundry Portal

1. Navigate to [Microsoft Foundry](https://foundry.microsoft.com)
2. Select your project
3. Find the **Zava Travel Concierge** agent in your agent list

### Step 1.5: Test the Agent

In the Foundry playground, try these prompts:

**Test 1 — Basic routing:**
> "What flights are available from Chicago to Rome?"

Expected: The concierge delegates to the Flight Agent and returns flight options with IDs and prices.

**Test 2 — Multi-component:**
> "Plan a trip from Chicago to Rome for the first two weeks of November. I need flights, a hotel, and a car rental."

Expected: The concierge calls all three specialist agents and composes an itinerary.

**Test 3 — Out of scope:**
> "Can you help me write a Python script?"

Expected: The concierge politely declines and redirects to travel topics.

### Step 1.6: Note Baseline Behavior

Before moving to evaluation, note any issues you observe:
- Did the agent respond correctly?
- Were there any hallucinated details?
- Did it handle the out-of-scope request properly?

These observations will help you understand the evaluation results in Lab 2.

---

## ✅ Checkpoint

Before moving to Lab 2, confirm:
- [ ] Agent is deployed and accessible in Microsoft Foundry
- [ ] Agent responds to basic travel queries
- [ ] You've noted any behavioral issues

**Next**: [Lab 2 — Observe & Evaluate](./lab-2.md)
