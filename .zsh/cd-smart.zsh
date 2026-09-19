# cd-smart.zsh
#
# A small, self-contained Zsh "smart cd" layer.
#
# Normal:
#   cd /Users/gabrieldunne/Code
#   cd ~/Downloads
#   cd ../foo
#
# Smart:
#   cd ph          -> best learned directory matching "ph"
#   cd pro notes   -> words must appear in order: .../Projects/notes
#   cd ph<TAB>     -> best learned matches
#   cdi ph         -> pick from matches in fzf
#
# Learning happens automatically after successful directory changes.

[[ -o interactive ]] || return 0

zmodload zsh/datetime
zmodload zsh/files

: ${CDS_DB:="${${(%):-%x}:A:h}/cd-smart.tsv"}
: ${CDS_MAXAGE:=1000}
: ${CDS_ALIAS_FILE:="${CDS_DB:h}/cd-smart.aliases"}

(( ${+CDS_ALIASES} )) || typeset -gA CDS_ALIASES
typeset -gA _cds_zshrc_aliases=("${(@kv)CDS_ALIASES}")

_cds_load_aliases() {
    local name target
    [[ -r "$CDS_ALIAS_FILE" ]] || return 0
    while IFS=$'\t' read -r name target; do
        [[ -n "$name" && -n "$target" ]] || continue
        (( ${+_cds_zshrc_aliases[$name]} )) || CDS_ALIASES[$name]="$target"
    done < "$CDS_ALIAS_FILE"
}
_cds_load_aliases

_cds_valid_alias_name() {
    [[ -n "$1" && "$1" != -* && "$1" != */* && "$1" != .* && "$1" != '~'* && "$1" != *[[:space:]]* ]]
}

if (( ! ${+CDS_ROOTS} )); then
    typeset -ga CDS_ROOTS=("$HOME")
    [[ -d /zpool ]] && CDS_ROOTS+=("/zpool")
fi
CDS_ROOTS=("${(@)CDS_ROOTS%/}")

_cds_init() {
    [[ -d "${CDS_DB:h}" ]] || zf_mkdir -p -- "${CDS_DB:h}" 2>/dev/null
    [[ -f "$CDS_DB" ]] || : >| "$CDS_DB" 2>/dev/null
}

_cds_save() {
    local tmp="${CDS_DB}.tmp.$$" line dir sc
    local -F total=0 factor score
    local -a lines=("${(@)@:#}") scores

    scores=("${(@)lines%%$'\t'*}")
    for sc in "${scores[@]}"; do (( total += ${sc:-0} )); done

    if (( total > CDS_MAXAGE )); then
        (( factor = 0.9 * CDS_MAXAGE / total ))
        {
            for line in "${lines[@]}"; do
                dir="${line##*$'\t'}"
                [[ -n "$dir" && -d "$dir" ]] || continue
                (( score = ${${line%%$'\t'*}:-0} * factor ))
                (( score >= 1 )) || continue
                printf '%.2f\t%s\n' "$score" "${line#*$'\t'}"
            done
        } >| "$tmp" 2>/dev/null || { zf_rm -f -- "$tmp"; return 1 }
    else
        { (( ${#lines} == 0 )) || print -rl -- "${lines[@]}" } >| "$tmp" 2>/dev/null ||
            { zf_rm -f -- "$tmp"; return 1 }
    fi

    zf_mv -f -- "$tmp" "$CDS_DB" 2>/dev/null || { zf_rm -f -- "$tmp"; return 1 }
}

_cds_allowed() {
    local p="$1" root
    for root in "${CDS_ROOTS[@]}"; do
        [[ "$p" == "$root" || "$p" == "$root"/* ]] && return 0
    done
    return 1
}

_cds_record() {
    local p="${1:-$PWD}" i pat
    local -F score
    local -a lines

    _cds_allowed "$p" || return 0
    _cds_init || return 0
    lines=("${(@f)$(<"$CDS_DB")}")
    lines=("${(@)lines:#}")
    pat="*"$'\t'"${(b)p}"
    i=${lines[(i)$pat]}
    if (( i <= ${#lines} )); then
        (( score = ${${lines[i]%%$'\t'*}:-0} + 1 ))
        lines[i]="$(printf '%.2f' "$score")"$'\t'"$EPOCHSECONDS"$'\t'"$p"
    else
        lines+=("1.00"$'\t'"$EPOCHSECONDS"$'\t'"$p")
    fi
    _cds_save "${lines[@]}"
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _cds_record

_cds_matches() {
    setopt localoptions extendedglob
    local now stored last dir base age recency pat w line key
    local -F score
    local -a words=("${(@L)@}") lines ranked
    local q="${words[-1]}"

    pat='(#i)*'
    for w in "${words[@]}"; do pat+="${(b)w}*"; done

    _cds_init || return 0
    now=$EPOCHSECONDS
    lines=("${(@f)$(<"$CDS_DB")}")
    lines=("${(@M)lines:#${~pat}}")

    for line in "${lines[@]}"; do
        stored="${line%%$'\t'*}"
        dir="${line##*$'\t'}"
        last="${${line#*$'\t'}%%$'\t'*}"
        [[ -n "$dir" && -d "$dir" ]] || continue
        base="${dir:t:l}"
        score=${stored:-0}

        if [[ -n "$q" && "$base" == "$q" ]]; then
            (( score += 100 ))
        elif [[ -n "$q" && "$base" == "$q"* ]]; then
            (( score += 50 ))
        fi

        age=$(( now - ${last:-now} ))
        if (( age < 3600 )); then recency=20
        elif (( age < 86400 )); then recency=15
        elif (( age < 604800 )); then recency=10
        elif (( age < 2592000 )); then recency=5
        else recency=0
        fi

        (( score += recency ))
        printf -v key '%012.2f' "$score"
        ranked+=("$key"$'\t'"$dir")
    done

    (( ${#ranked} )) && print -rl -- "${(@)${(@O)ranked}#*$'\t'}"
}

_cds_simple_words() {
    local w
    (( $# )) || return 1
    for w in "$@"; do
        [[ "$w" == -* || "$w" == */* || "$w" == .* || "$w" == '~'* ]] && return 1
    done
    return 0
}

