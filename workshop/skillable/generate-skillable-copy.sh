#!/usr/bin/env bash
#
# Regenerates .skillable-copy.md from the page markdown files in this folder.
#
# Run this whenever you add, remove, or reorder pages:
#   ./workshop/skillable/generate-skillable-copy.sh
#
# It picks up every NN-*.md page file (in sorted order), excludes README.md,
# and emits one [!include[](raw-url)] directive per page, separated by ===.
#
# Branch is taken from BRANCH env var, falling back to the current git branch.
set -euo pipefail

cd "$(dirname "$0")"

REPO="microsoft/Build26-LAB540-observe-optimize-and-protect-your-hosted-agents-in-microsoft-foundry"
BRANCH="${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}/workshop/skillable"
OUT=".skillable-copy.md"

# Collect page files: NN-*.md, sorted, excluding the generator/output/README.
mapfile -t PAGES < <(ls -1 [0-9]*-*.md 2>/dev/null | sort)

if [ "${#PAGES[@]}" -eq 0 ]; then
  echo "No page files (NN-*.md) found; aborting." >&2
  exit 1
fi

{
  cat <<EOF
<!--
  LAB540 — Skillable master include file. GENERATED — do not edit by hand.
  Regenerate with: ./workshop/skillable/generate-skillable-copy.sh

  Paste the contents of this file into the Skillable lab profile's instructions
  (Edit Instructions). Skillable pulls each page live from this GitHub repo, in
  order, separated by the === page break.

  Source branch: ${BRANCH}
  To target a different branch: BRANCH=<branch> ./generate-skillable-copy.sh
-->
EOF

  first=1
  for page in "${PAGES[@]}"; do
    if [ "$first" -eq 1 ]; then
      first=0
    else
      printf '\n===\n'
    fi
    printf '\n[!include[](%s/%s)]\n' "$RAW_BASE" "$page"
  done
} > "$OUT"

echo "Wrote $OUT with ${#PAGES[@]} pages (branch: $BRANCH)."
