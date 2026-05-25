# Skill: run-workshop

## Description

Guides a learner through the entire LAB540 workshop end-to-end, presenting one step at a time and adapting to their chosen path (Skillable vs Self-paced). Automatically tracks progress in a `progress.json` file throughout the session.

## When to Invoke

The learner says something like:
- "Run the workshop"
- "Start the workshop"
- "Guide me through the workshop"
- "Walk me through everything"

## Behavior

1. **Detect path**: Ask the learner if they are on the Skillable (in-venue, pre-deployed) or Self-paced (at-home, deploy yourself) path.

2. **Initialize progress tracking**: Before the first step, check for an existing `workshop/progress.json`.
   - If it **exists**: Read it, summarize where the learner left off, and offer to resume from `current_step` or restart.
   - If it **does not exist**: Create it from the template in `.agents/skills/run-workshop/resources/progress.template.json`, setting `started_at` to the current UTC timestamp and `path` to the detected path.

3. **Check prerequisites**: Before starting any lab, verify the environment is ready:
   - Azure CLI logged in (`az account show`)
   - Environment variables configured (`.env` exists)
   - For Skillable: agent already deployed
   - For Self-paced: Docker running, azd authenticated

4. **Present one step at a time**: Read the lab markdown files from `workshop/docs/core/` and `workshop/docs/more/`. For each step:
   - Show the learner what to do (command, action, or prompt)
   - Wait for them to confirm completion or report an issue
   - Explain the outcome and what it means
   - **Update `progress.json`** (see Progress Tracking below)
   - Then advance to the next step

5. **Handle issues**: If the learner reports an error, set `"blocked": true` in `progress.json`, switch to troubleshooting mode (similar to `help-me-debug` skill). Once resolved, set `"blocked": false` and record the fix in the step's note, then return to the next step.

6. **Scoreboard updates**: After Labs 2 and 3, prompt the learner to record their scores.

## Progress Tracking

After the learner confirms each substep is complete, update `workshop/progress.json`:

- Add the substep ID to `completed_substeps`
- When all substeps in a lab are done, add the lab ID to `completed_steps`
- Set `current_step` to the next substep ID
- Append a note to `notes` array with:
  - `substep`: the substep ID (e.g. `"01.3"`)
  - `outcome`: a concise 1–2 sentence summary of what happened, including any key values (timing, scores, URLs, errors encountered and fixed)

Write the updated JSON to `workshop/progress.json` after every substep completion. Use the `create_file` or `replace_string_in_file` tool to persist it.

### Step ID Scheme

| Step ID | Description |
|---------|-------------|
| `00` | Setup |
| `00.1` | Path detection |
| `00.2` | Prerequisites check |
| `01` | Lab 1: Deploy & Validate |
| `01.1` | Create Azure resources (self-paced only) |
| `01.2` | Build and push agent image (self-paced only) |
| `01.3` | Deploy with azd (self-paced only) |
| `01.4` | Open Microsoft Foundry Portal |
| `01.5a` | Test 1 — Basic routing |
| `01.5b` | Test 2 — Multi-component |
| `01.5c` | Test 3 — Out-of-scope handling |
| `01.6` | Note baseline behavior |
| `02` | Lab 2: Observe & Evaluate |
| `02.1` | Understand the Observe Skill |
| `02.2` | Activate the Observe Skill |
| `02.3` | Review the generated dataset |
| `02.4` | Review evaluation results (record baseline scores) |
| `02.5` | Review optimization recommendations |
| `02.6` | Update scoreboard with baseline scores |
| `03` | Lab 3: Optimize & Verify |
| `03.1` | Review top recommendation |
| `03.2` | Apply the optimization |
| `03.3` | Redeploy the agent |
| `03.4` | Re-run evaluation |
| `03.5` | Compare results |
| `03.6` | Update scoreboard with improved scores |
| `03.7` | Reflect on the observe-evaluate-optimize loop |
| `04` | Lab 4: Explore MORE |
| `04.1` | Choose a MORE lab |
| `04.2` | Complete chosen MORE lab |

### Skillable vs Self-Paced

- **Skillable** path skips steps `01.1`, `01.2`, and `01.3` (agent pre-deployed). Mark these as skipped by adding them to `skipped_steps` in `progress.json`.
- **Self-paced** path includes all steps.

## Resources

The skill reads content from:
- `workshop/docs/00-setup/` — Setup instructions
- `workshop/docs/core/lab-1.md` through `lab-4.md` — CORE labs
- `workshop/docs/more/` — MORE labs
- `workshop/scoreboard/` — Score tracking
- `.agents/skills/run-workshop/resources/progress.template.json` — Progress file template

## Lab Flow

```
Setup (path detection + prerequisites)
  → Lab 1: Deploy & Validate
  → Lab 2: Observe & Evaluate (record baseline scores)
  → Lab 3: Optimize & Verify (record improved scores)
  → Lab 4: Choose and start a MORE lab
```

## Interaction Pattern

- Present ONE instruction at a time
- Wait for learner acknowledgment before proceeding
- Explain outcomes in plain language (avoid jargon overload)
- Offer to explain deeper ("Want me to explain what just happened?")
- Keep terminal commands copy-pasteable
- If a step involves Copilot Chat interaction (e.g., invoking observe skill), tell the learner exactly what to type
- After each confirmed substep, silently update `workshop/progress.json` (no need to announce every write)

## Feedback Capture

During the run, the learner may provide comments prefixed with **`Feedback:`**. When this happens:

1. **Capture immediately** — Append the feedback to `.do_not_commit/FEEDBACK.md` under a heading for the current step (e.g., `### Step 01.3`). Include the step ID and the verbatim feedback text.
2. **Do not act on it** — Continue the workshop run without making any changes based on the feedback.
3. **Acknowledge briefly** — Confirm you've logged it (e.g., "Noted — logged to FEEDBACK.md") and move on.
4. **Batch fixes later** — Only apply fixes from FEEDBACK.md when the learner explicitly asks (e.g., "Now apply the feedback" or "Fix the issues we noted").

Feedback entries in `.do_not_commit/FEEDBACK.md` should follow this format:

```markdown
### Step <ID> — <short step name>

- <verbatim feedback text>
```
