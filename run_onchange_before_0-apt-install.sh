#!/bin/bash

sudo -v || exit

sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update

sudo apt full-upgrade -y

sudo apt install -y \
  python3-full \
  build-essential \
  libreadline-dev \
  autojump \
  neovim \
  ripgrep \
  fzf \
  fd-find \
  unzip \
  nodejs \
  npm \
  lua5.1 \
  liblua5.1-0-dev \
  liblua5.1-0 \
  python3-neovim \
  fish \
  zsh \
  tmux \
  btop \
  tree
