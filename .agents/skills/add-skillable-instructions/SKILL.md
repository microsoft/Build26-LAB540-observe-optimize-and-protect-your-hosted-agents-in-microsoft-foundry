# Skill: add-skillable-instructions

## Description

Authors, validates, and bundles Skillable-compliant lab instruction pages. Every page produced by this skill MUST conform to the Skillable Studio Markdown syntax so it renders correctly inside the Skillable VM instructions panel.

This skill has two modes:

1. **`author`** — generate or edit a single lab instruction page (one numbered file under `workshop/docs/00-setup/skillable/` or `workshop/docs/00-setup/shared/`) using Skillable syntax.
2. **`bundle`** — concatenate the ordered set of skillable + shared pages into a single Markdown file ready to paste into Skillable Studio's instructions editor, separated by `===` page breaks.

## When to Invoke

The agent says something like:
- "Write a Skillable instruction page for X"
- "Update the Skillable setup page for Y"
- "Validate this page for Skillable"
- "Generate the Skillable instructions bundle"
- "Build the paste-ready Skillable manual"

## Authoritative Reference

Skillable Studio Markdown syntax: https://docs.skillable.com/docs/creating-instructions-with-markdown-syntax

The rules below are distilled from that doc. When in doubt, defer to the live doc.

## Required Conventions for THIS Workshop

When writing for `workshop/docs/00-setup/skillable/` and `workshop/docs/00-setup/shared/`:

- Pages are short, focused, and numbered (e.g. `01-launch-vm.md`, `02-verify-azure-portal.md`).
- Each page is **self-contained** — it reads cleanly as standalone instruction for a manual learner AND can be presented one substep at a time by the `run-workshop` skill.
- Each page MUST start with an H2 (`##`) title — NOT H1. (Skillable uses H1 for the lab title via `@lab.Title`.)
- Each page ends with a clear "Next →" link to the next page in the sequence.
- The **first** page of the bundle (e.g. `00-welcome.md`) MUST contain `# @lab.Title` as the first line.
- Pages use a **page break `===` on its own line** ONLY when the page is intended to be split inside Skillable. For multi-page bundles, the `bundle` mode inserts `===` between files automatically — do NOT put `===` at the end of individual files.

## Skillable Syntax Cheat Sheet

### Headings
- `#` lab title (only at the very top, usually `# @lab.Title`)
- `##` section / page title
- `###` subsection
- Always leave a blank line before and after headings.

### Page break (Skillable-specific)
- `===` on its own line splits content into pages. Skillable shows a **Next** button per page.

### Horizontal rule
- `---` on its own line.

### Emphasis
- `**bold**`, `_italic_`, `___bold italic___`, `~~strikethrough~~`, `\` to escape.

### Code
- Inline: `` `code` ``
- Fenced: triple backticks with language (` ```bash `).
- Modifiers (append to language): `-nocolor`, `-notab`, `-nocode`, `-nocopy`, `-wrap`, `-linenums`.

### Lists
- Unordered: `- item`
- Ordered: `1. item`
- Task checkbox (counts toward lab progress in Skillable):
  - `- [] Task item` or `1. [] Task item`
  - **Use these for major step completions** — Skillable reports progress from these.

### Links
- External: `[text](url "optional title")` — opens in new window.
- Portal window: `<[text](url)` — opens in the lab's portal window.
- Dialog overlay: `^[text](url)` — opens in a dialog over the lab.

### Images
- `![alt](url)` or `!IMAGE[alt](url "title")`
- Dimensions: `![alt](url){widthxheight}` or `![alt](url){width}`

### Video / Audio
- `!video[text](url)` (YouTube auto-embeds)
- `!audio[text](url)`

### Callout blocks (use liberally to draw attention)
- `> [!Knowledge] text` — collapsed after 4 lines, "more" link expands. Best for context/explanations.
- `> [!Alert] text` — mandatory attention, always visible. Use for critical warnings.
- `> [!Hint] text` — soft suggestion.
- `> [!Help] text` — pointer to additional help.
- `> [!Note] text` — like Knowledge but never collapses.
- Expandable variants: `> [+Knowledge]`, `> [+Alert]`, `> [+Hint]`, `> [+Help]`, `> [+Note]` followed by a blank `>` line, then more content lines prefixed with `>`.

### Copy / Type text (Skillable-specific magic)
- `++text++` — **copyable**: clicking copies to local clipboard.
- `+++text+++` — **type text**: clicking types the text into the VM at the current cursor focus.
- `++++text++++` — **copy AND type**: both.

Use these for ALL commands, URLs, passwords, and config values the learner needs to enter.

### Replacement tokens (`@lab.X`)

Most useful for our workshop:

