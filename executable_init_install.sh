#!/bin/bash

sudo -v || exit

sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update

sudo apt full-upgrade -y

sudo apt install -y \
  python3-full \
  build-essential \
  libreadline-dev \
  cargo \
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
  btop

mkdir $HOME/.ssh

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# neovim
uv tool install hererocks
cargo install stylua
## luarocks
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gtar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install
rm -rf luarocks-3.11.1
##
sudo npm install -g neovim corepack prettier
## lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -f lazygit
##
## lazyvim
git clone https://github.com/LazyVim/starter $HOME/.config/nvim
rm -rf $HOME/.config/nvim/.git
##
#

# zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'eval "$(uv generate-shell-completion zsh)"' >>$HOME/.zshrc
echo 'eval "$(uvx --generate-shell-completion zsh)"' >>$HOME/.zshrc
#

# tmux
uv tool install powerline-status
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
#

sudo -k
