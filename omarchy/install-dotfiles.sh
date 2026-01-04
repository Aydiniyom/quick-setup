#!/bin/sh

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/Aydiniyom/dotfiles"
REPO_NAME="dotfiles"

PATHS_TO_REMOVE=(
    "$HOME/.config/hypr/bindings.conf" 
    "$HOME/.config/hypr/hyprlock.conf" 
    "$HOME/.config/hypr/input.conf" 
    "$HOME/.config/hypr/looknfeel.conf"
    
)

FOLDERS_TO_REMOVE=(
    "$HOME/.config/omarchy/current/theme/backgrounds"
)

is_stow_installed() {
    pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
    echo "Install stow first."
    exit 1
fi

cd ~

if [ -d "$REPO_NAME" ]; then
    echo "Repository '$REPO_NAME' already exists. Deleting"
    rm -rf "$REPO_NAME"
fi

git clone "$REPO_URL"

if [ $? -eq 0 ]; then
    echo "Removing old configurations..."
    for path in "${PATHS_TO_REMOVE[@]}"; do
        
        [ -z "$path" ] && continue

        if [ -e "$path" ] || [ -L "$path" ]; then
            echo "Removing: $path"
            rm -f "$path"
        else
            echo "Skipping (does not exist): $path"
        fi
    done

    for folder in "${FOLDERS_TO_REMOVE[@]}"; do
        
        [ -z "$path" ] && continue

        if [ -e "$path" ] || [ -L "$path" ]; then
            echo "Removing: $path"
            rm -rf "$path"
        else
            echo "Skipping (does not exist): $path"
        fi
    done

    echo "Old configurations removed successfully."

    cd "$REPO_NAME"

    stow omarchy
    echo "Configuration stowed successfully."

    hyprctl reload
    echo "Reloaded hyprland."
else
    echo "Failed to clone the repository."
    exit 1
fi