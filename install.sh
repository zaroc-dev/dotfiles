#!/bin/bash
set -e

if [[ "$PWD" != "$HOME/dotfiles" ]]; then
    echo "Error: Please run this script from $HOME/dotfiles"
    exit 1
fi

BASE_PACKAGES="stow niri xwayland-satellite wl-clipboard grim slurp cliphist"

TERMINAL_PACKAGES="kitty zsh eza fzf fd starship zoxide fastfetch"

AUR_PACKAGES="visual-studio-code-bin ttf-jetbrains-mono-nerd"

echo "Updating system packages..."
sudo pacman -Syu

echo "Installing base packages..."
sudo pacman -S --needed $BASE_PACKAGES

echo "Setting up yay AUR helper..."
~/scripts/install-yay.sh
echo "Installing terminal packages..."
yay -S --needed $TERMINAL_PACKAGES
echo "Installing AUR packages..."
yay -S --needed $AUR_PACKAGES

echo "All packages installed successfully"

stow .
echo "Dotfiles stowed successfully"
