# Repo-aware tmux session bootstrap

*2026-05-28T17:39:45Z by Showboat 0.6.1*
<!-- showboat-id: 193b28d5-d21f-4b72-adaf-ddf49b8db000 -->

Diagnosed the sesh failure against the live tmux server. The hook was already loaded, but it pointed at ~/.config/tmux/repo-bootstrap-session.sh, which had never been applied from chezmoi. There was a second bug too: chezmoi installs that helper as mode 0644, so invoking it directly would fail even after apply. The fix was to run it via bash from the hook, apply the managed files to the home directory, reload tmux, and stop using the vp alias for the editor bootstrap command because login non-interactive shells do not expand aliases from .zshrc.

```bash
git diff -- dot_tmux.conf
```

```output
diff --git a/dot_tmux.conf b/dot_tmux.conf
index 33597a1..a89dc3d 100644
--- a/dot_tmux.conf
+++ b/dot_tmux.conf
@@ -49,9 +49,9 @@ set  -g detach-on-destroy off  # Don't detach when closing a session with multip
 # Repo session bootstrap — editor + agent windows for git repos only
 # ============================================================================
 set  -g @repo-bootstrap-enabled        "on"
-set  -g @repo-bootstrap-editor-command "vp"
+set  -g @repo-bootstrap-editor-command "nvim ."
 set  -g @repo-bootstrap-agent-command  "omp"
-set-hook -g after-new-session "run-shell -b '$HOME/.config/tmux/repo-bootstrap-session.sh #{q:session_id} #{q:session_path}'"
+set-hook -g after-new-session "run-shell -b 'bash \"$HOME/.config/tmux/repo-bootstrap-session.sh\" #{q:session_id} #{q:session_path}'"
 
 # ============================================================================
 # Window titles
```

```bash
set -e
stat -c "%a %n" /home/alenormand/.config/tmux/repo-bootstrap-session.sh
printf "hook=%s\neditor=%s\nagent=%s\n" "$(tmux show-hooks -g after-new-session | tr "\n" " ")" "$(tmux show-options -gqv @repo-bootstrap-editor-command)" "$(tmux show-options -gqv @repo-bootstrap-agent-command)"
SOCK="sesh_doc_$$"
tmux -L "$SOCK" -f /home/alenormand/.tmux.conf new-session -d -s control -c "$HOME"
script -qfc "tmux -L $SOCK attach -t control" /dev/null >/dev/null 2>&1 &
sleep 1
tmux -L "$SOCK" send-keys -t control:1.1 'sesh connect /home/alenormand/repos/battsignal' C-m
sleep 3
EDITOR_PANE_PID=$(tmux -L "$SOCK" display-message -p -t battsignal:1.1 '#{pane_pid}')
AGENT_PANE_PID=$(tmux -L "$SOCK" display-message -p -t battsignal:2.1 '#{pane_pid}')
printf "sessions\n"
tmux -L "$SOCK" list-sessions -F '#{session_name}:#{session_windows}:#{session_path}'
printf -- "---\nwindows\n"
tmux -L "$SOCK" list-windows -a -F '#S:#I:#W:#{pane_current_path}'
printf -- "---\neditor_children=%s\n" "$(ps -o comm= --ppid "$EDITOR_PANE_PID" | paste -sd, -)"
printf "agent_children=%s\n" "$(ps -o comm= --ppid "$AGENT_PANE_PID" | paste -sd, -)"
tmux -L "$SOCK" kill-server || true
```

```output
644 /home/alenormand/.config/tmux/repo-bootstrap-session.sh
hook=after-new-session[0] run-shell -b "bash \"/home/alenormand/.config/tmux/repo-bootstrap-session.sh\" #{q:session_id} #{q:session_path}" 
editor=nvim .
agent=omp
sessions
battsignal:2:/home/alenormand/repos/battsignal
control:1:/home/alenormand
---
windows
battsignal:1:editor:/home/alenormand/repos/battsignal
battsignal:2:agent:/home/alenormand/repos/battsignal
control:1:zsh:/home/alenormand
---
editor_children=nvim
agent_children=bun
```
