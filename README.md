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

[Rex](https://www.superlogical.com/rex) config lives in the `rex` module: `init.lua` plus the `cmd+e` tab picker. On a new Mac, install Rex and run:

```sh
scripts/bootstrap-rex.sh            # --dry-run to preview, --skip-ui to use the fzf fallback
```

It installs `stow` and `fzf`, links the module (an existing `~/.config/rex` is moved aside, never deleted), builds the picker's Rust UI from the private [rex-tab-picker](https://github.com/nkavtur/rex-tab-picker) repo (needs `gh auth login` and a Rust toolchain, otherwise the picker falls back to fzf), installs [rex-sessionizer](https://github.com/haxybaxy/rex-sessionizer) at a pinned commit with `scripts/patches/rex-sessionizer-fast-find.patch` applied, then reloads the Rex config. Safe to run again.

Still manual: Rex → Settings → Server → Remote Control (only the sessionizer's `cmd+o` needs it), and `rex skill setup` for Claude Code.
