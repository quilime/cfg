# macOS-specific Zsh settings

alias ls='ls -G'
alias x86='arch -x86_64 zsh'

# Homebrew is normally installed under /opt/homebrew on Apple Silicon and
# /usr/local on Intel Macs. Use the known path to avoid repeated `brew --prefix`
# subprocesses while starting a shell.
if [[ -x /opt/homebrew/bin/brew ]]; then
    HOMEBREW_PREFIX=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
    HOMEBREW_PREFIX=/usr/local
fi

if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
    # Add brew's tools and completion definitions without running Homebrew.
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH:+:$MANPATH}"
    export INFOPATH="$HOMEBREW_PREFIX/share/info${INFOPATH:+:$INFOPATH}"
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"
fi

# fnm via brew
if [[ -d "${HOMEBREW_PREFIX:-}/opt/fnm/bin" ]]; then
    eval "$(fnm env --shell zsh)"
fi

# Load shared settings brew's got its completion definitions.
source "$HOME/.zsh/common.zsh"

# load plugins after compinit; syntax highlighting is the final plugin loaded.
if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
    [[ -r "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]] && \
        source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
    [[ -r "$HOME/.zsh/fzf-tab.zsh" ]] && source "$HOME/.zsh/fzf-tab.zsh"
    [[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
