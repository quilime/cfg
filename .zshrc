# Each platform configuration loads the shared settings in the required order.
if [[ "$OSTYPE" == darwin* ]]; then
    [[ -r "$HOME/.zsh/macos.zsh" ]] && source "$HOME/.zsh/macos.zsh"
elif [[ "$OSTYPE" == linux* ]]; then
    [[ -r "$HOME/.zsh/linux.zsh" ]] && source "$HOME/.zsh/linux.zsh"
else
    # Use the shared configuration on an unrecognized platform.
    source "$HOME/.zsh/common.zsh"
fi

# Optional machine- or work-specific settings.
[[ -r "$HOME/.zsh/local.zsh" ]] && source "$HOME/.zsh/local.zsh"
