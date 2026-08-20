# AGENTS.md

Guidance for AI coding agents (Codex CLI, and others that read `AGENTS.md`) working in this repo.

## What this repo is

Logan's Revenge is a **single portable agent definition** — a read-only diagnostician for legacy codebases. It ships one canonical file and derives platform-specific installs from it:

- **Source of truth:** `.claude/agents/logans-revenge.md` (frontmatter + body).
- **Codex prompt:** the same file with its YAML frontmatter stripped (`install.sh` writes it to `${CODEX_HOME:-~/.codex}/prompts/logans-revenge.md`, invoked as `/logans-revenge`). Codex has no tool-restricted subagents, so read-only is enforced by the instruction text in the body, not by tooling.

## Rules for editing

- Edit the agent's behavior **only** in `.claude/agents/logans-revenge.md`. Never hand-edit an installed copy under `~/.claude` or `~/.codex`.
- Keep the "You never edit code" / read-only contract intact — it is the whole safety model on Codex.
- After changing the agent body, run `./install.sh check`.
- New stack support = a documentation edit to the "Adapter cues" appendix in the agent file, not new code.

## Layout

```
.claude/agents/logans-revenge.md   canonical agent (Claude subagent)
install.sh                                        installs to Claude and/or Codex
README.md                                         user-facing docs
CHANGELOG.md                                       version history
```
