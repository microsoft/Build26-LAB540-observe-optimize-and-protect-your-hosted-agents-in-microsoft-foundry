# Lab 0: Setup (Copilot-Assisted)

## Objective

Get a working workshop environment — Azure auth, Foundry project, hosted
agent, populated `.env`, and the three browser tabs — using Copilot as
your guide.

## Time Estimate

- **Skillable**: ~5 minutes (environment is pre-provisioned)
- **Self-Guided**: ~15 minutes (most of which is waiting on `azd up`)

## Two Ways to Run Lab 0

### Option A — Let Copilot guide you (recommended)

In any VS Code Copilot Chat window, say:

> "Run Lab 0"

(Or any of: *"set up my environment"*, *"help me set up"*, *"configure
my environment for the workshop"*.)

Copilot invokes the [`setup-env`](../../../.agents/skills/setup-env/SKILL.md)
skill. It will:

1. Ask you which path you're on (Skillable vs Self-Guided).
2. Walk you through **one command at a time** — you run each command
   in your terminal and paste the output back. Copilot validates,
   then shows you a pretty-printed ✅ achievement banner and moves on.
3. For Self-Guided, drive `cd zava && azd up` to provision your
   Foundry project + agent.
4. Populate `.env` via `scripts/discover-env.sh` (path-aware).
5. Walk you through opening the three browser tabs.

When Lab 0 completes, Copilot will tell you you're ready for Lab 1.

> **Note**: Copilot won't run commands silently. You're always the
> one in the driver's seat — Copilot dictates, you execute, you both
> validate. This is intentional so you understand what each step
> does. If you want Copilot to run a specific command for you, just
> ask explicitly.

### Option B — Walk through the docs yourself

If you'd rather follow written instructions without Copilot:

1. [`00-setup/README.md`](../00-setup/README.md) — pick your path
2. Path-specific steps:
   - Skillable: [`00-setup/skillable/`](../00-setup/skillable/README.md)
   - Self-Guided: [`00-setup/self-guided/`](../00-setup/self-guided/README.md)
3. Shared convergence steps: [`00-setup/shared/`](../00-setup/shared/README.md)

## ✅ Checkpoint

You're ready for Lab 1 when:

- [ ] You've picked a path (Skillable or Self-Guided)
- [ ] Azure CLI + Azure Developer CLI are authenticated
- [ ] Your Foundry project + hosted agent exist
- [ ] `.env` at the repo root is populated and sourced
- [ ] Three browser tabs are open: Codespace, Foundry portal, Azure portal

---

**Next**: [Lab 1 — Deploy & Validate →](./lab-1.md)
