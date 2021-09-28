source $(brew --prefix)/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundle zsh-users/zsh-completions src
antigen bundle git
antigen bundle dnf
antigen bundle docker
antigen bundle command-not-found
antigen bundle djui/alias-tips
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle RobSis/zsh-completion-generator
antigen bundle key-bindings
antigen theme robbyrussell
antigen apply

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nikolaikavtur/.sdkman"
[[ -s "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nikolaikavtur/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nikolaikavtur/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nikolaikavtur/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nikolaikavtur/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nikolaikavtur/google-cloud-sdk/completion.zsh.inc'; fi

source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

alias k=kubectl

complete -F __start_kubectl k
autoload -U +X compinit && compinit
source <(kubectl completion zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
