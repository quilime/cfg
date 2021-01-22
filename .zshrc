if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ -e ~/.zsh-darwin ]]; then
        source ~/.zsh-darwin
    fi
else
    # Linux or other
    # Source zsh configuration
    if [[ -e ~/.zsh-config ]]; then
        source ~/.zsh-config
    fi
   # Use zsh prompt
    if [[ -e ~/.zsh-prompt ]]; then
        source ~/.zsh-prompt
    fi
fi
