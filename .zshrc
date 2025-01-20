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

# Dependencies
[ -f ~/.sdkman ] && source "~/.sdkman/bin/sdkman-init.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source kubectl completion script
command -v kubectl &> /dev/null && source <(kubectl completion zsh) || echo 'error'

# alises
alias -g pretty="| pino-pretty"
alias code="open -a Visual\ Studio\ Code.app"
alias webstorm="open -a /Applications/Webstorm.app"
alias k="kubectl"
alias z="zellij"
