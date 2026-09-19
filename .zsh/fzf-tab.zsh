# fzf-tab: fuzzy tab completion; preview hidden by default, Ctrl-/ toggles it
zstyle ':fzf-tab:*' fzf-flags --height=50% --preview-window=right:55%:wrap:hidden --bind=ctrl-/:toggle-preview
zstyle ':fzf-tab:*' switch-group '<' '>'

# Preview commands run in a separate shell. Quote the fzf-tab variables there,
# rather than expanding them while this configuration is sourced.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'CLICOLOR_FORCE=1 ls -1G -- "$realpath"'
zstyle ':fzf-tab:complete:(cat|bat|less|vim|subl|code|cp|mv|rm|open):*' fzf-preview \
  'if [[ -d "$realpath" ]]; then
     CLICOLOR_FORCE=1 ls -1G -- "$realpath"
   elif grep -qI . -- "$realpath" 2>/dev/null; then
     bat --color=always --style=numbers --line-range=:200 -- "$realpath"
   else
     file -b -- "$realpath"
   fi'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always -- $word | head -200'
zstyle ':fzf-tab:complete:git-(checkout|switch|merge|rebase|log):*' fzf-preview 'git log --oneline --color=always -20 $word 2>/dev/null'
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset):*' fzf-preview 'echo ${(P)word}'
unset _ls

# Complete full Git file paths instead of one directory at a time.
autoload -Uz +X _multi_parts
functions -c _multi_parts _multi_parts_orig
_multi_parts() {
    [[ $curcontext == *:git-* ]] || { _multi_parts_orig "$@"; return; }
    local -a opts
    while [[ $1 != - ]]; do opts+=("$1"); shift; done
    compadd "${opts[@]}" -- "${(@P)3}"
}
