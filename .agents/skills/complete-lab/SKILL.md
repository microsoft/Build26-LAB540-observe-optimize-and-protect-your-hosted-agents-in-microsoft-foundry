# Skill: complete-lab

## Description

Guides a learner through a specific lab, presenting one step at a time. Takes a lab identifier as input.

## When to Invoke

The learner says something like:
- "Complete lab 2"
- "Do lab 3"
- "Walk me through the datasets lab"
- "Complete lab red-teaming"
- "Start lab observe and evaluate"

## Input

A lab identifier. Valid values:
- `1`, `lab-1`, `deploy` — Lab 1: Deploy & Validate
- `2`, `lab-2`, `observe`, `evaluate` — Lab 2: Observe & Evaluate
- `3`, `lab-3`, `optimize` — Lab 3: Optimize & Verify
- `4`, `lab-4`, `explore` — Lab 4: Explore MORE
- `datasets` — MORE: Test Dataset Curation
- `evaluators` — MORE: Custom Evaluators
- `continuous-eval` — MORE: Continuous Evaluation
- `red-teaming` — MORE: Adaptive Red-Teaming
- `tracing` — MORE: Trace-Linked Analysis
- `prompt-optimizer` — MORE: Prompt Optimization

## Behavior

1. **Identify the lab**: Parse the learner's request to determine which lab they want.

2. **Check prerequisites**: Each lab has prerequisites listed in its checkpoint. Verify:
   - Previous lab checkpoints are complete (for CORE labs)
   - Environment is configured
   - Required tools are available

3. **Present steps one at a time**: Read the appropriate lab markdown file and guide the learner through each step:
   - Show the instruction (command, action, or Copilot prompt)
   - Wait for confirmation or error report
   - Explain the result
   - Advance to next step

4. **Handle completion**: When the lab is done, show the checkpoint and confirm all items are satisfied.

## Resources

Lab content files:
- `workshop/docs/core/lab-1.md`
- `workshop/docs/core/lab-2.md`
- `workshop/docs/core/lab-3.md`
- `workshop/docs/core/lab-4.md`
- `workshop/docs/more/lab-datasets.md`
- `workshop/docs/more/lab-evaluators.md`
- `workshop/docs/more/lab-continuous-eval.md`
- `workshop/docs/more/lab-red-teaming.md`
- `workshop/docs/more/lab-tracing.md`
- `workshop/docs/more/lab-prompt-optimizer.md`

## Interaction Pattern

- ONE step at a time
- Clear, copy-pasteable commands
- Explain outcomes concisely
- Confirm checkpoint items at the end
- Suggest next lab when complete
