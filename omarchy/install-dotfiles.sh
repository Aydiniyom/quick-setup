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

BAK_DIR="$ORIGINAL_DIR/bak"

is_stow_installed() {
    pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
    echo "Install stow first."
    exit 1
fi

if [ -d "$BAK_DIR" ]; then
    echo "Removing previous backups at: $BAK_DIR"
    rm -rf $BAK_DIR

    echo "Reinitializing the backup directory"
    mkdir $BAK_DIR
else
    echo "Creating the backup directory at: $BAK_DIR"
    mkdir $BAK_DIR
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
            echo "Backing up '$path' to '$BAK_DIR'"
            cp "$path" "$BAK_DIR"

            echo "Removing: $path"
            rm -f "$path"
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

echo "Checkout the '$BAK_DIR' directory if anything went wrong."