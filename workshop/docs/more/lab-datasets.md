# MORE: Test Dataset Curation & Versioning

## Objective

Learn how to create, curate, and version test datasets for agent evaluation — from trace-based generation to manual refinement.

## What You'll Learn

- How the observe skill generates datasets from agent capabilities
- How to create datasets from production traces
- How to version datasets as your agent evolves
- Best practices for dataset diversity and coverage

---

## Step 1: Understand Dataset Structure

Evaluation datasets are JSONL files where each entry represents a test case:

```json
{
  "prompt": "What flights are available from Chicago to Rome in November?",
  "expected_behavior": "Returns flight options with IDs, prices, and dates from flights.csv",
  "category": "single-component",
  "specialist": "flight-agent"
}
```

Review the existing evaluation data:

```bash
cat data/jsonl/evaluation_data.jsonl | head -5
```

## Step 2: Generate a Dataset from Traces

If your agent has been running in production (or from your Lab 1-3 testing), you can create a dataset from actual traces:

> "Use the observe skill to create a dataset from my agent's recent traces"

This produces test cases based on real user interactions — ensuring your evaluation covers actual usage patterns.

## Step 3: Curate the Dataset

Not all auto-generated test cases are equally valuable. Review and curate:

1. **Remove duplicates** — Similar prompts that test the same behavior
2. **Add edge cases** — Scenarios the auto-generator might miss
3. **Balance categories** — Ensure coverage across all specialist agents
4. **Add adversarial cases** — Prompts designed to test boundaries

> "Help me review and curate my evaluation dataset"

## Step 4: Version Your Dataset

As your agent improves, your dataset should evolve too. Version your datasets to:
- Track which dataset was used for which evaluation
- Compare results across different dataset versions
- Roll back if a dataset change produces unexpected results

```bash
# Create a versioned copy
cp data/jsonl/evaluation_data.jsonl data/jsonl/evaluation_data_v2.jsonl
```

## Step 5: Re-evaluate with the New Dataset

Run evaluation with your curated dataset to see if scores change:

> "Evaluate my agent using the v2 dataset"

Compare results against your Lab 2 baseline to understand how dataset quality affects evaluation outcomes.

---

## ✅ Checkpoint

- [ ] Reviewed the structure of evaluation datasets
- [ ] Generated a dataset from traces (or understood the process)
- [ ] Curated at least one dataset (removed duplicates, added edge cases)
- [ ] Understand how dataset versioning works

## Scoreboard Update

After re-evaluating with your curated dataset, update your scoreboard with any changed metrics.

**Back to**: [MORE Labs](./README.md)
