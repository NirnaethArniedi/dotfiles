# Dotfiles review cleanup

*2026-10-01T08:23:19Z by Showboat 0.6.1*
<!-- showboat-id: 2574c718-f7b1-44b2-8864-0440000f1edb -->

Second review pass: removed duplicate and broken config, fixed fresh-machine installs, and made the stale-file cleanup automatic on existing machines.

- Install scripts: user-level bin dirs are put on PATH inside each script; rustup runs non-interactively; Node comes from fnm (LTS); fzf, sesh and lazygit come from GitHub release binaries (apt's golang/fzf are too old); Lua/LuaRocks are left to lazy.nvim's hererocks (forced with rocks.hererocks = true); unused packages dropped (fish, golang, nodejs/npm, lua5.1*, libreadline-dev, python3-neovim, powerline-status, corepack, global npm packages, cargo stylua, which Mason already installs). The LazyVim starter clone is gone.
- Neovim: autosave on BufLeave/FocusLost instead of every edit (each write runs format-on-save); hand-written Copilot spec replaced by the ai.copilot and ai.copilot-chat extras; aider and dead specs removed; extras all live in lazyvim.json (python moved there, coding.neogen added); neogen uses numpydoc; unused language providers are disabled.
- Shell/tmux: no hardcoded home paths; zsh-interactive-cd dropped; zsh-syntax-highlighting loads last; cargo env guarded; tmux-sensible duplicates removed; clip.exe only on WSL; Alt+n no longer calls sesh with an empty name; the TPM first-launch bootstrap now actually installs plugins.
- .chezmoiremove deletes the target copies of removed plugin specs.

Checked in a sandbox: headless Neovim 0.12 synced and loaded the config (numpydoc template, copilot through blink, no toggleterm/aider/blink-cmp-copilot); tmux 3.4 installed TPM plugins on first launch; chezmoi 2.73 applied the old state and then the new one, and removed the stale specs. Not checkable here: the GitHub API and fnm installer calls (blocked by the sandbox proxy).

```bash
ls dot_config/nvim/lua/plugins && grep -n 'extras\.' dot_config/nvim/lazyvim.json
```

```output
cmp_tab.lua
colorscheme.lua
neo-tree.lua
neogen.lua
3:    "lazyvim.plugins.extras.ai.copilot",
4:    "lazyvim.plugins.extras.ai.copilot-chat",
5:    "lazyvim.plugins.extras.coding.neogen",
6:    "lazyvim.plugins.extras.editor.fzf",
7:    "lazyvim.plugins.extras.editor.outline",
8:    "lazyvim.plugins.extras.formatting.prettier",
9:    "lazyvim.plugins.extras.lang.docker",
10:    "lazyvim.plugins.extras.lang.json",
11:    "lazyvim.plugins.extras.lang.markdown",
12:    "lazyvim.plugins.extras.lang.python",
13:    "lazyvim.plugins.extras.lang.toml",
14:    "lazyvim.plugins.extras.lang.typescript",
15:    "lazyvim.plugins.extras.ui.edgy",
16:    "lazyvim.plugins.extras.util.chezmoi"
```

```bash
zsh -n dot_zshrc && bash -n run_*.sh && uvx --from shellcheck-py shellcheck run_onchange_before_0-apt-install.sh run_onchange_before_0.1-packages-manager-installation.sh run_after_terminate-sudo-creds.sh && echo 'syntax + shellcheck OK'
```

```output
syntax + shellcheck OK
```

```bash
cat .chezmoiremove
```

```output
# Targets whose source files were deleted from this repo: chezmoi does not
# remove them on its own, and stale Neovim plugin specs would keep loading.
.config/nvim/lua/plugins/toggleterm.lua
.config/nvim/lua/plugins/copilot.lua
.config/nvim/lua/plugins/aider.lua
.config/nvim/lua/plugins/lsp_config.lua
.config/nvim/lua/plugins/masonlsp.lua
.config/nvim/lua/plugins/example.lua
```
