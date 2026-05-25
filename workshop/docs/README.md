# Workshop: Observe, Optimize and Protect Your Hosted Agents

Welcome to **LAB540** — a hands-on workshop on Microsoft Foundry Observability.

## What You'll Build

You'll take the **Zava Travel Concierge** (a multi-agent travel planning system) from deployed prototype to production-quality agent — using Foundry Skills and GitHub Copilot to evaluate, fix, and optimize it.

## Choose Your Path

| Path | For | Start Here |
|------|-----|------------|
| 🏫 **Skillable** (in-venue) | Build attendees with a provided Azure subscription | [Skillable Setup](./00-setup/skillable.md) |
| 🏠 **Self-paced** (at-home) | Learners with their own Azure + GitHub Copilot subscription | [Self-paced Setup](./00-setup/self-paced.md) |

## Workshop Structure

### CORE (60 minutes)

| # | Lab | Description |
|---|-----|-------------|
| 1 | [Deploy & Validate](./core/lab-1.md) | Get the hosted agent running and confirm it works |
| 2 | [Observe & Evaluate](./core/lab-2.md) | Auto-generate test data, evaluate, get recommendations |
| 3 | [Optimize & Verify](./core/lab-3.md) | Fix the agent, redeploy, prove improvement |
| 4 | [Explore MORE](./core/lab-4.md) | Pick a deeper-dive topic |

### MORE (self-paced)

| Lab | Topic |
|-----|-------|
| [Datasets](./more/lab-datasets.md) | Curate & version test datasets from traces |
| [Evaluators](./more/lab-evaluators.md) | Build custom evaluators & metrics |
| [Continuous Eval](./more/lab-continuous-eval.md) | Set up ongoing monitoring with eval trending |
| [Red-Teaming](./more/lab-red-teaming.md) | Adaptive adversarial testing for safety |
| [Tracing](./more/lab-tracing.md) | Trace-linked failure analysis & debugging |
| [Prompt Optimizer](./more/lab-prompt-optimizer.md) | Systematic instruction optimization |

## Using Copilot as Your Guide

This workshop is designed to be completed with a coding agent (like GitHub Copilot) as your interactive guide. Open Copilot Chat in one panel and your terminal in another, then try:

- **"Run the workshop"** — Copilot walks you through everything, one step at a time
- **"Complete lab 2"** — Jump to a specific lab
- **"Help me debug"** — Get troubleshooting help when something goes wrong
- **"Explain this"** — Understand what just happened
- **"What next?"** — Find out your next step

See [Skills](../../.agents/skills/) for details on the available Copilot skills.

## Scoreboard

Track your agent's quality improvement across labs:

| Metric | Baseline | After Lab 2 | After Lab 3 | After MORE |
|--------|----------|-------------|-------------|------------|
| Relevance | — | — | — | — |
| Groundedness | — | — | — | — |
| Safety | — | — | — | — |
| Overall | — | — | — | — |

Fill in your scores as you complete each lab. See [Scoreboard](../scoreboard/README.md) for details.

## Prerequisites

See [Setup](./00-setup/README.md) for full prerequisites and environment configuration.
