# Lab 3: Optimize & Verify

## Objective

Apply the optimization recommendations from Lab 2, deploy an improved version of the agent, and re-run evaluation to demonstrate measurable improvement.

## Time Estimate

~15 minutes

## Prerequisites

- Lab 2 checkpoint complete (evaluation results + recommendations available)

---

## Step 3.1: Review the Recommendation

Recall the optimization recommendations from Lab 2. In Copilot Chat:

> "What was the top recommendation from the evaluation?"

The recommendation will typically point to a specific improvement in:
- Agent instructions (system prompt)
- Specialist agent prompts
- Response formatting or grounding rules
- Edge case handling

## Step 3.2: Apply the Optimization

Based on the recommendation, modify the agent. Common optimizations include:

### Option A: Update Agent Instructions

If the recommendation targets the agent's system prompt, edit the instructions:

```bash
# Open the agent instructions file
code data/zava-travel-instructions.md
```

Apply the specific change recommended by the observe skill. For example:
- Adding explicit grounding rules
- Improving delegation instructions
- Fixing response format requirements

### Option B: Use the Prompt Optimizer

For more systematic optimization, use the Foundry prompt optimizer skill:

> "Use the optimize skill to improve my agent's instructions based on the evaluation results"

The optimizer will:
1. Analyze the failure patterns
2. Generate an improved version of the instructions
3. Show you the diff for approval

## Step 3.3: Redeploy the Agent

After making changes, deploy the updated agent:

```bash
# Rebuild and push the updated image
cd zava/src/zava-travel-concierge
docker build -t zava-concierge:latest .
docker tag zava-concierge:latest $ACR_LOGIN_SERVER/zava-concierge:v2
docker push $ACR_LOGIN_SERVER/zava-concierge:v2

# Redeploy
cd /workspaces/Build26-LAB540-fork
azd up
```

Wait for the new version to be live.

## Step 3.4: Re-Run Evaluation

Run the observe skill again to evaluate the improved agent:

> "Use the observe skill to re-evaluate my agent with the same dataset"

This uses the same test dataset from Lab 2, allowing a direct comparison.

## Step 3.5: Compare Results

Ask Copilot to compare the before and after:

> "Compare my evaluation results — show me what improved"

You should see improvement in the metrics targeted by the optimization. For example:
- Groundedness scores increase if you added grounding rules
- Relevance scores increase if you improved delegation logic
- Safety scores remain stable (regression check)

## Step 3.6: Update Your Scoreboard

Record your improved metrics:

| Metric | Baseline (Lab 2) | After Optimization (Lab 3) | Change |
|--------|-----------------|---------------------------|--------|
| Relevance | _your score_ | _your score_ | ↑ |
| Groundedness | _your score_ | _your score_ | ↑ |
| Safety | _your score_ | _your score_ | — |
| Overall | _your score_ | _your score_ | ↑ |

## Step 3.7: Reflect

You've completed one full iteration of the **observe → evaluate → optimize → verify** loop. This is the core workflow for improving hosted agents with Foundry Observability:

1. **Observe** — Auto-generate tests from agent capabilities
2. **Evaluate** — Run tests and score responses
3. **Optimize** — Apply data-driven recommendations
4. **Verify** — Prove improvement with the same tests

Each pass through this loop makes your agent measurably better.

---

## ✅ Checkpoint

Before moving to Lab 4, confirm:
- [ ] Agent instructions were updated based on recommendations
- [ ] New version deployed successfully
- [ ] Re-evaluation shows improvement in targeted metrics
- [ ] Updated scores recorded in your scoreboard

**Next**: [Lab 4 — Explore MORE](./lab-4.md)
