# Self-Guided Path (At-Home)

You're working through this workshop on your own — you'll **provision
everything from scratch** using `azd up`.

## What You'll Do

| Step | Action |
|------|--------|
| [1](./1-prereqs.md) | Install local tools (or open a Codespace) and clone the repo |
| [2](./2-azure-login.md) | Sign in to Azure CLI + Azure Developer CLI |
| [3](./3-azd-up.md) | Run `azd up` inside `zava/` to provision the Foundry project and deploy the agent |

Then continue with the [shared](../shared/README.md) convergence flow:

| Step | Action |
|------|--------|
| [shared/1](../shared/1-discover-env.md) | Run `discover-env.sh` to populate `.env` |
| [shared/2](../shared/2-three-tabs.md) | Open the three browser tabs and confirm readiness |

## What This Costs

`azd up` will create the following in your subscription:

- Microsoft Foundry project (free)
- `gpt-4.1-mini` GlobalStandard model deployment (pay-per-token)
- Azure Container Registry (Basic SKU — ~$0.17/day)
- Application Insights + Log Analytics (pay-per-GB ingested)
- Bing Grounding + AI Search connections (free tier where available)

Plan to spend a few US dollars while running the labs and **run `azd down`
when you finish** to avoid ongoing charges.

---

**Next**: [Step 1 — Install prerequisites →](./1-prereqs.md)
