# Dotfiles

This repository contains my personal dotfiles. Feel free to reuse them.

Dotfiles are managed with `stow`. To set them up, run the following from the `.dotfiles` root directory:

```sh
stow <module>
```

Where `<module>` is a folder name in this repo (e.g., `zsh`, `ghostty`, etc.).  
`stow` will create the necessary symlinks in the appropriate locations.

### Zsh Setup

Zsh configurations are included in this repository. Plugins are managed with `antidote`, so install it first:

```sh
brew install antidote
```
