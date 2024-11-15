#!/bin/bash

sudo -v || exit
cd $HOME

# folder required for ssh-agent plugin to work
mkdir $HOME/.ssh

# changing default shell without requesting user
# password (use sudo rights already present)
sudo chsh -s $(which zsh) $(whoami)

# install oh-my-zsh if not already present
OH_MY_ZSH_FILE=$HOME/.oh-my-zsh/oh-my-zsh.sh
if [ -f "$OH_MY_ZSH_FILE" ]; then
  echo "Oh-my-zsh already installed ($OH_MY_ZSH_FILE exist)"
else
  echo "Installing Oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# checking if plugin already are present before cloning
# the repos
## zsh-autosuggestions
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
## zsh-syntax-highlighting
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
## powerlevel10k theme
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# since we managed the dot files by ourselves we
# do not want oh-my-zsh to replace a already existent .zshrc
mv .zshrc.pre-oh-my-zsh .zshrc 2>/dev/null
