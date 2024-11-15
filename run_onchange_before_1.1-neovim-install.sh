#!/bin/bash

# requires uv, npm, luarocks & rustup to be installed

sudo -v || exit
## various dependencies
uv tool install hererocks
cargo install stylua
sudo npm install -g neovim corepack prettier
sudo luarocks install jsregexp

## lazygit
if ! command -v lazygit 2>&1 >/dev/null; then
  cd $HOME
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
fi

## lazyvim
LAZYVIM_CONFIG_FOLDER=$HOME/.config/nvim
if [ ! -d "$LAZYVIM_CONFIG_FOLDER" ]; then
  git clone https://github.com/LazyVim/starter "$LAZYVIM_CONFIG_FOLDER"
fi

# housecleaning
rm -rf $HOME/lazygit
rm -rf $HOME/.config/nvim/.git
