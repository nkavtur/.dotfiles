# source antidote
source ~/.antidote/antidote.zsh

# install plugins
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# lazy loading for nvm
zstyle ':omz:plugins:nvm' lazy yes

# Dependencies
[ -f ~/.sdkman ] && source "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source kubectl completion script
command -v kubectl &> /dev/null && source <(kubectl completion zsh) || echo 'error'

# alises
alias -g pretty="| pino-pretty"
alias code="open -a Visual\ Studio\ Code.app"
alias webstorm="open -a /Applications/Webstorm.app"
alias k="kubectl"
alias v="vivaldi"