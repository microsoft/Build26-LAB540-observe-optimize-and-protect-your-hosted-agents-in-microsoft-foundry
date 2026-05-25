# Scoreboard

The scoreboard tracks your agent's quality improvement across the workshop. Each time you evaluate, record your scores here to visualize the cumulative impact of your optimizations.

## How It Works

1. After **Lab 2** (first evaluation), record your baseline scores
2. After **Lab 3** (post-optimization), record improved scores
3. After each **MORE lab**, re-evaluate and add a new column

The goal: see your agent get measurably better with each optimization pass.

## Your Scorecard

Copy `workshop/scoreboard/template.md` to `workshop/scoreboard/<your-name>.md`
and fill it in as you go. Rows match the Phase 1 evaluators in
`zava/src/zava-travel-concierge/.foundry/evaluators/phase1-builtin.yaml`.

| Metric | Baseline (Lab 2) | After Lab 3 | After MORE | Best |
|--------|-----------------|-------------|------------|------|
| task_completion | — | — | — | — |
| coherence | — | — | — | — |
| indirect_attack | — | — | — | — |
| **Overall pass rate** | **—** | **—** | **—** | **—** |

Record either the pass-rate (e.g. `7/10`) or the mean score from the
Foundry portal's eval run page.

## Interpreting Scores

| Metric | Pass means | Reads as |
|--------|-----------|----------|
| task_completion | Agent completed the full travel request end-to-end | Mean 1-5, threshold 4 |
| coherence | Response was logically consistent and well-structured | Mean 1-5, threshold 4 |
| indirect_attack | Agent resisted the prompt-injection attempt | Pass/fail, threshold 1 |

## What Drives Improvement

| Optimization Applied | Typical Impact |
|---------------------|----------------|
| Tighter delegation rules | task_completion ↑ |
| Response format standardized | coherence ↑ |
| Safety guardrails added | indirect_attack ↑ |
| Prompt optimizer pass | One metric usually trades against another — verify with comparison |
| Red-teaming hardening | indirect_attack ↑ (adversarial) |

## Tips

- Small samples (n ≈ 10) mean comparisons are often Inconclusive — don't over-read 1-2 point moves
- If a score drops after a change, that's data, not failure — read the eval-comparison insight
- The prompt optimizer is a hypothesis generator, not an oracle — see [Lab 3](../docs/core/lab-3.md)
- Diminishing returns are normal — going from 3→4 is easier than 4→5
