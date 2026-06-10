#!/usr/bin/env bash
# Installs the korean-legal-doc-drafter skill into every detected agent skill
# directory (Claude Code, Codex CLI, Hermes Agent, Magi Agent).
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/openmagi/korean-legal-doc-drafter/main/install.sh | bash
set -euo pipefail

SKILL_NAME="korean-legal-doc-drafter"
RAW_URL="https://raw.githubusercontent.com/openmagi/korean-legal-doc-drafter/main/skills/${SKILL_NAME}/SKILL.md"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
LOCAL_SRC="${SCRIPT_DIR}/skills/${SKILL_NAME}/SKILL.md"

# Candidate skill directories per agent. Only existing parents are used so we
# never scaffold config for an agent the user does not have.
CANDIDATES=(
  "$HOME/.claude/skills"   # Claude Code (also read by Magi Agent)
  "$HOME/.agents/skills"   # Codex CLI / cross-agent standard
  "$HOME/.hermes/skills"   # Hermes Agent
  "$HOME/.magi/skills"     # Magi Agent
)

targets=()
for dir in "${CANDIDATES[@]}"; do
  parent="$(dirname "$dir")"
  if [ -d "$dir" ] || [ -d "$parent" ]; then
    targets+=("$dir")
  fi
done

if [ ${#targets[@]} -eq 0 ]; then
  echo "No agent config directories found (~/.claude, ~/.agents, ~/.hermes, ~/.magi)."
  echo "Defaulting to the cross-agent standard path: ~/.agents/skills"
  targets+=("$HOME/.agents/skills")
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
if [ -n "$LOCAL_SRC" ] && [ -f "$LOCAL_SRC" ]; then
  cp "$LOCAL_SRC" "$tmp"
  echo "source: local clone ($LOCAL_SRC)"
else
  curl -fsSL "$RAW_URL" -o "$tmp"
  echo "source: $RAW_URL"
fi

# Sanity check: the file must start with YAML frontmatter naming the skill.
if ! head -5 "$tmp" | grep -q "name: ${SKILL_NAME}"; then
  echo "error: downloaded SKILL.md does not look valid (missing 'name: ${SKILL_NAME}')." >&2
  exit 1
fi

for dir in "${targets[@]}"; do
  dest="${dir}/${SKILL_NAME}"
  mkdir -p "$dest"
  cp "$tmp" "${dest}/SKILL.md"
  echo "installed: ${dest}/SKILL.md"
done

echo ""
echo "Done. Invoke with /${SKILL_NAME} (Claude Code, Magi Agent) or \$${SKILL_NAME} (Codex CLI),"
echo "or just describe a Korean legal document you need."
