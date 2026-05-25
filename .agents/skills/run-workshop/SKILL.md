# Skill: run-workshop

## Description

Guides a learner through the entire LAB540 workshop end-to-end —
presenting one step at a time, adapting to their chosen path
(Skillable vs Self-Guided), and tracking progress in
`workshop/progress.json`.

## When to Invoke

The learner says something like:

- "Run the workshop"
- "Start the workshop"
- "Guide me through the workshop"
- "Walk me through everything"
- "Resume the workshop"

## Interaction Style — Guide, Don't Do

**The learner runs every command.** This skill orchestrates; the learner
executes.

- **One step at a time.** Show a single command (or one Foundry portal
  click), wait for the learner to run it and paste back the output,
  validate, then move on.
- **Don't auto-run.** Don't use terminal tools to dispatch commands
  unless the learner explicitly asks ("just do it" / "run it for me").
- **Explain, briefly.** After each step, give a 1–2 sentence "what
  just happened and why" so the learner builds intuition.
- **Pretty-print achievements.** After each major phase or lab
  completion, render an achievement banner (see format below).
- **Capture feedback verbatim.** When the learner prefixes a message
  with `Feedback:`, log it to `.do_not_commit/FEEDBACK.runN.md` and
  continue — do not act on it mid-run.

### Achievement format

After each major phase or lab completion, render:

```
✅ Lab N: <lab name>
   <one-line summary of what's now true that wasn't before>
```

Example:

```
✅ Lab 2: Observe & Evaluate
   Baseline scores recorded — Relevance 3.4, Groundedness 4.1, Safety 5.0.
```

## Behavior

### 1. Resume or start

Read `workshop/progress.json`.

- **If file exists and is mid-run** (any `completed_substeps` and not
  100% complete): Summarize where the learner left off (path,
  current_step, last note). Ask: *"Resume from `<current_step>`, or
  start over?"*
- **If file exists and `blocked == true`**: Read `blocked_reason`,
  explain to the learner what blocked them last time, and offer to
  retry or skip.
- **If file does not exist or is the unfilled template**: Initialize
  it from `.agents/skills/run-workshop/resources/progress.template.json`
  with `started_at = <current UTC>` and proceed to Step 00 (Lab 0).

### 2. Lab 0 — Setup

**Always** start with Lab 0. Hand off to the
[`setup-env`](../setup-env/SKILL.md) skill (delegate by following its
phased walkthrough). Lab 0 covers:

| Substep | Phase |
|---------|-------|
| `00.1` | Path detection (Skillable or Self-Guided) |
| `00.2` | Prerequisites check |
| `00.3` | Azure auth (`az login`, `azd auth login`) |
| `00.4` | Provision (`cd zava && azd up`) — **Self-Guided only**; skipped + marked in `skipped_steps` for Skillable |
| `00.5` | Populate `.env` via `scripts/discover-env.sh` |
| `00.6` | Open three browser tabs (Codespace, Foundry portal, Azure portal) |

After each substep, persist `progress.json` (add to
`completed_substeps`, advance `current_step`, append a note).

### 3. CORE labs (in order)

| Lab | Substeps | Notes |
|-----|----------|-------|
| Lab 1 — Deploy & Validate | `01.1`–`01.6` | For **Skillable**, mark `01.1`–`01.3` (the `azd up` deployment substeps) as `skipped_steps` since the agent is pre-deployed. Both paths run `01.4`–`01.6` (Foundry portal + test prompts + baseline notes). |
| Lab 2 — Observe & Evaluate | `02.1`–`02.6` | Record baseline scores at `02.4`/`02.6`. |
| Lab 3 — Optimize & Verify | `03.1`–`03.7` | Record optimized scores at `03.5`/`03.6`. |
| Lab 4 — Explore MORE | `04.1`–`04.2` | Learner picks one of the MORE labs. |

For each substep:

1. Read the relevant section of the lab markdown in
   `workshop/docs/core/lab-N.md`.
2. Present a single command or action.
3. Wait for learner to run it and paste output.
4. Validate, explain briefly, persist progress.
5. Advance.

### 4. MORE labs (optional)

After Lab 4, ask the learner if they want to continue with another MORE
lab. Read from `workshop/docs/more/lab-*.md`. Track in
`completed_steps` using IDs `more.<lab-slug>`.

### 5. Handle blockers

If the learner reports an error:

1. Set `blocked = true`, write `blocked_reason` to `progress.json`.
2. Hand off to the [`help-me-debug`](../help-me-debug/SKILL.md) skill.
3. On resolution: set `blocked = false`, append a `blocker.resolved`
   note, continue.

## Progress Tracking

After **every** confirmed substep, write `workshop/progress.json`:

