#!/usr/bin/env bash
set -euo pipefail

session_id=${1:?tmux session id is required}
session_path=${2:?tmux session path is required}

is_enabled() {
  case "${1:-on}" in
    1|on|true|yes)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_shell_command() {
  case "${1:-}" in
    sh|ash|bash|dash|fish|ksh|mksh|nu|zsh)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

wrap_in_login_shell() {
  local command=$1
  local login_shell=$2
  local quoted_shell
  local wrapped_command

  printf -v quoted_shell '%q' "$login_shell"
  printf -v wrapped_command '%q -lc %q' "$login_shell" "$command; exec $quoted_shell -l"
  printf '%s\n' "$wrapped_command"
}

enabled=$(tmux show-option -gvq @repo-bootstrap-enabled)
editor_command=$(tmux show-option -gvq @repo-bootstrap-editor-command)
agent_command=$(tmux show-option -gvq @repo-bootstrap-agent-command)
shell_path=$(tmux show-option -gv default-shell)
session_windows=$(tmux display-message -p -t "$session_id" "#{session_windows}")
window_panes=$(tmux display-message -p -t "${session_id}:1" "#{window_panes}")
pane_command=$(tmux display-message -p -t "${session_id}:1.1" "#{pane_current_command}")

: "${enabled:=on}"
: "${editor_command:=nvim}"
: "${agent_command:=opencode}"
: "${shell_path:=${SHELL:-/bin/sh}}"

if ! is_enabled "$enabled"; then
  exit 0
fi

if [ ! -e "$session_path/.git" ]; then
  exit 0
fi

if [ "$session_windows" != "1" ] || [ "$window_panes" != "1" ]; then
  exit 0
fi

if ! is_shell_command "$pane_command"; then
  exit 0
fi

wrapped_editor_command=$(wrap_in_login_shell "$editor_command" "$shell_path")
wrapped_agent_command=$(wrap_in_login_shell "$agent_command" "$shell_path")

tmux rename-window -t "${session_id}:1" editor
tmux respawn-pane -k -t "${session_id}:1.1" -c "$session_path" "$wrapped_editor_command"
tmux new-window -d -t "$session_id" -n agent -c "$session_path" "$wrapped_agent_command"
