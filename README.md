# README

See <https://www.chezmoi.io/quick-start> for informations about chezmoi.

## TL;DR

- Run `cd ~ && sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply --ssh $GITHUB_USERNAME`
  to install chezmoi, copy dotfiless and install all required tools and packages.
- Restart your shell and enjoy.

## Next steps

- Install MesloLGSNerdFontMono fonts and setup your terminal to use them
  [https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip]
- To be able to update chezmoi dotfiles from this new computer and share
  the config to all your machine you need to be able to contribute to the remote
  repository.
  - Set up github identification and auth
    - git config --global {user.email, user.name}
    - Generate ssh key (ssh-keygen -t RSA -C "$github_email" -f "$github_username")
    - Add key to ssh agent (ssh-add $key_file)
    - Copy public key to github account
  - Edit your .ssh/.config to specify your preferred authentification method
    (by publickey). See example here : [https://gist.github.com/rbialek/1012262]

## Full description

### What's included ?

- Default shell configuration using zsh and tmux
  - oh-my-zsh plugin manager with some sensible plugins added
    for syntax highlighting and completion
  - powerlevel10k customized prompt (run `p10k configure` if you want to
    change the proposed config)
  - powerline status bar for tmux and dracula color theme
- NeoVim configuration using LazyVim as the base + a few personal preferences
  (dracula color theme, some key bindings, some extra plugins for markdown and
  Python)
- Some usefull CLI tools :
  - uv as a pip/pipx full replacement (python development)
  - autojump for fast cd
  - btop as a cool replacement for top or htop

### How does it works ?

- dotfiles repo includes all config files for mentionned tools (zsh, tmux, nvim)
  in the `dot_` prefixed files and folders
- Also included a bash script (`run_once_befor_init-install.sh`) which perform
  all the initial installation and setup required for the tools to work. This
  is expected to work on Ubuntu as it relies on apt to install a bunch of
  packages.

  Zsh and tmux plugins are mainly cloned directly from github.

  Nvim/Lazyvim setup need several other utilities, installed from various
  package manager (cargo, npm, luarocks, uv). With everything installed, running
  healthchecks in Nvim (`:LazyHealth`) should only show warnings for optional
  dependencies.

- The bash script requires sudo access to install the packages. It is run once,
  when the first chezmoi sync is performed.
- Afterward if you only edit the dotfiles you can edit them directly in the
  `~/.local/bin/chezmoi` folder, and then run `chezmoi apply` to apply them.
  Use git for syncing your local folder with remote repository. (for more info
  look at chezmoi docs [https://www.chezmoi.io/quick-start/])
