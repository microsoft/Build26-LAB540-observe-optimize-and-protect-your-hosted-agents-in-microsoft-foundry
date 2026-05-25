# Skill: setup-env

## Description

The Lab 0 backing skill — walks the learner through getting their
environment ready for the workshop. Detects their path (Skillable vs
Self-Guided), guides them through Azure auth, optionally provisions a
Foundry project + hosted agent via `azd up` (Self-Guided only),
populates the `.env` file, and validates connectivity.

## When to Invoke

The learner says something like:

- "Run Lab 0"
- "Set up my environment"
- "Configure my environment for the workshop"
- "Help me set up"
- "Run setup"

Also invoked by the `run-workshop` skill when it reaches Step 00.

## Interaction Style — Guide, Don't Do

**The learner runs every command.** This skill is a guide, not a robot.

- **Dictate, don't dispatch.** Present each command in a fenced bash
  block and ask the learner to run it in their terminal.
- **Ask for proof.** After each command, ask them to paste back the
  output (or the relevant subset). Validate against the expected
  shape before moving on.
- **Don't auto-run unless asked.** If they explicitly say "run it for
  me" or "just do it", then use a terminal tool. Otherwise, wait for
  the pasted output.
- **One command at a time.** Don't dump a sequence of commands and
  hope. Confirm completion of step N before showing step N+1.
- **Pretty-print achievements.** After each major phase, show a
  one-or-two-line success banner (see "Achievement format" below)
  so the learner knows they made forward progress.

### Achievement format

After each major phase, render exactly this shape:

```
✅ Phase N: <short phase name>
   <one-line summary of what's now ready>
```

Example:

```
✅ Phase 1: Path detected
   Self-Guided — you'll provision your own Foundry project with `azd up`.
```

Use a single emoji ✅ (or ⚠️ on partial success) — no other decoration.

## Behavior — Phased Walkthrough

Run through these phases in order. Pause at the end of each phase for
learner confirmation before starting the next.

### Phase 1 — Detect path

Ask the learner:

> "Are you taking this workshop in-venue at Microsoft Build with a
> Skillable lab environment, or are you doing it Self-Guided at home with
> your own Azure subscription?"

- Skillable → set `path = "skillable"`
- Self-Guided → set `path = "self-guided"`

Record in `workshop/progress.json` (`path` field).

**Achievement:**
```
✅ Phase 1: Path detected — <Skillable | Self-Guided>
```

### Phase 2 — Prerequisites check

Dictate:

```bash
az version | head -1 && azd version | head -1 && docker info --format '{{.ServerVersion}}' 2>&1 | head -1 && python --version
```

Ask the learner to paste the output. Validate:

- `az` present
- `azd` ≥ 1.25
- Docker running (ServerVersion line, not an error)
- Python ≥ 3.10

If any check fails, point them at
[`workshop/docs/00-setup/self-guided/1-prereqs.md`](../../../workshop/docs/00-setup/self-guided/1-prereqs.md)
and pause until they fix it.

**Achievement:**
```
✅ Phase 2: Prerequisites OK
   az <ver>, azd <ver>, docker <ver>, python <ver>.
```

### Phase 3 — Azure auth

Dictate (in order — wait for confirmation between):

1. `az login` (or `az login --use-device-code` in Codespace).
2. `az account show --query '{name:name, id:id}' -o table` — ask
   learner to paste output and confirm the subscription is correct.
3. `azd auth login` (or `azd auth login --use-device-code`).

**Achievement:**
```
✅ Phase 3: Authenticated to Azure
   Subscription: <name>
```

### Phase 4 — Provision (Self-Guided only)

Skip this phase entirely if `path == "skillable"`.

Dictate (one at a time):

1. `cd zava`
2. `azd env new lab540` — prompt for region, recommend `eastus2`
   (see `zava/README.md` §4.4 for the supported set).
3. `azd up` — long-running (~5–8 min). Tell the learner to leave it
   running and come back when they see "SUCCESS" or the Foundry portal
   URL.
4. `azd env get-values | grep -E '^(AZURE_AI_PROJECT_ENDPOINT|FOUNDRY_AGENT_ID)='`
   — ask learner to paste output and confirm both are populated.

If `azd up` fails, hand off to the `help-me-debug` skill.

**Achievement:**
```
✅ Phase 4: Foundry project provisioned + agent deployed
   Endpoint: <project endpoint>
```

### Phase 5 — Populate `.env`

Dictate (from the **repo root**, not `zava/`):

```bash
chmod +x scripts/discover-env.sh
./scripts/discover-env.sh
```

Then:

```bash
set -a; source .env; set +a
echo "RG:         $AZURE_RESOURCE_GROUP"
echo "Endpoint:   $AZURE_AI_PROJECT_ENDPOINT"
echo "Deployment: $AZURE_AI_MODEL_DEPLOYMENT_NAME"
echo "ACR:        $AZURE_CONTAINER_REGISTRY_NAME"
```

Ask learner to paste output. All four lines must be non-empty.

**Achievement:**
```
✅ Phase 5: .env populated
   RG <rg>, deployment <name>, ACR <name>.
```

### Phase 6 — Three browser tabs

Walk the learner through opening the three tabs as described in
[`workshop/docs/00-setup/shared/2-three-tabs.md`](../../../workshop/docs/00-setup/shared/2-three-tabs.md).

Ask them to confirm each one is open and showing the expected content
before moving on.

**Achievement:**
```
✅ Phase 6: Three tabs open
   Codespace + Foundry portal + Azure portal — ready for Lab 1.
```

### Final summary

Render one combined banner:

```
🎉 Lab 0 complete — environment is ready.
   Path: <Skillable | Self-Guided>
   Foundry project: <name> in <region>
   Hosted agent: <agent id>
   Next: Lab 1 — Deploy & Validate (../../workshop/docs/core/lab-1.md)
```

Update `workshop/progress.json`:

- Mark `00.1`–`00.6` complete
- Set `current_step` to `1.1`
- Append a note describing the final phase outcome

## Required Environment Variables

The `.env` at the repo root should contain (all populated by
`discover-env.sh`):

- `AZURE_SUBSCRIPTION_ID`
- `AZURE_RESOURCE_GROUP`
- `AZURE_LOCATION`
- `AZURE_AI_PROJECT_ENDPOINT`
- `AZURE_AI_MODEL_DEPLOYMENT_NAME` (default `gpt-4.1-mini`)
- `AZURE_CONTAINER_REGISTRY_NAME`
- `AZURE_CONTAINER_REGISTRY_LOGIN_SERVER`
- `APPLICATIONINSIGHTS_CONNECTION_STRING` (Application Insights — used by Lab 4 tracing)
- `FOUNDRY_AGENT_ID`

## Related Docs

- [`workshop/docs/00-setup/README.md`](../../../workshop/docs/00-setup/README.md) — overview + path picker
- [`workshop/docs/00-setup/self-guided/`](../../../workshop/docs/00-setup/self-guided/README.md) — Self-Guided steps
- [`workshop/docs/00-setup/skillable/`](../../../workshop/docs/00-setup/skillable/README.md) — Skillable steps
- [`workshop/docs/00-setup/shared/`](../../../workshop/docs/00-setup/shared/README.md) — convergence steps
- [`workshop/docs/core/lab-0.md`](../../../workshop/docs/core/lab-0.md) — Lab 0 landing page

## Hand-offs

- On any failure → `help-me-debug` skill
- On completion → `what-next` skill (or directly invoke Lab 1)
