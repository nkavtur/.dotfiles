#!/usr/bin/env bash
# Rex app settings (sidebar, theme, fonts, ...) live in the macOS defaults domain
# com.superlogical.rex, not in a config file. This script saves and restores the ones in
# scripts/rex-settings.conf (key|type|value).
#
#   scripts/rex-settings.sh apply     write the saved settings (quit Rex first, then reopen it)
#   scripts/rex-settings.sh export    print this Mac's current settings in the conf format
#   scripts/rex-settings.sh show      print the saved settings
#
# Deliberately NOT included: Remote Control (a security choice, turn it on by hand if you want it),
# window positions, the focused session, and update-check bookkeeping.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$HERE/rex-settings.conf"
DOMAIN="${REX_DEFAULTS_DOMAIN:-com.superlogical.rex}"     # override only for testing

cmd="${1:-}"
case "$cmd" in
  show)
    grep -v '^#' "$CONF"
    ;;
  export)
    echo "# Rex app settings (macOS defaults domain $DOMAIN): key|type|value"
    echo "# Regenerate from this Mac with: scripts/rex-settings.sh export > scripts/rex-settings.conf"
    defaults read "$DOMAIN" 2>/dev/null | grep -E '^    "?Workspace\.[A-Za-z]+"? = ' \
      | sed -E 's/^    "?([^" ]+)"? = .*/\1/' | grep -v -E 'lastFocusedSession|programActivitySeen' | sort \
      | while read -r k; do
          t="$(defaults read-type "$DOMAIN" "$k" 2>/dev/null | sed 's/Type is //')"
          echo "$k|$t|$(defaults read "$DOMAIN" "$k")"
        done
    ;;
  apply)
    if [ "$DOMAIN" = "com.superlogical.rex" ] && pgrep -f "Rex Beta.app/Contents/MacOS" >/dev/null 2>&1; then
      echo "Rex is running: quit it first (it would overwrite these settings on exit), then run this again." >&2
      exit 1
    fi
    n=0
    while IFS='|' read -r key type value; do
      case "$key" in ''|'#'*) continue ;; esac
      case "$type" in
        boolean) v=$([ "$value" = "1" ] && echo true || echo false); defaults write "$DOMAIN" "$key" -bool "$v" ;;
        integer) defaults write "$DOMAIN" "$key" -int "$value" ;;
        float)   defaults write "$DOMAIN" "$key" -float "$value" ;;
        string)  defaults write "$DOMAIN" "$key" -string "$value" ;;
        *) echo "skipping $key: unknown type $type" >&2; continue ;;
      esac
      n=$((n + 1))
    done < "$CONF"
    echo "applied $n settings to $DOMAIN. Open Rex."
    echo "Note: the terminal font in the settings needs to be installed (brew install --cask font-jetbrains-mono)."
    ;;
  *)
    sed -n '2,10p' "$0"; exit 2
    ;;
esac
