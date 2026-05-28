# Repo-aware tmux session bootstrap

*2026-05-28T14:35:00Z by Showboat 0.6.1*
<!-- showboat-id: 26c8cc59-a22f-4e2a-ba4a-0464d278eb8c -->

Added an after-new-session tmux hook that bootstraps repo-root sessions with an editor window and an agent window. The helper script only triggers when the session path itself has a .git entry and leaves sessions with explicit startup commands untouched.

```bash
git diff -- dot_tmux.conf dot_config/tmux/repo-bootstrap-session.sh
```

```output
diff --git a/dot_tmux.conf b/dot_tmux.conf
index 5f86893..de75d1e 100644
--- a/dot_tmux.conf
+++ b/dot_tmux.conf
@@ -44,6 +44,14 @@ setw -g pane-base-index  1     # Panes start at 1, not 0
 set  -g status-interval  5     # Status bar refresh interval (seconds)
 set  -g mouse            on
 setw -g monitor-activity on
+set  -g detach-on-destroy off  # Don't detach when closing a session with multiple windows/panes
+# ============================================================================
+# Repo session bootstrap — editor + agent windows for git repos only
+# ============================================================================
+set  -g @repo-bootstrap-enabled        "on"
+set  -g @repo-bootstrap-editor-command "nvim"
+set  -g @repo-bootstrap-agent-command  "opencode"
+set-hook -g after-new-session "run-shell -b '$HOME/.config/tmux/repo-bootstrap-session.sh #{q:session_id} #{q:session_path}'"
 
 # ============================================================================
 # Window titles
```

```bash
set -e
bash -n dot_config/tmux/repo-bootstrap-session.sh
ROOT=$(mktemp -d)
REPO_DIR="$ROOT/repo"
NON_REPO_DIR="$ROOT/plain"
mkdir -p "$REPO_DIR" "$NON_REPO_DIR"
git -C "$REPO_DIR" init -q
CONFIG=$(mktemp)
cat > "$CONFIG" <<"EOF"
set -g base-index 1
setw -g pane-base-index 1
set -g @repo-bootstrap-enabled "on"
set -g @repo-bootstrap-editor-command "printf editor-ready; sleep 1000"
set -g @repo-bootstrap-agent-command "printf agent-ready; sleep 1000"
set-hook -g after-new-session "run-shell -b '/home/alenormand/.local/share/chezmoi/dot_config/tmux/repo-bootstrap-session.sh #{q:session_id} #{q:session_path}'"
EOF
SOCK=repo_bootstrap_showboat
tmux -L "$SOCK" -f "$CONFIG" new-session -d -s repo -c "$REPO_DIR"
sleep 0.5
printf "repo_windows\n%s\n" "$(tmux -L "$SOCK" list-windows -t repo -F '#{window_index}:#{window_name}:#{pane_current_command}')"
printf -- "---\nrepo_editor_pane\n%s\n" "$(tmux -L "$SOCK" capture-pane -p -t repo:1.1)"
printf -- "---\nrepo_agent_pane\n%s\n" "$(tmux -L "$SOCK" capture-pane -p -t repo:2.1)"
tmux -L "$SOCK" new-session -d -s plain -c "$NON_REPO_DIR"
sleep 0.3
printf -- "---\nplain_windows\n%s\n" "$(tmux -L "$SOCK" list-windows -t plain -F '#{window_index}:#{window_name}:#{pane_current_command}')"
tmux -L "$SOCK" new-session -d -s repo_cmd -c "$REPO_DIR" 'sleep 30'
sleep 0.3
printf -- "---\nrepo_cmd_windows\n%s\n" "$(tmux -L "$SOCK" list-windows -t repo_cmd -F '#{window_index}:#{window_name}:#{pane_current_command}')"
tmux -L "$SOCK" kill-server
rm -f "$CONFIG"
rm -rf "$ROOT"
```

```output
repo_windows
1:editor:zsh
2:agent:zsh
---
repo_editor_pane
editor-ready
---
repo_agent_pane
agent-ready
---
plain_windows
1:zsh:zsh
---
repo_cmd_windows
1:sleep:sleep
```
