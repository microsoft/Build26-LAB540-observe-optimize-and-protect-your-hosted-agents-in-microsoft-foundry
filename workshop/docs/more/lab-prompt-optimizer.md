# MORE: Prompt & Instruction Optimization

## Objective

Use the Foundry prompt optimization service to systematically improve your agent's instructions based on evaluation data — going beyond manual edits.

## What You'll Learn

- How the prompt optimizer works (data-driven instruction improvement)
- How to run optimization against evaluation results
- How to review and approve optimizer suggestions
- How to iterate multiple optimization passes

---

## Step 1: Manual vs. Systematic Optimization

In Lab 3, you applied a single recommendation manually. The prompt optimizer takes a more systematic approach:

| Approach | How It Works | Best For |
|----------|-------------|----------|
| Manual | Read recommendations, edit prompt yourself | Small targeted fixes |
| Prompt Optimizer | Analyzes all failures, generates improved instructions | Comprehensive improvement |

The optimizer:
1. Analyzes your full evaluation results (not just one failure)
2. Identifies patterns across multiple failures
3. Generates an improved instruction set that addresses all patterns
4. Preserves instructions that are working well
5. Shows you a diff for review

## Step 2: Run the Prompt Optimizer

> "Use the prompt optimizer to improve my Zava Travel Concierge instructions based on all evaluation results"

The optimizer will analyze:
- All test cases from your evaluation dataset
- Score patterns across metrics
- Common failure modes
- Instruction sections correlated with failures

## Step 3: Review the Proposed Changes

The optimizer presents a diff showing exactly what it wants to change:

> "Show me the proposed instruction changes and explain the reasoning"

For each change, the optimizer explains:
- Which failures it addresses
- Expected impact on scores
- Trade-offs (if any)

**Important**: Review carefully. Not all changes are improvements — the optimizer can occasionally over-optimize for one metric at the expense of another.

## Step 4: Apply and Test

If you approve the changes:

> "Apply the optimizer's suggested changes to my agent instructions"

Then redeploy and re-evaluate:

```bash
cd zava/src/zava-travel-concierge
docker build -t zava-concierge:latest .
docker tag zava-concierge:latest $AZURE_CONTAINER_REGISTRY_LOGIN_SERVER/zava-concierge:v3
docker push $AZURE_CONTAINER_REGISTRY_LOGIN_SERVER/zava-concierge:v3

cd /workspaces/Build26-LAB540-fork
azd up
```

> "Re-evaluate the agent with the full dataset"

## Step 5: Iterate

The optimizer works best when run iteratively:

1. **Pass 1**: Major structural improvements to instructions
2. **Pass 2**: Fine-tuning based on remaining failures
3. **Pass 3**: Edge case handling and polish

Each pass should show diminishing but real improvement on the scoreboard.

> "Run another optimization pass based on the latest evaluation results"

## Step 6: Compare Across Versions

Track your progress across optimization passes:

| Version | Optimization Applied | Relevance | Groundedness | Safety | Overall |
|---------|---------------------|-----------|--------------|--------|---------|
| v1 (baseline) | None | — | — | — | — |
| v2 (Lab 3) | Manual fix | — | — | — | — |
| v3 (Pass 1) | Optimizer | — | — | — | — |
| v4 (Pass 2) | Optimizer | — | — | — | — |

---

## ✅ Checkpoint

- [ ] Understand how the prompt optimizer differs from manual editing
- [ ] Ran the optimizer and reviewed proposed changes
- [ ] Applied at least one optimizer pass
- [ ] Verified improvement with re-evaluation
- [ ] Understand how to iterate for continued improvement

## Scoreboard Update

This lab should show the most dramatic improvement on your scoreboard — the optimizer addresses multiple failure modes simultaneously.

**Back to**: [MORE Labs](./README.md)
