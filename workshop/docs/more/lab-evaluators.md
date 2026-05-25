# MORE: Custom Evaluators & Metrics

## Objective

Learn how to build custom evaluators that go beyond built-in metrics, tailoring evaluation to your agent's specific quality requirements.

## What You'll Learn

- How built-in evaluators work (relevance, groundedness, safety, coherence)
- When and why to create custom evaluators
- How to build evaluators for domain-specific quality criteria
- How to combine multiple evaluators into an evaluation suite

---

## Step 1: Understand Built-in Evaluators

Foundry provides several built-in evaluators:

| Evaluator | What It Measures | When It Fails |
|-----------|-----------------|---------------|
| Relevance | Response answers the question | Off-topic or incomplete responses |
| Groundedness | Response is backed by source data | Hallucinated details |
| Coherence | Response is logical and well-structured | Disjointed or contradictory answers |
| Safety | Response avoids harmful content | Toxic, biased, or dangerous content |
| Fluency | Response reads naturally | Awkward or unnatural language |

Review your Lab 2 results to see these in action:

> "Show me the detailed evaluation results broken down by evaluator"

## Step 2: Identify Custom Evaluation Needs

For the Zava Travel Concierge, domain-specific quality criteria might include:

- **Completeness**: Does a multi-component response include all requested parts?
- **Data accuracy**: Are prices, IDs, and dates correct per the CSV data?
- **Delegation correctness**: Did the concierge call the right specialist agent?
- **Policy compliance**: Does the response follow Zava Travel policies?

> "What custom evaluators would be most valuable for my travel concierge agent?"

## Step 3: Build a Custom Evaluator

Create a custom evaluator for one of the criteria above. For example, a **completeness evaluator** for multi-component requests:

> "Help me create a custom evaluator that checks if multi-component travel requests receive complete responses covering all requested services"

The evaluator should:
1. Parse the original request to identify requested components (flights, hotels, cars)
2. Check the response for each component
3. Score based on completeness (0-5 scale)

## Step 4: Run Evaluation with Custom Metrics

Add your custom evaluator to the evaluation suite and re-run:

> "Evaluate my agent using both built-in and my custom completeness evaluator"

## Step 5: Analyze Custom Metric Results

Review where your custom evaluator reveals issues that built-in evaluators missed:

> "Show me cases where built-in evaluators passed but my custom evaluator failed"

This often reveals domain-specific gaps in agent quality.

---

## ✅ Checkpoint

- [ ] Understand how each built-in evaluator works
- [ ] Identified at least one custom evaluation criterion for Zava Travel
- [ ] Created (or started creating) a custom evaluator
- [ ] Understand how to combine evaluators into a suite

## Scoreboard Update

Add your custom metric to the scoreboard and track it alongside built-in metrics.

**Back to**: [MORE Labs](./README.md)
