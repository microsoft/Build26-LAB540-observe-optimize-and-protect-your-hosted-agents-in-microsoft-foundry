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

> **⚠️ Unicode gotcha.** If your current instructions contain em-dashes (`—`),
> smart quotes, bullet characters, or emoji, the optimizer's JSON round-trip
> can return mojibake (e.g. `—` → `â€”`). Before pasting the optimized text
> into `main.py`, scan for garbled characters and fix them. To avoid this
> entirely, keep `CONCIERGE_INSTRUCTIONS` ASCII-only as your seed. See
> [TROUBLESHOOTING.md](../TROUBLESHOOTING.md#prompt_optimize-returns-instructions-with-garbled--mojibake-characters).

## Step 3.3: Redeploy the Agent

After editing `CONCIERGE_INSTRUCTIONS` in
`zava/src/zava-travel-concierge/main.py`, redeploy with the bare
`azd deploy` command — it skips infra provisioning and just rebuilds +
pushes the container, then publishes a new hosted-agent revision:

```bash
cd zava
azd deploy
```

> **⚠️ Skillable / pre-provisioned environments only.**
> If you are on the Skillable path, `azd deploy` will fail with
> `AZURE_AI_PROJECT_ID is not set` because the `.azure/` state directory
> doesn't exist in your Codespace — it lives only in the environment that
> ran `azd up` during pre-provisioning. Restore it with two commands:
>
> ```bash
> # Step 1 — get the Foundry project ARM resource ID
> PROJECT_ID=$(az resource list \
>   --resource-group "$AZURE_RESOURCE_GROUP" \
>   --query "[?type=='Microsoft.CognitiveServices/accounts/projects'].id" \
>   -o tsv)
>
> # Step 2 — link azd to the existing project (interactive wizard)
> cd zava
> azd ai agent init --project-id "$PROJECT_ID"
> ```
>
> In the wizard choose:
> - **Use the code in the current directory**
> - Agent name: `zava-concierge` → confirm "Yes" to reuse existing
> - Model: **Use an existing model deployment** → `gpt-4.1-mini`
> - Startup command: `python main.py`
>
> This writes `.azure/` and `agent.yaml` locally. Then run `azd deploy`
> again — it will build and push normally.
>
> **Self-guided learners** who ran `azd up` themselves: skip this — your
> `.azure/` directory already exists.

When it finishes, ask Copilot or check the Foundry portal to confirm the
new version is **Active**:

> "What's the current version of my hosted agent?"

## Step 3.4: Re-Run Evaluation

Run the observe skill again to evaluate the improved agent:

> "Use the observe skill to re-evaluate my agent with the same dataset"

This uses the same test dataset from Lab 2, allowing a direct comparison.

## Step 3.5: Compare Results

Ask Copilot to compare the before and after:

> "Compare my evaluation results — show me what improved"

The comparison produces an **EvaluationComparison insight** in Foundry
with per-metric deltas and p-values. Likely shapes you'll see:

- A metric the optimizer targeted moves up
- A *different* metric moves down (the tradeoff)
- Most p-values come back as `TooFewSamples` or `Inconclusive` — that's
  the n≈10 sample-size reality, not a bug

> **The optimizer is a hypothesis generator, not an oracle.** A regression
> after optimization is **data**, not failure — it tells you which axis you
> traded off. Decide whether the tradeoff is acceptable, then iterate.

## Step 3.6: Update Your Scoreboard

Record your improved metrics in `workshop/scoreboard/<your-name>.md`
(see [template](../../scoreboard/template.md)). Rows match the Phase 1
evaluators:

| Metric | Baseline (Lab 2) | After Optimization (Lab 3) | Change |
|--------|-----------------|---------------------------|--------|
| task_completion | _your score_ | _your score_ | ↑ / ↓ / = |
| coherence | _your score_ | _your score_ | ↑ / ↓ / = |
| indirect_attack | _your score_ | _your score_ | ↑ / ↓ / = |
| Overall pass rate | _your score_ | _your score_ | ↑ / ↓ / = |

## Step 3.7: Reflect

You've completed one full iteration of the **observe → evaluate → optimize → verify** loop. This is the core workflow for improving hosted agents with Foundry Observability:

1. **Observe** — Auto-generate tests from agent capabilities
2. **Evaluate** — Run tests and score responses
3. **Optimize** — Apply data-driven recommendations
4. **Verify** — Prove improvement with the same tests

Each pass through this loop teaches you something about your agent.
Improvement is **not** guaranteed on every pass — the value is in the
feedback signal, which lets you make the next change more informed.

## Step 3.8: (Optional) Cleanup

If you're done experimenting and want to free up Azure cost:

```bash
cd zava
azd down --purge
```

The `--purge` flag also removes soft-deleted Foundry resources so the
name is immediately reusable. Skip this if you plan to continue with
the MORE labs — you'll want the agent still deployed.

---

## ✅ Checkpoint

Before moving to Lab 4, confirm:
- [ ] Agent instructions were updated based on recommendations
- [ ] New version deployed successfully
- [ ] Re-evaluation comparison ran (improvement is **not** required — a measurable, explainable result is)
- [ ] Updated scores recorded in your scoreboard

**Next**: [Lab 4 — Explore MORE](./lab-4.md)
