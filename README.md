# README

See <https://www.chezmoi.io/quick-start> for information about chezmoi.

## TL;DR

- Run `cd ~ && sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply --ssh $GITHUB_USERNAME`
  to install chezmoi, copy the dotfiles and install all required tools and packages.
- Restart your shell and enjoy.

## Next steps

- Install the MesloLGS Nerd Font Mono fonts and set up your terminal to use them
  [https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip]
- To be able to update the dotfiles from this new computer and share
  the config with all your machines, you need to be able to push to the remote
  repository.
  - Set up GitHub identification and authentication
    - `git config --global user.email ...` and `git config --global user.name ...`
    - Generate an SSH key: `ssh-keygen -t ed25519 -C "$github_email"`
    - Add it to the SSH agent: `ssh-add ~/.ssh/id_ed25519`
    - Copy the public key to your GitHub account
  - Edit `~/.ssh/config` to specify your preferred authentication method
    (publickey). See an example here: [https://gist.github.com/rbialek/1012262]

## Full description

### What's included?

- Shell configuration using zsh and tmux
  - oh-my-zsh with a few plugins for syntax highlighting, autosuggestions and
    completion
  - powerlevel10k prompt (run `p10k configure` to change the proposed config)
  - tmux with TPM (plugins are installed automatically on first launch), the
    Dracula status bar theme and a sesh + fzf session picker on `Alt+n`
  - new tmux sessions opened in a git repo get an `editor` and an `agent` window
    (see `~/.config/tmux/repo-bootstrap-session.sh`)
- Neovim configuration using LazyVim as the base + a few personal preferences
  (Dracula colour theme, Copilot + CopilotChat, neogen with numpydoc docstrings,
  extras for Python, Markdown, Docker, JSON, TOML and TypeScript)
- Some useful CLI tools:
  - uv as a full pip/pipx replacement (Python development)
  - fnm to manage Node.js (the latest LTS is installed by default)
  - zoxide for fast directory jumping, configured with `j` and without the `z` shortcut
  - sesh for tmux session management
  - fzf for fuzzy finding
  - lazygit as a git TUI
  - ripgrep and fd for fast recursive search
  - btop as a nicer replacement for top or htop

### How does it work?

- The repo includes the config files for the tools above (zsh, tmux, nvim, ...)
  in the `dot_` prefixed files and folders.
- chezmoi `run_` scripts perform the installation and setup required for the
  tools to work. They expect Ubuntu, as they rely on apt for the system packages:
  - `run_onchange_before_0-apt-install.sh`: system packages (needs sudo)
  - `run_onchange_before_0.1-packages-manager-installation.sh`: user-level tools
    (rustup, uv, fnm + Node LTS, zoxide) and GitHub release binaries
    (fzf, sesh, lazygit) installed into `~/.local/bin`
  - `run_onchange_before_1.3-zsh-setup.sh`: oh-my-zsh, its plugins and the
    powerlevel10k theme, and zsh as the default shell
  - `run_after_terminate-sudo-creds.sh`: drops the cached sudo credentials

  `run_onchange_` scripts run on the first `chezmoi apply` and again whenever
  their content changes.

  Neovim plugins are installed by lazy.nvim on first launch, and LSP servers,
  formatters and linters by mason.nvim. Lua/LuaRocks are not installed system-wide:
  lazy.nvim builds its own via hererocks when a plugin needs a rock. Once everything
  is installed, `:LazyHealth` should only show warnings for optional dependencies.

- Afterwards, edit the dotfiles in the chezmoi source directory
  (`chezmoi cd`, i.e. `~/.local/share/chezmoi`) and run `chezmoi apply` to apply
  them. Use git to sync that folder with the remote repository (for more info
  see the chezmoi docs [https://www.chezmoi.io/quick-start/]).
