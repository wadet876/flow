#!/usr/bin/env sh
set -eu

PROJECT_PATH="${1:-$(pwd)}"
PROFILE_NAME="kickstart-nvim"

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_linux_deps() {
  if need_cmd apt-get; then
    sudo apt-get update
    sudo apt-get install -y git neovim curl unzip
  elif need_cmd dnf; then
    sudo dnf install -y git neovim curl unzip
  elif need_cmd pacman; then
    sudo pacman -Sy --noconfirm git neovim curl unzip
  else
    echo "Unsupported Linux package manager. Install git neovim curl unzip manually."
    exit 1
  fi
}

install_macos_deps() {
  if ! need_cmd brew; then
    echo "Homebrew is required on macOS. Install Homebrew first."
    exit 1
  fi
  brew install git neovim curl
}

OS_NAME="$(uname -s)"
case "$OS_NAME" in
  Linux)
    if ! need_cmd git || ! need_cmd nvim || ! need_cmd curl || ! need_cmd unzip; then
      install_linux_deps
    fi
    ;;
  Darwin)
    if ! need_cmd git || ! need_cmd nvim || ! need_cmd curl; then
      install_macos_deps
    fi
    ;;
  *)
    echo "Unsupported OS: $OS_NAME"
    exit 1
    ;;
esac

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
PROFILE_DIR="$CONFIG_HOME/$PROFILE_NAME"
SOURCE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/kickstart-source"
TMP_ZIP="/tmp/kickstart.nvim-master.zip"
TMP_DIR="/tmp/kickstart.nvim-master"

rm -rf "$TMP_DIR" "$TMP_ZIP"
mkdir -p "$SOURCE_DIR"

echo "Downloading kickstart.nvim"
curl -fsSL "https://codeload.github.com/nvim-lua/kickstart.nvim/zip/refs/heads/master" -o "$TMP_ZIP"
unzip -q "$TMP_ZIP" -d /tmp

rm -rf "$SOURCE_DIR"
mkdir -p "$SOURCE_DIR"
cp -R "$TMP_DIR"/* "$SOURCE_DIR"/

rm -rf "$PROFILE_DIR"
mkdir -p "$PROFILE_DIR"
for item in "$SOURCE_DIR"/*; do
  name="$(basename "$item")"
  case "$name" in
    .git|.github|.gitignore|LICENSE.md|README.md)
      ;;
    *)
      cp -R "$item" "$PROFILE_DIR"/
      ;;
  esac
done

mkdir -p "$HOME/.local/bin"
LAUNCHER="$HOME/.local/bin/start-kickstart"
cat > "$LAUNCHER" <<EOF
#!/usr/bin/env sh
set -eu
TARGET="\${1:-\$(pwd)}"
export NVIM_APPNAME="$PROFILE_NAME"
cd "\$TARGET"
exec nvim .
EOF
chmod +x "$LAUNCHER"

export NVIM_APPNAME="$PROFILE_NAME"
cd "$PROJECT_PATH"
exec nvim .
