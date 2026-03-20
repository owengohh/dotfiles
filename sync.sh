#!/bin/bash

# Symlink dotfiles to their correct positions
# Run from the dotfiles directory

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Backup existing file/directory and create symlink
symlink() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        local current_target
        current_target=$(readlink "$dest")
        if [ "$current_target" = "$src" ]; then
            log_info "Already linked: $dest"
            return 0
        else
            log_warn "Removing existing symlink: $dest"
            rm "$dest"
        fi
    elif [ -e "$dest" ]; then
        log_warn "Backing up existing: $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -s "$src" "$dest"
    log_info "Linked: $dest -> $src"
}

# Symlink configs to ~/.config
link_configs() {
    for dir in "$CONFIG_DIR"/*/; do
        local name
        name=$(basename "$dir")

        # Skip zshrc - it's handled separately
        if [ "$name" = "zshrc" ]; then
            continue
        fi

        # starship.toml goes directly in .config, not in a subdirectory
        if [ "$name" = "starship" ]; then
            symlink "$dir/starship.toml" "$HOME/.config/starship.toml"
            continue
        fi

        symlink "$dir" "$HOME/.config/$name"
    done
}

# Symlink .zshrc to home directory
link_zshrc() {
    symlink "$CONFIG_DIR/zshrc/.zshrc" "$HOME/.zshrc"
}

main() {
    log_info "Dotfiles directory: $DOTFILES_DIR"
    log_info "Linking config files..."

    # Ensure ~/.config exists
    mkdir -p "$HOME/.config"

    link_configs
    link_zshrc

    log_info "Done!"
}

main "$@"
