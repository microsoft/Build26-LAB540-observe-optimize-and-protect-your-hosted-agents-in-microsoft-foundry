# Troubleshooting

Known issues and fixes for problems learners hit during LAB540.

> **Tip:** If you hit something not listed here, ask Copilot: **"help me debug"** — it will route to the [Help Me Debug skill](../../.agents/skills/help-me-debug/SKILL.md).

---

## Lab 0 — Setup

### `azd up` fails with `ERROR: validating service 'zava-concierge'`

**Symptom:** `azd up` provisions infrastructure but fails to build/push the container.

**Likely causes:**
- Docker daemon not running in your dev container (rare — Codespaces dev container ships with it).
- ACR role assignment hasn't propagated yet. Re-run `azd up` once.
- You're on a quota-constrained Azure region. Pick a different region (`azd env set AZURE_LOCATION eastus2`) and retry.

---

### `discover-env.sh` fails with `AZD_ENV_DIR: unbound variable`

**Fixed in this template** (commit `fix(scripts): define AZD_ENV_DIR…`). If you see it on an old branch, pull latest.

---

### Codespace shows the wrong Azure tenant in the **Accounts** panel

**Symptom:** You ran `az login --tenant <provided>` successfully in the terminal, but VS Code's left-rail **Accounts** icon still shows a different tenant — and Foundry MCP tools fail with auth errors.

**Cause:** The terminal `az` CLI and the VS Code Azure account use **separate credential caches**. Logging in via CLI does **not** sign in VS Code itself.

**Fix:**
1. Click the **Accounts** icon (bottom-left of the Activity Bar).
2. Sign out of any existing Azure account.
3. **Sign in to Azure** → pick the tenant matching your subscription.
4. Reload window if Copilot still shows stale state: `Cmd/Ctrl+Shift+P` → `Developer: Reload Window`.

---

## Lab 2 — Observe & Evaluate

### Foundry MCP `agent_*` tools return generic errors

**Symptom:** Calls like `agent_get`, `agent_invoke`, or `agent_container_status_get` fail with messages like `"Internal error"` or `"Agent not found"` even though the agent shows **Active** in the portal.

**Likely causes:**
1. **Tenant mismatch in VS Code** (see Lab 0 entry above) — fix that first.
2. **Stale agent name/version**: confirm with the portal which agent name + version is currently Active, and pass those to the MCP tool.
3. **Project endpoint missing from `.env`**: re-run `scripts/discover-env.sh` to repopulate `FOUNDRY_PROJECT_ENDPOINT`.

---

### `tool_call_accuracy` / `tool_selection` evaluators error on every row

**Symptom:** Phase 1 batch eval completes, but those two evaluators show `Errored` on 10/10 rows. Other evaluators (`task_completion`, `coherence`, `indirect_attack`) score fine.

**Cause:** These evaluators require structured tool-trace data that **hosted agents don't currently emit in the format the evaluator expects**. It's a known contract gap between hosted-agent traces and the built-in tool evaluators.

**Workaround (current template):** Phase 1 evaluator config **does not include** `tool_call_accuracy` or `tool_selection`. If you re-added them experimentally, remove them from `zava/src/zava-travel-concierge/.foundry/evaluators/phase1-builtin.yaml` until the contract is fixed.

---

### Batch eval shows `TooFewSamples` / `Inconclusive` in the comparison

**Symptom:** Lab 3 produces a baseline vs optimized comparison and most metrics show p-value `TooFewSamples` or status `Inconclusive`.

**Cause:** Workshop sample sizes are deliberately small (n ≈ 10) to keep eval runs fast. Statistical tests need larger samples to detect small effects with confidence.

**This is a real lesson, not a bug.** When the optimizer "improves" a metric by 1–2 points on n=10, you genuinely can't tell signal from noise. In production you'd run 50–200 samples per condition.

---

## Lab 3 — Optimize & Verify

### `prompt_optimize` returns instructions with garbled / mojibake characters

**Symptom:** The optimized instructions returned by `prompt_optimize` contain weird characters where Unicode used to be (e.g. `—` becomes `â€"`, bullets become `â€¢`, smart quotes become `â€œâ€`).

**Cause:** A round-trip encoding issue in the optimizer's JSON serialization. If your **input** instructions contain Unicode (em-dash, smart quotes, bullets, emoji), they can come back corrupted.

**Workarounds:**
1. **Use ASCII-only instructions** as your seed (replace `—` with `--`, `…` with `...`, `"smart quotes"` with `"straight quotes"`).
2. **Manually fix the output** before pasting back into `main.py` — do a find/replace on the mojibake patterns.
3. **Treat the optimizer output as a suggestion**, not as final text — read it, decide what's good, and rewrite it cleanly.

---

### Optimized agent scores **lower** than baseline

**Symptom:** You ran `prompt_optimize`, deployed, re-evaluated — and your task_completion (or another metric) **dropped**.

**This is normal and expected.** Prompt optimization is **empirical, not magic**:

- The optimizer generates a hypothesis based on a tiny sample of failures.
- That hypothesis trades off one metric against another (e.g., gains safety, loses task completion).
- With small samples, "improvements" can be within statistical noise.

**What to do:**
1. **Read the eval-comparison insight** in the portal — it tells you which metrics moved and by how much.
2. **Decide whether the tradeoff is acceptable** for your use case (e.g., +10pp safety for −22pp task completion may or may not be worth it).
3. **Iterate**: edit instructions manually based on what you learned, redeploy, re-evaluate.
4. **Don't worship the optimizer.** It's a starting point.

---

### `azd deploy` rebuilds the container from scratch every time

**This is correct behavior.** The hosted agent is a container image; any change to `main.py`, `requirements.txt`, or instructions requires a rebuild + push to ACR + new revision deployed.

To speed iterations:
- Use the bare `azd deploy` (not `azd up`) — skips infra provisioning.
- Don't kill the deploy mid-flight; partial pushes can leave the agent in an indeterminate state.

---

## Generally useful

### Where do I find my IDs?

| What | Where |
|------|-------|
| Subscription ID | `az account show --query id -o tsv` |
| Tenant ID | `az account show --query tenantId -o tsv` |
| Resource group | `azd env get-values \| grep RESOURCE_GROUP` |
| Foundry project endpoint | `azd env get-values \| grep FOUNDRY_PROJECT_ENDPOINT` |
| Agent name + version | Foundry portal → Agents tab |

### Where do per-learner files live (and which are gitignored)?

```
.env                           # gitignored - learner secrets
zava/.azure/<env>/.env         # gitignored - azd env state
.foundry/results/              # gitignored - eval result JSON
workshop/progress.json         # gitignored - your workshop progress
workshop/scoreboard/<name>.md  # gitignored - your scoreboard
```

Workshop seed files **are** tracked:

```
.foundry/agent-metadata.yaml   # tracked - SHOULD NOT contain your project ID
.foundry/datasets/             # tracked - seed datasets
.foundry/evaluators/           # tracked - evaluator configs
workshop/scoreboard/README.md  # tracked
workshop/scoreboard/template.md # tracked
```

If you see your project endpoint or ACR name in a tracked file, **revert it before committing**.
