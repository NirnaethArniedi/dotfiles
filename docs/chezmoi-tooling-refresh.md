# Chezmoi tooling refresh

*2026-05-21T10:34:02Z by Showboat 0.6.1*
<!-- showboat-id: ebe2f611-7711-461f-89b3-e7116cdd3e10 -->

Updated shell/bootstrap config to replace autojump with zoxide (`j` only), install sesh via Go, and document existing fzf/ripgrep usage.

```bash
git diff -- README.md dot_zshrc run_onchange_before_0-apt-install.sh run_onchange_before_0.1-packages-manager-installation.sh
```

```output
diff --git a/README.md b/README.md
index 03e5b56..6911a0c 100644
--- a/README.md
+++ b/README.md
@@ -38,7 +38,10 @@ See <https://www.chezmoi.io/quick-start> for informations about chezmoi.
   Python)
 - Some usefull CLI tools :
   - uv as a pip/pipx full replacement (python development)
-  - autojump for fast cd
+  - zoxide for fast directory jumping, configured with `j` and without the `z` shortcut
+  - sesh for tmux session management
+  - fzf for fuzzy finding
+  - ripgrep for fast recursive search
   - btop as a cool replacement for top or htop
 
 ### How does it works ?
diff --git a/dot_zshrc b/dot_zshrc
index 0f178a0..b08d5b2 100644
--- a/dot_zshrc
+++ b/dot_zshrc
@@ -89,7 +89,6 @@ ZSH_THEME="powerlevel10k/powerlevel10k"
 plugins=(
   git
   extract
-  autojump
   alias-finder
   common-aliases
   pyautoenv
@@ -130,7 +129,6 @@ fi
 # Example aliases
 # alias zshconfig="mate ~/.zshrc"
 # alias ohmyzsh="mate ~/.oh-my-zsh"
-. /usr/share/autojump/autojump.sh
 alias fd="fdfind"
 alias ipython="uv run ipython"
 alias cal="ncal -Mwb"
diff --git a/run_onchange_before_0-apt-install.sh b/run_onchange_before_0-apt-install.sh
index a2d2d34..091a007 100644
--- a/run_onchange_before_0-apt-install.sh
+++ b/run_onchange_before_0-apt-install.sh
@@ -12,7 +12,7 @@ sudo apt install -y \
   python3-full \
   build-essential \
   libreadline-dev \
-  autojump \
+  zoxide \
   neovim \
   ripgrep \
   fd-find \
diff --git a/run_onchange_before_0.1-packages-manager-installation.sh b/run_onchange_before_0.1-packages-manager-installation.sh
index 056b22c..a180389 100644
--- a/run_onchange_before_0.1-packages-manager-installation.sh
+++ b/run_onchange_before_0.1-packages-manager-installation.sh
@@ -28,3 +28,9 @@ if ! command -v fzf 2>&1 >/dev/null; then
   cd $HOME
   go install github.com/junegunn/fzf@latest
 fi
+
+# install sesh for tmux session management
+if ! command -v sesh 2>&1 >/dev/null; then
+  cd $HOME
+  go install github.com/joshmedeski/sesh@latest
+fi
```
