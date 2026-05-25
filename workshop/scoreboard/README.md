# Scoreboard

The scoreboard tracks your agent's quality improvement across the workshop. Each time you evaluate, record your scores here to visualize the cumulative impact of your optimizations.

## How It Works

1. After **Lab 2** (first evaluation), record your baseline scores
2. After **Lab 3** (post-optimization), record improved scores
3. After each **MORE lab**, re-evaluate and add a new column

The goal: see your agent get measurably better with each optimization pass.

## Your Scorecard

Copy the template below (or use `workshop/scoreboard/template.md`) and fill in as you go:

| Metric | Baseline (Lab 2) | After Lab 3 | After MORE | Best |
|--------|-----------------|-------------|------------|------|
| Relevance | — | — | — | — |
| Groundedness | — | — | — | — |
| Coherence | — | — | — | — |
| Safety | — | — | — | — |
| Fluency | — | — | — | — |
| **Overall** | **—** | **—** | **—** | **—** |

## Interpreting Scores

| Score | Meaning |
|-------|---------|
| 5 | Excellent — meets all criteria |
| 4 | Good — minor issues only |
| 3 | Acceptable — some gaps |
| 2 | Poor — significant issues |
| 1 | Failing — does not meet criteria |

## What Drives Improvement

| Optimization Applied | Typical Impact |
|---------------------|----------------|
| Grounding rules added | Groundedness ↑ |
| Delegation logic improved | Relevance ↑, Completeness ↑ |
| Safety guardrails added | Safety ↑ |
| Response format standardized | Coherence ↑, Fluency ↑ |
| Prompt optimizer pass | All metrics ↑ (systematic) |
| Red-teaming hardening | Safety ↑ (adversarial) |

## Tips

- Scores fluctuate slightly between runs — look at trends, not single points
- If a score drops after a change, investigate (tracing lab helps)
- The prompt optimizer typically produces the largest single improvement
- Diminishing returns are normal — going from 3→4 is easier than 4→5
