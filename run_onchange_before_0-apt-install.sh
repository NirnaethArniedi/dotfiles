#!/bin/bash

sudo -v || exit

sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update

sudo apt full-upgrade -y

# Not from apt on purpose:
# - Node.js: fnm (apt's nodejs is too old for Copilot)
# - Lua/LuaRocks: lazy.nvim builds its own via hererocks (needs python3 + build-essential)
# - fzf, sesh, lazygit: GitHub release binaries (apt's fzf/golang are too old)
sudo apt install -y \
  git \
  curl \
  python3-full \
  build-essential \
  neovim \
  ripgrep \
  fd-find \
  unzip \
  zsh \
  tmux \
  btop \
  ncal \
  tree
