# Skill: what-next

## Description

Tells the learner what their next step is based on their current progress in the workshop.

## When to Invoke

The learner says something like:
- "What next?"
- "What should I do now?"
- "Where was I?"
- "What's the next step?"
- "I'm back — where do I continue?"

## Behavior

1. **Determine current position**: Figure out where the learner is by checking:
   - Recent conversation history (what lab were they on?)
   - Environment state (is agent deployed? are there eval results?)
   - Ask if uncertain: "Which lab are you working on?"

2. **State the next action clearly**:
   - Name the lab and step number
   - Give the specific instruction (command or action)
   - Briefly explain why this step matters

3. **Offer context**: Let the learner know:
   - How far through the current lab they are
   - What comes after this step
   - How much time they likely have left (for in-venue attendees)

## Progress Detection Heuristics

| Signal | Likely Position |
|--------|----------------|
| No .env file | Setup not complete |
| .env exists, no agent deployed | Before Lab 1 |
| Agent deployed, no eval results | Lab 1 complete, start Lab 2 |
| Eval results exist, no v2 | Lab 2 complete, start Lab 3 |
| v2 deployed with improved scores | Lab 3 complete, start Lab 4/MORE |

## Interaction Pattern

- Give ONE clear next action
- Don't overwhelm with the full roadmap
- If the learner seems lost, offer to restart from the nearest checkpoint
- If they've completed CORE, suggest a MORE lab based on their interests
