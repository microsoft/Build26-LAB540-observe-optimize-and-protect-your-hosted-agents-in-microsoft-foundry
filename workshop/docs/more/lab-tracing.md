# MORE: Trace-Linked Analysis & Debugging

## Objective

Learn to use Foundry tracing to debug specific agent failures, understand execution flow, and identify root causes.

## What You'll Learn

- How tracing works for hosted agents on Foundry
- How to find and read traces for failed evaluations
- How to trace multi-agent orchestration flows
- How to use trace data to inform optimizations

---

## Step 1: Understand Tracing for Agents

Foundry captures detailed traces of every agent interaction:

```
User Query
  → Concierge Agent (planning)
    → Flight Agent (tool call)
    → Hotel Agent (tool call)
    → Car Rental Agent (tool call)
  → Concierge Agent (composition)
→ Final Response
```

Each step records:
- Input/output tokens
- Latency
- Model used
- Success/failure status
- Full request/response content

## Step 2: Find Traces for Failed Evaluations

In Lab 2, some evaluation test cases likely scored low. Let's trace them:

> "Show me the traces for evaluation test cases that scored below 3 on groundedness"

This links evaluation results directly to the underlying traces — so you can see exactly what went wrong.

## Step 3: Analyze a Multi-Agent Trace

Pick a failed trace and examine the orchestration:

> "Walk me through this trace step by step — what did the concierge do, what did each specialist return?"

Look for:
- **Incorrect delegation**: Did the concierge call the wrong specialist?
- **Missing delegation**: Did the concierge forget to call a specialist?
- **Data loss**: Did the specialist return data that the concierge dropped?
- **Hallucination**: Did the concierge add information not in specialist responses?

## Step 4: Identify Root Causes

Common root causes visible in traces:

| Symptom in Eval | Root Cause in Trace |
|-----------------|-------------------|
| Low groundedness | Concierge adds details not in specialist response |
| Low relevance | Wrong specialist called for the query type |
| Low completeness | Not all specialists called for multi-component request |
| High latency | Specialist calls made sequentially instead of parallel |

> "Based on this trace, what's the root cause of the low score?"

## Step 5: Use Traces to Inform Optimization

Now that you know the root cause, apply a targeted fix:

1. If delegation is wrong → Update concierge instructions for better routing
2. If data is lost → Improve the composition step in concierge prompt
3. If specialists fail → Update specialist agent prompts
4. If latency is high → Adjust orchestration to parallelize calls

> "Based on this trace analysis, what specific change should I make to the agent instructions?"

## Step 6: Verify with a Targeted Re-evaluation

After fixing, re-run just the failing test cases:

> "Re-evaluate only the test cases that scored below 3 on groundedness"

Check that the specific failures are resolved without regressing elsewhere.

---

## ✅ Checkpoint

- [ ] Understand how tracing captures multi-agent interactions
- [ ] Found traces linked to failed evaluations
- [ ] Identified at least one root cause from trace analysis
- [ ] Applied a targeted fix based on trace insights
- [ ] Verified the fix with re-evaluation

## Scoreboard Update

After trace-informed fixes, update your scoreboard — especially the metrics that were failing.

**Back to**: [MORE Labs](./README.md)
