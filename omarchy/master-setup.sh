#!/bin/sh

echo "Installing apps..."
. ./app-installation.sh
echo "Done."
echo "Installing dotfiles..."
. ./install-dotfiles.sh
echo "Done."

echo "Set theme to Catppuccin"
omarchy-theme-set Catppuccin