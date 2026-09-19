# macOS-specific Zsh settings

alias ls='ls -G'
alias x86='arch -x86_64 zsh'

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    if [[ -r "$(brew --prefix)/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]]; then
        source "$(brew --prefix)/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
        [[ -r "$HOME/.zsh/fzf-tab.zsh" ]] && source "$HOME/.zsh/fzf-tab.zsh"
    fi
    [[ -r "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -r "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

[[ -r "$HOME/.docker/init-zsh.sh" ]] && source "$HOME/.docker/init-zsh.sh"
