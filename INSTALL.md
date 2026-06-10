# INSTALL.md — Agent Self-Install Instructions

> **If you are an AI agent** (Claude Code, Codex CLI, Hermes Agent, Magi Agent, or similar)
> and a user gave you this repository URL asking to install the skill, follow the steps below.
> No build step, no dependencies — installation is copying one markdown file.

## What you are installing

A single skill file: `skills/korean-legal-doc-drafter/SKILL.md`
(YAML frontmatter with `name`/`description` + markdown instructions — the
[Agent Skills](https://agentskills.io) open format).

## Steps

1. **Determine your skill directory.** Use the first row that matches the platform you are running on:

   | Platform | Skill directory |
   |---|---|
   | Claude Code | `~/.claude/skills/` (user-wide) or `<project>/.claude/skills/` (project-only) |
   | Codex CLI | `~/.agents/skills/` (user-wide) or `<repo>/.agents/skills/` (repo-only) |
   | Hermes Agent | `~/.hermes/skills/` (or run `hermes skills install <raw SKILL.md URL>` and stop here) |
   | Magi Agent | `~/.magi/skills/` (also reads `~/.claude/skills/`) |
   | Other / unknown | `~/.agents/skills/` (cross-agent standard) |

2. **Create the skill folder and fetch the file:**

   ```bash
   mkdir -p <SKILL_DIR>/korean-legal-doc-drafter
   curl -fsSL https://raw.githubusercontent.com/openmagi/korean-legal-doc-drafter/main/skills/korean-legal-doc-drafter/SKILL.md \
     -o <SKILL_DIR>/korean-legal-doc-drafter/SKILL.md
   ```

   If you already have a local clone of this repo, copy `skills/korean-legal-doc-drafter/SKILL.md` instead of downloading.

3. **Verify:** the installed file must start with YAML frontmatter containing
   `name: korean-legal-doc-drafter`. If your platform has a skill list command
   (`/skills`, `magi skills list`, etc.), confirm the skill appears.

4. **Report to the user:** where you installed it, and that it can be invoked
   with `/korean-legal-doc-drafter` (or by simply asking for a Korean legal
   document, e.g. "내용증명 써줘").

## Notes for the installing agent

- The skill is **self-contained**. It mentions two optional companion skills
  (`korean-law-research`, `hwpx-canine`) — do NOT try to install them; the
  skill degrades gracefully without them.
- Do not modify the SKILL.md content during installation.
- If multiple agent directories exist on this machine and the user said
  "install it everywhere", run `./install.sh` from the repo root instead —
  it detects and installs into all of them.
