source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh


setopt AUTO_CD              # Ordnername tippen genügt zum Wechseln
setopt CORRECT
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z1-2}={A-Z1-2}'

alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -a --icons'
alias lla='eza -la --icons'
alias tree='eza --tree --icons'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gpl='git pull'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gss='git stash show -p'

alias dc='docker compose'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dl='docker logs -f'
alias dps='docker ps'

alias zconf='nvim ~/dotfiles/.zshrc'
alias hyprconf='nvim ~/dotfiles/.config/hypr/'
alias niriconf='nvim ~/dotfiles/.config/niri/'
alias zsrc='source ~/.zshrc'

fastfetch
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# bun completions
[ -s "/home/ruzbyte/.bun/_bun" ] && source "/home/ruzbyte/.bun/_bun"

export PATH="$HOME/.local/bin:$PATH"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
