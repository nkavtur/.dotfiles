source ~/.antidote/antidote.zsh

autoload -Uz compinit
compinit

# load antidote plugins
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# enable starship promt (`brew install starship` first) :
# eval "$(starship init zsh)"

# lazy loading for nvm
zstyle ':omz:plugins:nvm' lazy yes

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nikolaikavtur/.sdkman"
[[ -s "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh"

# enable fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# aliases
alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"
alias code="open -a Visual\ Studio\ Code.app"
alias k="kubectl"

# Source kubectl completion script
source <(kubectl completion zsh)
