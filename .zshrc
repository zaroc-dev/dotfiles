[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh


setopt AUTO_CD              # Ordnername tippen genügt zum Wechseln
setopt CORRECT
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z1-2}={A-Z1-2}'

if command -v zoxide >/dev/null; then
  alias cd='z'
  alias cl='zi'
fi

if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first'
  alias la='eza -a --icons'
  alias lla='eza -la --icons'
  alias tree='eza --tree --icons'
fi

if command -v bat >/dev/null; then
  alias cat='bat'
elif command -v batcat >/dev/null; then
  alias cat='batcat'
fi

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

command -v fastfetch >/dev/null && fastfetch
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Syntax highlighting must be sourced after all widgets and bindings.
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
