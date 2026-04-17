#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
set -euo pipefail
# juno spawn process <entity> ["prompt"]
#
# Interactive:     juno spawn process vulcan
#                  → opens entity in new tmux window (or gnome-terminal)
#
# Non-interactive: juno spawn process vulcan "build the auth module"
#                  → runs entity with prompt, streams output, exits
#
# Stdin/heredoc:   juno spawn process vulcan << 'EOF'
#                  multi-line prompt without quoting issues
#                  EOF

ENTITY_NAME="${1:?Usage: juno spawn process <entity> [prompt]}"
PROMPT="${2:-}"

# Load cascade environment per VESTA-SPEC-005
source "$HOME/.koad-io/.env" 2>/dev/null || true
source "$HOME/.$ENTITY_NAME/.env" 2>/dev/null || { ENTITY_DIR="$HOME/.$ENTITY_NAME"; }

# Accept prompt from stdin if not passed as arg and stdin is a pipe/heredoc
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# Validate
if [ ! -d "$ENTITY_DIR" ]; then
  echo "Entity '$ENTITY_NAME' not found at $ENTITY_DIR"
  echo "Gestate first: koad-io gestate $ENTITY_NAME"
  exit 1
fi

# Non-interactive: prompt provided — run directly, stream output
if [ -n "$PROMPT" ]; then
  exec claude \
    --dangerously-skip-permissions \
    -p "$PROMPT" \
    --add-dir "$ENTITY_DIR"
fi

# Interactive: no prompt — open a live session
SESSION="$ENTITY_NAME"
SPAWN_CMD="cd $ENTITY_DIR && claude . --dangerously-skip-permissions"

if [ -n "${TMUX:-}" ]; then
  # Inside tmux: open new window
  tmux new-window -n "$SESSION" "$SPAWN_CMD"
elif command -v gnome-terminal &>/dev/null; then
  gnome-terminal --title="$ENTITY_NAME" -- bash -c "$SPAWN_CMD; exec bash"
elif command -v xterm &>/dev/null; then
  xterm -title "$ENTITY_NAME" -e bash -c "$SPAWN_CMD; exec bash" &
else
  # Fallback: run in current shell
  exec bash -c "$SPAWN_CMD"
fi
