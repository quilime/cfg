HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt correct extendedglob nocaseglob rcexpandparam nocheckjobs
setopt numericglobsort nobeep appendhistory histignorealldups autocd prompt_subst
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks extended_history

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43'

# Add Homebrew completion definitions without launching Homebrew at shell startup.
if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
elif [[ -d /usr/local/share/zsh/site-functions ]]; then
    FPATH="/usr/local/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit
# Rebuild the completion cache only when it is more than 24 hours old.
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:messages' format '[%d]'
zstyle ':completion:*:warnings' format '[no matches]'
zstyle ':completion:*' verbose yes use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
setopt complete_in_word auto_menu

# dotifles config
alias cfg='git --git-dir="$HOME/.cfg" --work-tree="$HOME"'

# git prompt info
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=(precmd_vcs_info)
zstyle ':vcs_info:git:*' formats '%b'
PROMPT='%F{cyan}%n@%m%f %F{240}%1~%f %F{cyan}❯%f '
RPROMPT='%F{green}${vcs_info_msg_0_} %F{240}%*%f'

# emacs-style command-line editing.
bindkey -e
# treat /, &, ., and ; as word boundaries when editing.
WORDCHARS=${WORDCHARS//\/[&.;]}

# cd-smart
export CDS_DB="$HOME/.local/state/cd-smart.tsv"
source "$HOME/.zsh/cd-smart.zsh"

alias grep='grep --color'

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Load fzf integration only when fzf is installed.
if command -v fzf >/dev/null 2>&1; then
    export FZF_CTRL_R_OPTS="--height=~15 --layout=reverse --no-info --no-separator --no-scrollbar --prompt='history › ' --scheme=history --with-nth 2.."
    source <(fzf --zsh)
fi
