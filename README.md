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

### Rex Setup

[Rex](https://www.superlogical.com/rex) config lives in the `rex` module: `init.lua` plus the `cmd+e` tab picker (`tab_picker.lua`, `tab-picker.sh`, `tab-dump.lua`, `tab-watcher.lua`). The picker's UI is a small Rust program, built from [rex-tab-picker](https://github.com/nkavtur/rex-tab-picker) (private); without it the picker falls back to an fzf popup:

```sh
brew install fzf
mv ~/.config/rex ~/.config/rex.bak   # Rex creates ~/.config/rex itself
stow rex
git clone https://github.com/nkavtur/rex-tab-picker /tmp/rex-tab-picker && (cd /tmp/rex-tab-picker && cargo build --release)
mkdir -p ~/.config/rex/bin && cp /tmp/rex-tab-picker/target/release/rex-tabs ~/.config/rex/bin/
git clone https://github.com/haxybaxy/rex-sessionizer ~/.config/rex/rex-sessionizer   # optional, cmd+o
rex config check && rex config reload
```