cd() {
    local -a matches
    (( $# == 0 )) && { builtin cd; return; }

    if (( $# > 1 )) && [[ "${@[-1]}" == /* && -d "${@[-1]}" ]]; then
        builtin cd -- "${@[-1]}"
        return
    fi

    if ! _cds_simple_words "$@"; then
        builtin cd "$@"
        return
    fi

    if (( $# == 1 )) && [[ -d "$1" ]]; then
        builtin cd -- "$1"
        return
    fi

    if (( $# == 1 && ${+CDS_ALIASES[$1]} )); then
        local target="${CDS_ALIASES[$1]}"
        [[ -d "$target" ]] || { print -u2 "cd-smart: alias $1 -> $target: not a directory"; return 1; }
        builtin cd -- "$target"
        return
    fi

    if (( $# == 2 )) && builtin cd "$@" 2>/dev/null; then
        return
    fi

    matches=(${(f)"$(_cds_matches "$@")"})
    if (( ${#matches} )); then
        builtin cd -- "${matches[1]}"
        return
    fi

    if (( $# > 1 )); then
        print -u2 "cd-smart: no learned match for ${(q)*}"
        return 1
    fi
    builtin cd "$@"
}

_cds_cd_complete() {
    (( $+functions[_cd] )) && _cd "$@"
    local -a query learned
    query=("${(@)words[2,CURRENT]}")
    _cds_simple_words "${query[@]}" || return 0

    if (( CURRENT == 2 && ${#CDS_ALIASES} )); then
        local name
        local -a names descs
        for name in "${(@ko)CDS_ALIASES}"; do
            names+=("$name")
            descs+=("$name -- ${CDS_ALIASES[$name]/#$HOME/~}")
        done
        compadd -J shortcuts -X 'shortcuts' -d descs -- "${names[@]}"
    fi

    learned=(${(f)"$(_cds_matches "${query[@]}")"})
    (( ${#learned} )) || return 0
    compadd -U -Q -J learned -X 'learned directories' -- "${learned[@]}"
}

compdef _cds_cd_complete cd 2>/dev/null

cdi() {
    local q="$*" choice
    local -a paths
    paths=(${(f)"$(_cds_matches "$@")"})
    if (( ! ${#paths[@]} )); then
        print -u2 "cd-smart: no learned match for ${(q)q}"
        return 1
    fi

    if (( $+commands[fzf] )); then
        choice="$(print -rl -- "${paths[@]}" | fzf --height=~40% --layout=reverse --no-sort --select-1 --exit-0 --prompt='cd › ' --query="$q" --preview='CLICOLOR_FORCE=1 ls -1G {}' --preview-window=right:50%:hidden --bind=ctrl-/:toggle-preview)" || return 1
    elif (( ${#paths[@]} == 1 )); then
        choice="${paths[1]}"
    else
        print
        select choice in "${paths[@]}" "cancel"; do
            [[ "$choice" == cancel || -z "$choice" ]] && return 1
            break
        done
    fi

    [[ -n "$choice" ]] && builtin cd -- "$choice"
}

cdlearn() {
    local p
    (( $# == 1 )) || { print -u2 "usage: cdlearn PATH"; return 2; }
    p="${1:A}"
    [[ -d "$p" ]] || { print -u2 "cd-smart: not a directory: $1"; return 1; }
    _cds_allowed "$p" || { print -u2 "cd-smart: outside CDS_ROOTS, not learned: $p"; return 1; }
    _cds_record "$p"
}

cdforget() {
    local target="${1:A}" score last dir
    local -a lines
    (( $# == 1 )) || { print -u2 "usage: cdforget PATH"; return 2; }
    _cds_init || return 1
    while IFS=$'\t' read -r score last dir; do
        [[ -n "$dir" && "$dir" != "$target" ]] || continue
        lines+=("$score"$'\t'"$last"$'\t'"$dir")
    done < "$CDS_DB"
    _cds_save "${lines[@]}"
}

cdlist() {
    local score last dir
    _cds_init || return 1
    while IFS=$'\t' read -r score last dir; do
        [[ -n "$dir" ]] && printf '%9.2f  %s\n' "$score" "$dir"
    done < "$CDS_DB" | sort -rn
}

_cds_save_aliases() {
    local name tmp="${CDS_ALIAS_FILE}.tmp.$$"
    {
        for name in "${(@ko)CDS_ALIASES}"; do
            (( ${+_cds_zshrc_aliases[$name]} )) && continue
            print -r -- "$name"$'\t'"${CDS_ALIASES[$name]}"
        done
    } >| "$tmp" 2>/dev/null || { zf_rm -f -- "$tmp"; return 1; }
    zf_mv -f -- "$tmp" "$CDS_ALIAS_FILE" 2>/dev/null || { zf_rm -f -- "$tmp"; return 1; }
}

cdalias() {
    local name="$1" target="${2:-$PWD}"
    if (( $# == 0 )); then
        for name in "${(@ko)CDS_ALIASES}"; do
            printf '%-12s %s\n' "$name" "${CDS_ALIASES[$name]/#$HOME/~}"
        done
        return 0
    fi
    (( $# <= 2 )) || { print -u2 "usage: cdalias [NAME [PATH]]"; return 2; }
    _cds_valid_alias_name "$name" || { print -u2 "cd-smart: invalid alias name: ${(q)name}"; return 2; }
    target="${target:A}"
    [[ -d "$target" ]] || { print -u2 "cd-smart: not a directory: $2"; return 1; }
    (( ${+_cds_zshrc_aliases[$name]} )) && { print -u2 "cd-smart: $name is defined in your zshrc; edit it there"; return 1; }
    CDS_ALIASES[$name]="$target"
    _cds_save_aliases
}

cdunalias() {
    local name="$1"
    (( $# == 1 )) || { print -u2 "usage: cdunalias NAME"; return 2; }
    (( ${+CDS_ALIASES[$name]} )) || { print -u2 "cd-smart: no such alias: $name"; return 1; }
    (( ${+_cds_zshrc_aliases[$name]} )) && { print -u2 "cd-smart: $name is defined in your zshrc; remove it there"; return 1; }
    unset "CDS_ALIASES[$name]"
    _cds_save_aliases
}

cdsmart-help() {
    print 'cd-smart: cd learns visited directories; cdi searches them with fzf.'
    print 'Commands: cdlearn PATH, cdforget PATH, cdlist, cdalias [NAME [PATH]], cdunalias NAME'
}
