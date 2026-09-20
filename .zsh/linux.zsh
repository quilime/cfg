# Linux-specific Zsh settings

alias ls='ls --color=auto'

# shared settings initialize completion before plugins load.
source "$HOME/.zsh/common.zsh"

if command -v fzf-tab >/dev/null 2>&1; then
    source "$(dirname "$(command -v fzf-tab)")/../share/fzf-tab/fzf-tab.zsh" 2>/dev/null
fi

[[ -r "$HOME/.zsh/fzf-tab.zsh" ]] && source "$HOME/.zsh/fzf-tab.zsh"

for plugin in \
    "$HOME/.local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    "$HOME/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    [[ -r "$plugin" ]] && source "$plugin"
done
