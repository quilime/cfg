# platform entry
if [[ "$OSTYPE" == darwin* ]]; then
    [[ -r "$HOME/.zsh/macos.zsh" ]] && source "$HOME/.zsh/macos.zsh"
elif [[ "$OSTYPE" == linux* ]]; then
    [[ -r "$HOME/.zsh/linux.zsh" ]] && source "$HOME/.zsh/linux.zsh"
else
    # use shared config for unrecognized platform
    source "$HOME/.zsh/common.zsh"
fi

# optional local settings
[[ -r "$HOME/.zsh/local.zsh" ]] && source "$HOME/.zsh/local.zsh"
