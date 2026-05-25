# Skill: explain-this

## Description

Provides educational explanations of outputs, concepts, or results encountered during the workshop. Helps learners understand the "why" behind what they're seeing.

## When to Invoke

The learner says something like:
- "Explain this"
- "What does this mean?"
- "Why did that happen?"
- "What is [concept]?"
- "I don't understand this output"

## Behavior

1. **Identify what needs explaining**: Look at the most recent output, result, or concept the learner is asking about.

2. **Explain at the right level**: The target audience knows:
   - Basic Python
   - VS Code
   - General AI/ML concepts
   - Azure basics
   
   They may NOT know:
   - Foundry-specific terminology
   - Evaluation methodology details
   - Agent orchestration patterns
   - Observability best practices

3. **Structure the explanation**:
   - **What it is** (1 sentence)
   - **Why it matters** (1-2 sentences in context of the workshop)
   - **How it connects** (link to the bigger picture of observe-evaluate-optimize)

4. **Offer depth**: After the summary, offer to go deeper:
   - "Want me to explain how the scoring works?"
   - "Want to see an example?"
   - "Want to understand how this connects to the next step?"

## Key Concepts to Explain

| Concept | Short Explanation |
|---------|-------------------|
| Hosted agent | An agent deployed on Foundry infrastructure, managed for you |
| Observe skill | Automates test generation and evaluation in one pass |
| Evaluator | A function that scores agent responses on a specific dimension |
| Groundedness | Whether the response is backed by actual data (not hallucinated) |
| Batch evaluation | Running a full test dataset through the agent at once |
| Continuous evaluation | Ongoing monitoring of production traffic quality |
| Prompt optimization | Data-driven improvement of agent instructions |
| Red-teaming | Adversarial testing to find safety vulnerabilities |
| Traces | Detailed logs of every step in an agent interaction |
| Evaluation dataset | A set of test prompts with expected behaviors |

## Interaction Pattern

- Keep initial explanations SHORT (3-5 sentences)
- Use analogies when helpful
- Connect everything back to the workshop context
- Offer deeper explanation as a follow-up (don't dump everything at once)
- If the learner shares output, explain what each part means
