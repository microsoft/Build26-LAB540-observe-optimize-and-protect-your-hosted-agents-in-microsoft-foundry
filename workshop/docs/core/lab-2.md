# Lab 2: Observe & Evaluate

## Objective

Activate the Foundry `observe` skill to auto-generate a test dataset, run evaluation against your deployed agent, and receive optimization recommendations based on failure analysis.

## Time Estimate

~15 minutes

## Prerequisites

- Agent deployed and validated (Lab 1 checkpoint complete)
- GitHub Copilot Chat open alongside your terminal

---

## Step 2.1: Understand the Observe Skill

The Foundry `observe` skill automates the evaluation lifecycle:
1. **Generates** a test dataset tailored to your agent's capabilities
2. **Evaluates** the deployed agent against the dataset using built-in evaluators
3. **Analyzes** failures and patterns in the results
4. **Recommends** specific optimizations to improve quality

This replaces the manual process of writing test cases, running them, and interpreting results.

## Step 2.2: Activate the Observe Skill

In GitHub Copilot Chat, invoke the observe skill:

> "Use the observe skill to evaluate my Zava Travel Concierge agent"

Copilot will:
1. Connect to your Foundry project
2. Analyze the agent's configuration and capabilities
3. Auto-generate an evaluation dataset
4. Run the evaluation

### What's Happening Behind the Scenes

The observe skill:
- Reads your agent's instructions (`agent.yaml`, system prompt)
- Generates diverse test prompts covering the agent's capabilities
- Sends each prompt to the deployed agent
- Scores responses on multiple dimensions (relevance, groundedness, safety, coherence)
- Identifies patterns in failures

## Step 2.3: Review the Generated Dataset

Once the observation pass completes, examine the generated test data:

```bash
# The observe skill creates evaluation data in your project
# Check what was generated
ls data/jsonl/
```

Review a few entries to understand the test coverage:
- Does it test all three specialist agents (flights, hotels, car rentals)?
- Does it test multi-component requests?
- Does it test edge cases and out-of-scope handling?

## Step 2.4: Review Evaluation Results

The observe skill produces evaluation results with scores across multiple dimensions:

| Metric | What It Measures |
|--------|-----------------|
| Relevance | Does the response answer the user's question? |
| Groundedness | Is the response grounded in the agent's data sources? |
| Coherence | Is the response well-structured and logical? |
| Safety | Does the response avoid harmful content? |
| Fluency | Is the response natural and well-written? |

In Copilot Chat, ask:

> "Show me the evaluation results summary"

Note your **baseline scores** — you'll compare against these after optimization.

## Step 2.5: Review Recommendations

The observe skill identifies failure patterns and provides specific recommendations:

> "What are the optimization recommendations?"

Typical findings might include:
- Agent hallucinating details not in the data source
- Incomplete responses for multi-component requests
- Inconsistent handling of edge cases
- Missing information in specialist agent delegations

## Step 2.6: Update Your Scoreboard

Record your baseline metrics in the scoreboard:

| Metric | Baseline (Lab 2) |
|--------|-----------------|
| Relevance | _your score_ |
| Groundedness | _your score_ |
| Safety | _your score_ |
| Overall | _your score_ |

---

## ✅ Checkpoint

Before moving to Lab 3, confirm:
- [ ] Observe skill completed a full pass
- [ ] You have evaluation results with scores
- [ ] You have at least one optimization recommendation
- [ ] Baseline scores recorded in your scoreboard

**Next**: [Lab 3 — Optimize & Verify](./lab-3.md)
