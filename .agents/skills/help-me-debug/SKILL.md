# Skill: help-me-debug

## Description

Context-aware troubleshooting when something goes wrong during the workshop. Analyzes errors, suggests fixes, and guides the learner to resolution.

## When to Invoke

The learner says something like:
- "Help me debug"
- "I got an error"
- "Something went wrong"
- "This isn't working"
- "Why did this fail?"

## Interaction Style — Guide, Don't Do

The learner runs every diagnostic command and applies every fix. Follow
the same conventions as the
[`run-workshop`](../run-workshop/SKILL.md) skill:

- Dictate one diagnostic command at a time, learner runs it and pastes
  back the output, you interpret.
- Don't auto-dispatch terminal commands unless the learner explicitly
  asks ("just do it" / "run it for me").
- After resolving the blocker, render:
  ```
  ✅ Blocker resolved: <short summary>
     Returning you to <step ID>.
  ```
- Capture `Feedback:` messages to `.do_not_commit/FEEDBACK.runN.md`
  and continue.

## Behavior

1. **Gather context**: Ask the learner to share:
   - The command they ran (or action they took)
   - The error message or unexpected output
   - Which lab/step they're on

2. **Diagnose**: Based on the error, identify the likely cause:
   - Environment issues (missing vars, wrong subscription, expired login)
   - Infrastructure issues (deployment failed, resource not found)
   - Agent issues (agent not responding, wrong behavior)
   - Tooling issues (Docker not running, CLI version mismatch)

3. **Fix**: Provide a specific, actionable fix:
   - Show the exact command to run
   - Explain why it fixes the problem
   - If uncertain, offer 2-3 possible causes ranked by likelihood

4. **Verify**: After the fix, verify the issue is resolved:
   - Re-run the failing command
   - Confirm expected output
   - Return the learner to their lab step

## Common Issues and Fixes

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `az: command not found` | Azure CLI not installed | Install via brew/apt/winget |
| `AADSTS700024` | Azure login expired | `az login` |
| `docker: Cannot connect` | Docker not running | Start Docker Desktop |
| `azd up` fails | Missing env vars | Run `scripts/discover-env.sh` |
| Agent returns 404 | Not deployed | Check deployment status in portal |
| Agent returns errors | Misconfigured env | Verify `AZURE_AI_MODEL_DEPLOYMENT_NAME` |
| Evaluation times out | Agent too slow | Check agent logs in Foundry |

## Interaction Pattern

- Ask for the error FIRST (don't guess)
- Provide ONE likely fix at a time
- Verify the fix worked before moving on
- If the first fix doesn't work, try alternatives
- Return the learner to their lab when resolved
