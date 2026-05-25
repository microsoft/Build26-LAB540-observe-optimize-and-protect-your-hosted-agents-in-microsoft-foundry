# Workshop Plan — LAB540: Observe, Optimize and Protect Your Hosted Agents

## Overview

This workshop provides a hands-on introduction to using Microsoft Foundry Skills and GitHub Copilot to evaluate, fix, and optimize a hosted agent solution on Microsoft Foundry. Learners work with the **Zava Travel Concierge** — a multi-agent travel planning system — as their target application.

## Structure

The workshop has two sections:

### CORE (60 minutes, in-venue)

Four labs that take learners from a deployed agent to a measurably improved one:

| Lab | Title | Time | What You'll Do |
|-----|-------|------|----------------|
| 1 | Deploy & Validate | ~15 min | Get a hosted agent running on Foundry and confirm it works |
| 2 | Observe & Evaluate | ~15 min | Activate the observe skill to auto-generate a test dataset, evaluate the agent, and get optimization recommendations |
| 3 | Optimize & Verify | ~15 min | Apply recommendations, redeploy, re-evaluate — see measurable improvement |
| 4 | Explore MORE | ~15 min | Pick one deeper-dive lab from the MORE section |

### MORE (self-paced, no time limit)

Deeper explorations of individual Foundry Observability capabilities:

| Lab | Topic | What You'll Learn |
|-----|-------|-------------------|
| Datasets | Test dataset curation & versioning | Create datasets from traces, version them, use them across evaluations |
| Evaluators | Custom evaluators & metrics | Build custom evaluators beyond built-ins, understand scoring |
| Continuous Eval | Continuous evaluation & monitoring | Set up ongoing eval with trending and alerts |
| Red-Teaming | Adaptive adversarial testing | Probe agent safety and security with adaptive attacks |
| Tracing | Trace-linked analysis | Deep-dive into traces to debug failures and understand agent behavior |
| Prompt Optimizer | Instruction optimization | Systematically improve agent prompts using the optimization service |

## Two Starting Points

| Path | Audience | Lab 1 Experience |
|------|----------|------------------|
| **Skillable** | In-venue attendees | Agent is pre-deployed; skip to validation exercises |
| **Self-Guided** | At-home learners | Deploy the agent yourself with `azd up`, then validate |

Both paths converge at the same checkpoint before Lab 2.

## Scoreboard

A running scorecard tracks the agent's quality metrics (relevance, groundedness, safety, etc.) across labs. Each optimization step shows measurable improvement — giving learners a tangible sense of progress.

## Copilot Skills

The workshop includes coding-agent skills that guide learners interactively:

| Skill | Purpose |
|-------|---------|
| `run-workshop` | Walk through the entire workshop end-to-end, one step at a time |
| `complete-lab` | Complete a specific lab (takes lab ID as input) |
| `setup-env` | Automate Azure login, .env creation, and connectivity checks |
| `help-me-debug` | Context-aware troubleshooting when something goes wrong |
| `explain-this` | Educational explanation of outputs, concepts, or results |
| `what-next` | Tell the learner what their next step is |

## Business Scenario

**Zava Travel** is a premium travel agency with an AI-powered concierge that orchestrates specialist agents (flights, hotels, car rentals). The team needs to ensure agent responses are reliable, safe, and high-quality as they scale — but they have no pre-existing test datasets. This workshop shows how Foundry Observability solves that problem.

## Optimization Story (Specifics)

The Zava Travel Concierge is deployed with **intentionally minimal instructions** (~12 lines in `main.py` `CONCIERGE_INSTRUCTIONS`). A much richer instruction set exists in `data/zava-travel-instructions.md` (84 lines with full behavioral rules). This gap creates real, observable failures that the Foundry observe skill detects and clusters:

### Failure Clusters the Observe Skill Will Find

| Priority | Cluster | Root Cause in Minimal Instructions | Fix (from Rich Instructions) |
|----------|---------|-----------------------------------|------------------------------|
| P1 | Hallucinated details | No explicit grounding requirement | Add: "Always cite Zava ID, price, dates; never fabricate" |
| P1 | Incomplete multi-component responses | No parallel-call instruction | Add: "Call each specialist independently in parallel, merge results" |
| P2 | Wrong specialist called | No routing table | Add specialist routing table with clear boundaries |
| P2 | Missing availability filtering | No mention of availability | Add: "Only return available options (check `available` field)" |
| P3 | Scope creep on non-travel topics | Only "decline non-travel" | Add explicit out-of-scope categories + firm refusal pattern |

### Expected Scoreboard Arc

| Metric | After Lab 2 (Baseline) | After Lab 3 (Optimized) | Typical Δ |
|--------|------------------------|------------------------|-----------|
| Task Completion | ~3.0-3.5 | ~4.0-4.5 | +1.0 |
| Tool Call Accuracy | ~3.5 | ~4.5 | +1.0 |
| Tool Selection | ~3.5-4.0 | ~4.5 | +0.5 |
| Coherence | ~3.5 | ~4.0 | +0.5 |
| Indirect Attack | Pass | Pass | — |

### How It Maps to the Foundry Observe Skill (10-Step Loop)

1. Auto-setup evaluators → `.foundry/evaluators/phase1-builtin.yaml` (already seeded)
2. Batch eval → Run against `.foundry/datasets/zava-concierge-eval-seed-v1.jsonl`
3. Cluster failures → P1: hallucination + incomplete; P2: routing + availability
4. Pick category → Start with P1 (highest impact)
5. Optimize prompt → `prompt_optimize` MCP tool suggests instruction improvements
6. Deploy v2 → Rebuild with improved instructions, push, `azd up`
7. Re-evaluate → Same dataset, same evaluators
8. Compare versions → `evaluation_comparison_create` shows improvement
9. Loop → Address P2 clusters or move to MORE labs
10. CI/CD + Continuous monitoring → MORE: Continuous Eval lab

### Existing `.foundry/` Workspace

The agent root (`zava/src/zava-travel-concierge/.foundry/`) is pre-configured with:
- `agent-metadata.yaml` — Dev environment with evaluation suites (smoke tier)
- `datasets/zava-concierge-eval-seed-v1.jsonl` — 10 seed test cases (happy path, multi-step, safety)
- `evaluators/phase1-builtin.yaml` — Phase 1 built-in evaluator definitions
- `datasets/manifest.json` — Dataset tracking metadata

## Technologies

- Microsoft Foundry (hosted agents, observability, skills)
- Azure Developer CLI (`azd`) with Foundry extension
- GitHub Copilot (coding agent with microsoft-foundry skill)
- Microsoft Agent Framework (Python)
- Docker / Azure Container Registry
- Application Insights (tracing)

## Microsoft Foundry Skill Sub-Skills (Workshop Mapping)

| Foundry Sub-Skill | Workshop Lab |
|-------------------|-------------|
| `deploy` | Lab 1 — Deploy hosted agent |
| `invoke` | Lab 1 — Validate agent |
| `observe` | Labs 2 & 3 — Full eval-optimize loop |
| `trace` | MORE: Tracing lab |
| `troubleshoot` | Workshop skill: help-me-debug |
| `faos-optimize` | MORE: Prompt Optimizer lab |
| `eval-datasets` | MORE: Datasets lab |
| `continuous_eval` (within observe) | MORE: Continuous Eval lab |

## Prerequisites

- Azure subscription (provided in-venue via Skillable, bring-your-own for self-guided)
- GitHub account with Copilot subscription
- Familiarity with Python, VS Code, and agentic AI concepts
