# Changelog

All notable changes to Logan's Revenge are recorded here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Changed
- `install.sh` honors `$CODEX_HOME` for the Codex prompts dir (falls back to `~/.codex`).

### Docs
- README: badges, dual-platform Use section with a Codex slash-command example
  and a trimmed sample two-tier report; clarified Codex invocation.

## [1.1] - 2026-08-20

### Changed
- Renamed the agent to `logans-revenge` so it is invoked by that name in the
  client (Claude subagent name and Codex `/logans-revenge` prompt). File moved
  to `.claude/agents/logans-revenge.md`.

## [1.0] - 2026-08-20

### Added
- `logans-revenge` agent: read-only, eight-lens legacy diagnostician
  producing a two-tier diagnosis + least-effort stabilization plan.
- Stack adapters: Java/Spring/Hibernate-JPA/Angular, Next.js/TypeScript/Postgres/Drizzle,
  and a generic fallback.
- `install.sh` for one-command install into Claude Code and/or Codex CLI.
- `AGENTS.md` contributor guidance.
