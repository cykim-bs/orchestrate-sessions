#!/usr/bin/env bash
# Install the orchestrate-sessions skill and the model-effort-by-task rule for Claude Code.
#
#   skills/orchestrate-sessions/   -> <base>/skills/orchestrate-sessions/
#   rules/model-effort-by-task.md  -> <base>/rules/model-effort-by-task.md
#
# <base> is ~/.claude (default) or <project>/.claude (--project).
# Existing files are left alone unless --force is given. With --force the old copy is
# moved to <base>/orchestrate-sessions-backup/<timestamp>/ first (outside skills/ and rules/,
# so Claude Code does not load it twice), and an existing local-bindings.md is carried over.
#
# Usage: ./scripts/install.sh [--project DIR] [--force] [--dry-run]
set -euo pipefail

project=""
force=0
dry=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project) project="${2:?--project needs a folder}"; shift 2 ;;
    --force)   force=1; shift ;;
    --dry-run) dry=1; shift ;;
    -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
skill_src="$repo_root/skills/orchestrate-sessions"
rule_src="$repo_root/rules/model-effort-by-task.md"

if [ -n "$project" ]; then
  [ -d "$project" ] || { echo "Project folder not found: $project" >&2; exit 1; }
  base="$(cd "$project" && pwd)/.claude"
else
  base="$HOME/.claude"
fi

skill_dst="$base/skills/orchestrate-sessions"
rule_dst="$base/rules/model-effort-by-task.md"
stamp="$(date +%Y%m%d%H%M%S)"
bak_root="$base/orchestrate-sessions-backup/$stamp"

run() { if [ "$dry" -eq 1 ]; then echo "[dry-run] $*"; else "$@"; fi; }

echo "Install target: $base"

install_item() {
  local src="$1" dst="$2" is_dir="$3" bindings=""
  if [ -e "$dst" ]; then
    if [ "$force" -ne 1 ]; then
      echo "WARNING: already exists, skipped: $dst  (use --force to replace; the old copy is backed up)"
      return
    fi
    local bak="$bak_root/$(basename "$dst")"
    run mkdir -p "$bak_root"
    run mv "$dst" "$bak"
    echo "Backed up: $bak"
    if [ "$is_dir" = 1 ] && [ -f "$bak/references/local-bindings.md" ]; then
      bindings="$bak/references/local-bindings.md"
    fi
  fi
  run mkdir -p "$(dirname "$dst")"
  if [ "$is_dir" = 1 ]; then run cp -R "$src" "$dst"; else run cp "$src" "$dst"; fi
  echo "Installed: $dst"
  if [ -n "$bindings" ]; then
    run cp "$bindings" "$dst/references/local-bindings.md"
    echo "Kept your local-bindings.md"
  fi
}

install_item "$skill_src" "$skill_dst" 1
install_item "$rule_src" "$rule_dst" 0

echo
echo "Done. Start a NEW Claude Code conversation to use it."
echo "Optional: copy references/local-bindings.example.md to references/local-bindings.md and edit it."
