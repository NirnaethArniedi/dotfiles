# README

See <https://www.chezmoi.io/quick-start> for informations about chezmoi.

## TLDR

- Set up github identification and auth
  - git config --global {user.email, user.name}
  - Generate ssh key (ssh-keygen -t RSA -C "$github_email" -f "$github_username")
  - Add key to ssh agent (ssh-add $key_file)
  - Copy public key to github account
- Run `sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply $GITHUB_USERNAME`
  to install chezmoi and copy dotfiles. (space between -- and init is
  intentionnal !)

## Next steps

- Run the init_install.sh (`cd ~ && ./init_install.sh`) script once to install
  all necessary packages and plugins
- Install MesloLGSNerdFontMono fonts and setup your terminal to use them
  [https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip]
