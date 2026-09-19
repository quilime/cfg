# Shared entry point
source "$HOME/.zsh/common.zsh"

if [[ "$OSTYPE" == darwin* ]]; then
    [[ -r "$HOME/.zsh/macos.zsh" ]] && source "$HOME/.zsh/macos.zsh"
elif [[ "$OSTYPE" == linux* ]]; then
    [[ -r "$HOME/.zsh/linux.zsh" ]] && source "$HOME/.zsh/linux.zsh"
fi

# Optional machine- or work-specific settings.
[[ -r "$HOME/.zsh/local.zsh" ]] && source "$HOME/.zsh/local.zsh"
