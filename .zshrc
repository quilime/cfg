# Source zsh config
if [[ -e ~/.zsh-config ]]; then
    source ~/.zsh-config
fi

# source .profile if it exists
if [[ -e ~/.profile ]]; then
    source ~/.profile
fi

# source .aliases
if [[ -e ~/.zsh-aliases ]]; then
    source ~/.zsh-aliases
fi

# Use zsh prompt
if [[ -e ~/.zsh-prompt ]]; then
    source ~/.zsh-prompt
fi
