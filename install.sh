#!/usr/bin/env bash
# Installs the korean-legal-doc-drafter skill (SKILL.md + references/) into every
# detected agent skill directory (Claude Code, Codex CLI, Hermes Agent, Magi Agent).
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/openmagi/korean-legal-doc-drafter/main/install.sh | bash
set -euo pipefail

SKILL_NAME="korean-legal-doc-drafter"
TARBALL_URL="https://github.com/openmagi/korean-legal-doc-drafter/archive/refs/heads/main.tar.gz"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
LOCAL_SRC="${SCRIPT_DIR}/skills/${SKILL_NAME}"

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

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

if [ -n "$LOCAL_SRC" ] && [ -f "${LOCAL_SRC}/SKILL.md" ]; then
  src="$LOCAL_SRC"
  echo "source: local clone ($LOCAL_SRC)"
else
  curl -fsSL "$TARBALL_URL" | tar -xz -C "$workdir"
  src="$(find "$workdir" -type d -name "$SKILL_NAME" -path "*/skills/*" | head -1)"
  if [ -z "$src" ] || [ ! -f "${src}/SKILL.md" ]; then
    echo "error: could not locate skills/${SKILL_NAME}/SKILL.md in downloaded archive." >&2
    exit 1
  fi
  echo "source: $TARBALL_URL"
fi

# Sanity check: SKILL.md must start with YAML frontmatter naming the skill.
if ! head -5 "${src}/SKILL.md" | grep -q "name: ${SKILL_NAME}"; then
  echo "error: SKILL.md does not look valid (missing 'name: ${SKILL_NAME}')." >&2
  exit 1
fi

ref_count=$(find "${src}/references" -name 'doc-*.md' 2>/dev/null | wc -l | tr -d ' ')

for dir in "${targets[@]}"; do
  dest="${dir}/${SKILL_NAME}"
  mkdir -p "$dest"
  rm -rf "${dest}/references"
  cp "${src}/SKILL.md" "${dest}/SKILL.md"
  if [ -d "${src}/references" ]; then
    cp -R "${src}/references" "${dest}/references"
  fi
  echo "installed: ${dest}/ (SKILL.md + ${ref_count} reference guides)"
done

echo ""
echo "Done. Invoke with /${SKILL_NAME} (Claude Code, Magi Agent) or \$${SKILL_NAME} (Codex CLI),"
echo "or just describe a Korean legal document you need."
