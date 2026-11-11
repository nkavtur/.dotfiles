#!/usr/bin/env bash
# Bootstrap Rex (https://www.superlogical.com/rex) on a new Mac from these dotfiles:
#   - links the `rex` stow module (init.lua + the cmd+e tab picker),
#   - builds and installs the Rust tab-picker UI (falls back to an fzf popup if that fails),
#   - installs the rex-sessionizer plugin at a pinned commit, with the local speed patch applied.
#
# usage: scripts/bootstrap-rex.sh [--dry-run] [--skip-ui] [--no-reload]
# Safe to run again: every step checks whether it is already done, and nothing is deleted
# (an existing ~/.config/rex is moved aside, not removed).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RES_DIR="$HOME/.config/rex"
UI_REPO="nkavtur/rex-tab-picker"                       # private: needs `gh auth login`
SESSIONIZER_REPO="https://github.com/haxybaxy/rex-sessionizer"
SESSIONIZER_PIN="4157a30"                              # the commit that was reviewed
PATCH="$DOTFILES/scripts/patches/rex-sessionizer-fast-find.patch"

DRY=0; SKIP_UI=0; RELOAD=1
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --skip-ui) SKIP_UI=1 ;;
    --no-reload) RELOAD=0 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done

say()  { printf '\033[1m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarning:\033[0m %s\n' "$*" >&2; }
run()  { if [ "$DRY" = 1 ]; then printf '   (dry-run) %s\n' "$*"; else "$@"; fi; }
have() { command -v "$1" >/dev/null 2>&1; }

[ "$(uname -s)" = "Darwin" ] || { echo "this script is for macOS" >&2; exit 1; }

# ---- 1. tools ----------------------------------------------------------------------------------
say "Checking tools"
if ! have brew; then
  warn "Homebrew not found: install it from https://brew.sh, then run this again."; exit 1
fi
for pkg in stow fzf; do
  if have "$pkg"; then echo "   $pkg: ok"; else say "Installing $pkg"; run brew install "$pkg"; fi
done
have rex || warn "the \`rex\` command is not on PATH yet: install Rex first (the config still gets linked)."

# ---- 2. link the rex module --------------------------------------------------------------------
say "Linking the rex config (stow)"
if [ -L "$RES_DIR" ] || { [ -d "$RES_DIR" ] && [ -L "$RES_DIR/init.lua" ]; }; then
  echo "   already linked"
else
  if [ -e "$RES_DIR" ]; then
    BACKUP="$RES_DIR.bak-$(date +%Y%m%d-%H%M%S)"
    echo "   moving the existing $RES_DIR to $BACKUP"
    run mv "$RES_DIR" "$BACKUP"
  fi
  run mkdir -p "$HOME/.config"
  run stow -d "$DOTFILES" -t "$HOME" rex
fi

# ---- 3. the Rust UI for the tab picker ---------------------------------------------------------
if [ "$SKIP_UI" = 1 ]; then
  say "Skipping the Rust UI (--skip-ui): the picker will use its fzf fallback"
elif [ -x "$RES_DIR/bin/rex-tabs" ]; then
  say "Tab picker UI already installed"
else
  say "Building the tab picker UI"
  if ! have cargo; then
    warn "no Rust toolchain (cargo). Install it with: brew install rust   — skipping the UI, the picker will use fzf."
  elif ! have gh || ! gh auth status >/dev/null 2>&1; then
    warn "GitHub CLI is not logged in (the $UI_REPO repo is private). Run: gh auth login — then run this again. Skipping the UI."
  else
    TMP="$(mktemp -d)"
    if run gh repo clone "$UI_REPO" "$TMP/ui" -- --depth 1 >/dev/null 2>&1 \
       && ( [ "$DRY" = 1 ] || (cd "$TMP/ui" && cargo build --release >/dev/null 2>&1) ); then
      run mkdir -p "$RES_DIR/bin"
      run cp "$TMP/ui/target/release/rex-tabs" "$RES_DIR/bin/rex-tabs"
      echo "   installed $RES_DIR/bin/rex-tabs"
    else
      warn "could not build the UI from $UI_REPO — the picker will use its fzf fallback."
    fi
    rm -rf "$TMP"
  fi
fi

# ---- 4. sessionizer, pinned, with the speed patch ----------------------------------------------
say "Installing rex-sessionizer ($SESSIONIZER_PIN)"
SZ="$RES_DIR/rex-sessionizer"
if [ ! -d "$SZ/.git" ]; then
  run git clone -q "$SESSIONIZER_REPO" "$SZ"
  run git -C "$SZ" checkout -q "$SESSIONIZER_PIN"
else
  echo "   already cloned"
fi
if [ "$DRY" = 0 ] && [ -d "$SZ/.git" ]; then
  if git -C "$SZ" apply --reverse --check "$PATCH" >/dev/null 2>&1; then
    echo "   speed patch already applied"
  elif git -C "$SZ" apply --check "$PATCH" >/dev/null 2>&1; then
    git -C "$SZ" apply "$PATCH" && echo "   speed patch applied (opens in ~0.1 s instead of 2-5 s)"
  else
    warn "the speed patch does not apply (upstream changed?): the sessionizer still works, just slower."
  fi
fi

# ---- 5. reload ---------------------------------------------------------------------------------
if [ "$RELOAD" = 1 ] && [ "$DRY" = 0 ] && have rex; then
  say "Checking and reloading the Rex config"
  rex config check >/dev/null 2>&1 && rex config reload >/dev/null 2>&1 && echo "   reloaded" \
    || warn "rex config check/reload failed: open Rex and run \`rex config check\` to see why."
fi

# ---- 6. things a script cannot do --------------------------------------------------------------
cat <<'NOTE'

Done. Still to do by hand:
  * Rex > Settings > Server > Remote Control: turn it on if you want cmd+o (sessionizer) to
    switch sessions. The tab picker (cmd+e) does not need it.
  * Projects folder: the sessionizer lists the folders under ~/workspace (change work_dir in
    ~/.config/rex/init.lua).
  * For Claude Code in Rex: run `rex skill setup` once.
NOTE
