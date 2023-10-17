eval "$(pyenv init --path)"
source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundle zsh-users/zsh-completions src
antigen bundle git
antigen bundle dnf
antigen bundle docker
antigen bundle aws
antigen bundle command-not-found
antigen bundle djui/alias-tips
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle key-bindings
antigen theme robbyrussell
antigen apply

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nikolaikavtur/.sdkman"
[[ -s "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias docker="/Applications/Docker.app/Contents/Resources/bin/docker"

alias k="kubectl"

autoload -Uz compinit
compinit
source <(kubectl completion zsh)