- Add the substep ID to `completed_substeps`.
- When every substep in a lab is done, add the lab ID to
  `completed_steps`.
- Set `current_step` to the next substep ID.
- Append to `notes` array:

```json
{ "substep": "02.4", "outcome": "Baseline scores: Rel 3.4 / Gnd 4.1 / Safety 5.0. Eval ran 4m 12s." }
```

Use `create_file` (first write) or `replace_string_in_file` to persist.
Don't announce every write — just keep the file fresh.

### Step ID Scheme

| Step ID | Lab | Description |
|---------|-----|-------------|
| `00` | Lab 0 — Setup | |
| `00.1` | | Path detection |
| `00.2` | | Prerequisites check |
| `00.3` | | Azure auth |
| `00.4` | | `azd up` provision (Self-Guided only) |
| `00.5` | | `.env` populated via `discover-env.sh` |
| `00.6` | | Three browser tabs open |
| `01` | Lab 1 — Deploy & Validate | |
| `01.1` | | `cd zava && azd up` (Self-Guided only — usually already done in `00.4`; revisit only if not) |
| `01.2` | | `./scripts/discover-env.sh` re-run if needed |
| `01.3` | | (Optional) ACR image inspect |
| `01.4` | | Open Foundry portal |
| `01.5a` | | Test 1 — Basic routing |
| `01.5b` | | Test 2 — Multi-component |
| `01.5c` | | Test 3 — Out-of-scope handling |
| `01.6` | | Note baseline behavior |
| `02` | Lab 2 — Observe & Evaluate | |
| `02.1` | | Understand the Observe skill |
| `02.2` | | Activate the Observe skill |
| `02.3` | | Review the generated dataset |
| `02.4` | | Review eval results (record baseline) |
| `02.5` | | Review optimization recommendations |
| `02.6` | | Update scoreboard with baseline |
| `03` | Lab 3 — Optimize & Verify | |
| `03.1` | | Review top recommendation |
| `03.2` | | Apply the optimization |
| `03.3` | | Redeploy the agent |
| `03.4` | | Re-run evaluation |
| `03.5` | | Compare results |
| `03.6` | | Update scoreboard with optimized scores |
| `03.7` | | Reflect on the loop |
| `04` | Lab 4 — Explore MORE | |
| `04.1` | | Choose a MORE lab |
| `04.2` | | Complete chosen MORE lab |

### Skillable vs Self-Guided

- **Skillable**: skip `00.4`, `01.1`, `01.2`, `01.3` (agent
  pre-deployed). Add them to `skipped_steps`.
- **Self-Guided**: run all substeps. Substeps `00.4`–`00.5` and
  `01.1`–`01.2` are functionally similar — by the time the learner
  reaches `01.1` they'll likely already have a deployed agent from
  Lab 0. Confirm that and mark them complete-as-prior or just
  re-verify quickly.

## Resources

The skill reads content from:

- `workshop/docs/00-setup/{README.md, skillable/, self-guided/, shared/}` — Lab 0 prerequisites and setup paths
- `workshop/docs/core/lab-0.md` through `lab-4.md` — CORE labs
- `workshop/docs/more/lab-*.md` — MORE labs
- `workshop/scoreboard/` — Score tracking
- `.agents/skills/run-workshop/resources/progress.template.json` — Progress file template

## Lab Flow

```
Lab 0 (Setup, via setup-env skill)
    ↓ Environment ready
Lab 1: Deploy & Validate
    ↓ Agent running, baseline observed
Lab 2: Observe & Evaluate
    ↓ Baseline scores recorded
Lab 3: Optimize & Verify
    ↓ Optimized scores recorded
Lab 4: Explore MORE
    ↓ One deep-dive complete
```

## Hand-offs

- Lab 0 → [`setup-env`](../setup-env/SKILL.md) skill
- Any error → [`help-me-debug`](../help-me-debug/SKILL.md) skill
- "What just happened?" → [`explain-this`](../explain-this/SKILL.md) skill
- "What's next?" → [`what-next`](../what-next/SKILL.md) skill
- Mid-lab restart → [`complete-lab`](../complete-lab/SKILL.md) skill

## Feedback Capture

When the learner prefixes a message with **`Feedback:`**:

1. **Capture immediately** to `.do_not_commit/FEEDBACK.runN.md` (use
   `run1`, `run2`, etc. — one file per run). Append under a heading
   for the current step:

   ```markdown
   ### Step <ID> — <short step name>

   - <verbatim feedback text>
   ```

2. **Do not act on it mid-run.** Continue the workshop.
3. **Acknowledge briefly**: "Noted — logged to FEEDBACK.runN.md."
4. **Apply later** only when the learner explicitly asks (e.g., "now
   apply the feedback"). At that point, hand off to whichever skill
   owns the affected area, or apply directly if the change is small.
