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

