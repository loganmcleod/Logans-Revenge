#!/usr/bin/env bash
# Install Logan's Revenge (logans-revenge) for Claude Code and/or Codex CLI.
# The Claude agent file is the single source of truth; the Codex prompt is derived
# from it by stripping the YAML frontmatter (Codex has no tool-restricted subagents).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/.claude/agents/logans-revenge.md"
NAME="logans-revenge"

usage() {
  cat <<EOF
Install Logan's Revenge (the $NAME agent).

Usage: ./install.sh <target> [dir]

Targets:
  claude [dir]   Copy the subagent into a Claude Code agents dir.
                 No dir  -> ~/.claude/agents (available in every project).
                 dir     -> <dir>/.claude/agents (per-project install).
  codex          Strip frontmatter and install as a Codex CLI prompt at
                 ~/.codex/prompts/$NAME.md (invoke in Codex with /$NAME).
  both           Claude (global) + Codex.
  check          Verify the frontmatter-strip produces a valid Codex body.

Examples:
  ./install.sh claude                 # global Claude install
  ./install.sh claude ~/work/legacy   # per-project install
  ./install.sh codex
  ./install.sh both
EOF
}

# Emit the agent body with the leading YAML frontmatter block removed.
strip_frontmatter() {
  awk 'NR==1 && $0=="---"{f=1;next} f && $0=="---"{f=0;next} !f' "$SRC"
}

install_claude() {
  local dir
  if [ -n "${1:-}" ]; then dir="$1/.claude/agents"; else dir="$HOME/.claude/agents"; fi
  mkdir -p "$dir"
  cp "$SRC" "$dir/$NAME.md"
  echo "Claude: installed to $dir/$NAME.md"
}

install_codex() {
  local dir="${CODEX_HOME:-$HOME/.codex}/prompts"
  mkdir -p "$dir"
  strip_frontmatter > "$dir/$NAME.md"
  echo "Codex:  installed to $dir/$NAME.md (invoke with /$NAME)"
}

run_check() {
  local out; out="$(strip_frontmatter)"
  [ "$(printf '%s\n' "$out" | head -1)" != "---" ] || { echo "FAIL: frontmatter not stripped" >&2; exit 1; }
  printf '%s' "$out" | grep -q "# Role and Core Objective" || { echo "FAIL: agent body missing" >&2; exit 1; }
  echo "check: frontmatter strip OK"
}

[ -f "$SRC" ] || { echo "Source agent not found: $SRC" >&2; exit 1; }

case "${1:-}" in
  claude)      install_claude "${2:-}";;
  codex)       install_codex;;
  both)        install_claude; install_codex;;
  check)       run_check;;
  ""|-h|--help) usage;;
  *)           echo "Unknown target: $1" >&2; usage; exit 1;;
esac
