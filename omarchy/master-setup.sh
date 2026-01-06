#!/bin/sh

echo "Removing unneccesary apps..."
. ./remove/master-remove.sh
echo "Done."

echo "Installing apps..."
. ./install/master-install.sh
echo "Done."

echo "Installing dotfiles..."
. ./install-dotfiles.sh
echo "Done."

echo "Set theme to Catppuccin"
omarchy-theme-set Catppuccin