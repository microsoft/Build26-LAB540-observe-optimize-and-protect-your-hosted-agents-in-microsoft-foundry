# Skillable Path (In-Venue)

You're attending the lab at Microsoft Build — your Azure subscription and
resource group are **pre-provisioned** by the Skillable lab environment.

## What's Already Done For You

- ✅ Azure subscription provisioned and selected
- ✅ Resource group created with a Microsoft Foundry project
- ✅ `gpt-4.1-mini` model deployed
- ✅ Azure Container Registry, App Insights, and supporting resources created
- ✅ Codespace template configured

## The Skillable Bundle

The files in this folder use **Skillable Studio Markdown syntax** — they
are designed to be pasted into the Skillable instructions editor, not
just read on GitHub. They will still render on GitHub but you'll see
some Skillable-specific tokens (like `++copy text++`, `+++type text+++`,
and `@lab.X` placeholders) that only become interactive inside the
Skillable VM.

> **Reviewing in VS Code preview?** Two Skillable-specific syntaxes
> render oddly in standard markdown previewers:
>
> - `<[text](url)` — Skillable's "open in portal window" link. Markdown
>   previewers eat the leading `<` and may garble brackets. In Skillable
>   Studio it renders as a proper portal-window link.
> - `++copy text++` / `+++type text+++` — Skillable's clickable
>   copy/type-to-terminal blocks. Markdown previewers show them as
>   literal `++…++` text. In Skillable Studio they become buttons.
>
> If you see weird formatting in VS Code preview, that's expected —
> trust the paste-ready bundle and let Skillable Studio render it.

| # | Page | What it covers |
|---|------|----------------|
| 1 | [00-welcome.md](./00-welcome.md) | Welcome, what's pre-provisioned, how Skillable instruction syntax works |
| 2 | [01-open-codespace.md](./01-open-codespace.md) | GitHub SSO sign-in, open Codespace, confirm Azure CLI login |
| 3 | [02-discover-env.md](./02-discover-env.md) | Run `scripts/discover-env.sh` and verify `.env` |
| 4 | [03-three-tabs.md](./03-three-tabs.md) | Open Codespace + Foundry portal + Azure portal tabs |

The page order is defined in [`_order.json`](./_order.json). Use the
[`add-skillable-instructions`](../../../../.agents/skills/add-skillable-instructions/SKILL.md)
skill to author new pages or rebuild the bundle.

## Paste-Ready Bundle

[`_bundle.md`](./_bundle.md) is the concatenated, paste-ready file for
the Skillable Studio **Edit Instructions** editor. Regenerate it
whenever you edit any of the numbered pages above:

> "Generate the Skillable instructions bundle"

(invokes the `add-skillable-instructions` skill in `bundle` mode).

---

**Once your Skillable VM is set up, continue with:**

| Step | Action |
|------|--------|
| [shared/1](../shared/1-discover-env.md) | (GitHub doc) Same content as `02-discover-env.md`, in plain markdown |
| [shared/2](../shared/2-three-tabs.md) | (GitHub doc) Same content as `03-three-tabs.md`, in plain markdown |

> **Note**: Your agent is **pre-deployed**. You don't need to run `azd up`.
> Lab 1's deployment steps are still valuable to read through — they show
> what the Skillable environment did for you behind the scenes.
