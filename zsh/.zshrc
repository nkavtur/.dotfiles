# source antidote
source ~/.antidote/antidote.zsh

# install plugins
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# lazy loading for nvm
zstyle ':omz:plugins:nvm' lazy yes

# disable Ctrd + d to close terminal window
set -o ignoreeof

# enable zellij completions (https://github.com/zellij-org/zellij/issues/1933)
autoload -U +X compinit && compinit
. <( zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' )

# enable 'pure' prompt (installed from zsh_plugins)
autoload -Uz promptinit && promptinit && prompt pure

# Dependencies
[ -f ~/.sdkman ] && source "~/.sdkman/bin/sdkman-init.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init zsh --cmd cd)"

# diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
git config --global interactive.diffFilter "diff-so-fancy --patch"

# Source kubectl completion script
command -v kubectl &> /dev/null && source <(kubectl completion zsh) || echo 'error'

# alises
alias -g pretty="| pino-pretty"
alias code="open -a Visual\ Studio\ Code.app"
alias ws="open -a /Applications/Webstorm.app"
alias k="kubectl"
alias z="zellij"
alias l="layer0"
alias cat="bat"
alias ls="eza --icons=auto"
alias ping="gping"
unalias gk >/dev/null 2>/dev/null
