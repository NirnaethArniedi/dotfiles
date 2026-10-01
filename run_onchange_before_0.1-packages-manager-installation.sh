#!/bin/bash
set -euo pipefail

# Each chezmoi script runs in a fresh non-interactive shell, so the user-level
# install dirs are not on PATH yet: add them before any `command -v` check.
BIN_DIR="$HOME/.local/bin"
FNM_DIR="$HOME/.local/share/fnm"
export PATH="$BIN_DIR:$HOME/.cargo/bin:$FNM_DIR:$PATH"
mkdir -p "$BIN_DIR"

case "$(uname -m)" in
  x86_64) ARCH=x86_64 GOARCH=amd64 ;;
  aarch64 | arm64) ARCH=arm64 GOARCH=arm64 ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

# Latest release version of a GitHub repo, without the leading "v"
latest_version() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": *"v?\K[^"]*'
}

# Extract a single binary from a remote .tar.gz into $BIN_DIR
install_from_tarball() {
  local url=$1 binary=$2 tmp
  tmp=$(mktemp -d)
  curl -fsSL "$url" | tar -xz -C "$tmp" "$binary"
  install -m 0755 "$tmp/$binary" "$BIN_DIR/$binary"
  rm -rf "$tmp"
}

# rustup (no PATH edit: .zshrc sources ~/.cargo/env)
if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# uv (no PATH edit: ~/.local/bin is already in .zshrc)
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi

# fnm + Node LTS (Copilot and Mason's npm-based tools need a recent Node).
# The first installed version becomes fnm's default; an existing default is left alone.
if ! command -v fnm >/dev/null 2>&1; then
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$FNM_DIR" --skip-shell
fi
fnm install --lts

# zoxide
if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# fzf (`fzf --zsh` needs >= 0.48)
if ! command -v fzf >/dev/null 2>&1; then
  version=$(latest_version junegunn/fzf)
  install_from_tarball "https://github.com/junegunn/fzf/releases/download/v${version}/fzf-${version}-linux_${GOARCH}.tar.gz" fzf
fi

# sesh for tmux session management
if ! command -v sesh >/dev/null 2>&1; then
  install_from_tarball "https://github.com/joshmedeski/sesh/releases/latest/download/sesh_Linux_${ARCH}.tar.gz" sesh
fi

# lazygit
if ! command -v lazygit >/dev/null 2>&1; then
  version=$(latest_version jesseduffield/lazygit)
  install_from_tarball "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_linux_${ARCH}.tar.gz" lazygit
fi
