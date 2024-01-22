#!/bin/bash
dotfiles_dir="$HOME/.dotfiles"
green="\033[0;32m"
yellow="\033[0;33m"
reset="\033[0m"

info() {
    echo -e "${yellow}$1${reset}"
}

error() {
    echo -e "${yellow}Error: $1${reset}"
    exit 1
}

user_input() {
    read -p "$1" choice
}

create_symlink() {
    source_file="$dotfiles_dir/$1"
    target_file="${HOME}/test/$1"

    # Backup existing file if it exists
    if [ -e "$target_file" ]; then
        mv "$target_file" "$target_file.backup"
        info "📂 Backup created: $target_file.backup"
    fi

    # Create symlink
    ln -s "$source_file" "$target_file"
    echo
    info "🔗 Symlink created: $source_file -> $target_file"
}

main() {
    echo

    # Ensure dotfiles directory exists
    [ -d "$dotfiles_dir" ] || error "Dotfiles directory not found. Make sure it exists at $dotfiles_dir."

    # List of files to symlink
    files=(".zshrc" ".zprofile" ".zsh_plugins.txt" ".hyper.js")

    # Ask user for confirmation
    info "🚀 This will create symlinks for the following files in your home directory:"
    for file in "${files[@]}"; do
        info "  - $file"
    done

    echo

    user_input "Continue? (y/n): "
    [ "$choice" = "y" ] || { info "🚫 Installation aborted."; exit 0; }

    # Create symlinks
    for file in "${files[@]}"; do
        create_symlink "$file"
    done

    echo
    info "✅ Installation complete. Restart your terminal or reload your shell."
}

# Call the main function
main
