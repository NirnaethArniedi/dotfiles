#!/bin/bash
sudo -v || exit

# rustup
if ! command -v rustup 2>&1 >/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# uv
if ! command -v uv 2>&1 >/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# luarocks
# check if luarocks already installed
if ! command -v luarocks 2>&1 >/dev/null; then
  cd $HOME
  wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
  tar zxpf luarocks-3.11.1.tar.gz
  cd luarocks-3.11.1
  ./configure && make && sudo make install
  cd $HOME
  rm -rf $HOME/luarocks-3.11.1 $HOME/luarocks-3.11.1.tar.gz
fi

# install fzf latest version from sources
if ! command -v fzf 2>&1 >/dev/null; then
  cd $HOME
  go install github.com/junegunn/fzf@latest
fi