| Token | Purpose |
|---|---|
| `@lab.Title` | The lab title from the lab profile. Put `# @lab.Title` at the very top of the bundle. |
| `@lab.VirtualMachine(VM_NAME).Username` | VM username |
| `@lab.VirtualMachine(VM_NAME).Password` | VM password |
| `@lab.CloudPortalCredential(User1).Username` | Azure portal username |
| `@lab.CloudPortalCredential(User1).Password` | Azure portal password |
| `@lab.CloudSubscription.Id` | Azure subscription ID |
| `@lab.CloudSubscription.Name` | Azure subscription name |
| `@lab.CloudResourceGroup(ResourceGroup1).Name` | Pre-provisioned resource group name |
| `@lab.LabInstance.Id` | Unique running lab instance ID |
| `@lab.User.FirstName` / `@lab.User.LastName` / `@lab.User.Email` | Lab user identity |
| `@lab.CtrlAltDelete` | Sends Ctrl+Alt+Delete to active VM |

For OUR workshop specifically, replace any tokens not yet confirmed with the lab profile owner with a TODO comment in the page (`<!-- TODO: confirm token name with Skillable profile -->`) so we don't ship guessed token names.

### Interactive widgets
- `@lab.TextBox(name)` — input field; recall with `@lab.Variable(name)`.
- `@lab.MaskedTextBox(name)` — password field.
- `@lab.DropDownList(name)[val1,val2]` — dropdown.

### Reference content (define once, reuse)
- Define: `>[label]: Content`
- Reference: `!instructions[][label]`

## Validation Rules (what `author` mode checks before writing)

The skill MUST reject or fix a page that:

1. Has an `H1` other than `# @lab.Title` (only the first page in the bundle uses H1).
2. Mixes `+++` and `++` counts incorrectly (always paired, always same count on both sides: `+++text+++`, NOT `+++text++`).
3. Uses fenced code blocks for content the learner is expected to TYPE INTO THE VM — those should be `+++...+++` (type text) instead. Fenced code blocks are for reference/display only.
4. Uses `==` (two equals) where Skillable expects `===` (three equals) for page break — typo guard.
5. Has a `> [!X]` callout where X is not one of `Knowledge | Alert | Hint | Help | Note`.
6. Has a `> [+X]` expandable callout missing the blank `>` separator line before the additional content.
7. Has unbalanced `[ ]( )` link syntax.
8. References an `@lab.X` token that's not in the supported list above without a TODO comment flagging it.
9. References an image with `!IMAGE[...]` but does NOT provide alt text.

When validation fails, the skill MUST explain the violation in plain language and propose the fix before writing.

## Authoring Mode Workflow

1. Confirm the **target file path** (must live under `workshop/docs/00-setup/skillable/` or `workshop/docs/00-setup/shared/`).
2. Confirm the **page intent** in one sentence (e.g. "log into Azure portal and verify the pre-provisioned resource group").
3. Draft the page using the conventions above.
4. Run the validation rules.
5. Show the learner a preview and ask for confirmation before writing the file.
6. Write the file with `create_file` (or `replace_string_in_file` for edits).

## Bundle Mode Workflow (`generate-skillable-instructions`)

Produces `workshop/docs/00-setup/skillable/_bundle.md` — a single paste-ready file for the Skillable Studio VM instructions editor.

1. Read the **page order** from `workshop/docs/00-setup/skillable/_order.json` (created by this skill on first bundle, structure below).
2. For each page in order:
   - Read the file content.
   - Strip a leading H1 if it's not on the first page (only first page keeps `# @lab.Title`).
   - Strip any trailing `===` from the file (the bundler inserts these).
3. Concatenate pages with `\n\n===\n\n` between them.
4. Run validation rules across the full bundle (image paths, internal link targets, token consistency).
5. Write the bundle to `workshop/docs/00-setup/skillable/_bundle.md`.
6. Report: "Bundle written. Copy the contents of `_bundle.md` into Skillable Studio → Edit Instructions and save."

### `_order.json` schema

```json
{
  "lab_title_token": "@lab.Title",
  "pages": [
    { "file": "00-welcome.md", "title": "Welcome" },
    { "file": "01-launch-vm.md", "title": "Launch the lab VM" },
    { "file": "shared/02-verify-azure-portal.md", "title": "Verify Azure Portal" },
    "..."
  ]
}
```

Pages whose path begins with `shared/` are read from `workshop/docs/00-setup/shared/` (the shared folder). All others are read from `workshop/docs/00-setup/skillable/`.

## Common Pitfalls (from past authoring)

- **Quoting `@lab.X` tokens in code fences** — tokens inside fenced code blocks render literally, NOT replaced. If you need the runtime value inside a command, use `+++...+++` type-text instead of a fenced block.
- **`---` vs `===`** — `---` is a horizontal rule, `===` is a page break. Don't mix them up.
- **H1 in mid-bundle pages** — Skillable will render multiple H1s but it looks broken. Only the first page (or the bundle header) gets `# @lab.Title`.
- **Image relative paths** — Skillable's instruction package expects images at relative paths matching the upload structure (e.g. `instructions342575/image.png`). Confirm with the Skillable profile owner before relying on a particular path.

## Resources

- `resources/skillable-syntax-cheatsheet.md` — quick lookup card (subset of this skill).
- `resources/_order.template.json` — starter `_order.json`.
