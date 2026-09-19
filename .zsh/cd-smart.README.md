# cd-smart

A `cd` that learns where you go. About 250 lines of zsh, one plain-text
database, no external processes on the `cd` path, and no dependencies beyond
zsh itself (fzf is used by `cdi` when present).

## Install

```zsh
# ~/.zshrc, after compinit
source ~/.zsh/cd-smart.zsh
```

Files live next to the script: `cd-smart.tsv` (learned directories) and
`cd-smart.aliases` (shortcuts defined at the prompt).

## Use

```zsh
cd ~/Projects/notes   # ordinary cd; the directory is learned
cd agents                       # jump to the best learned match for "agents"
cd open ag                      # words must appear in order: .../Projects/notes
cd ag<TAB>                      # normal completion plus learned matches and shortcuts
cdi ag                          # pick from matches in fzf; ctrl-/ toggles a preview
cdi                             # browse everything learned
```

Precedence inside the wrapper, first match wins:

1. No argument, or anything with options, slashes, or a leading `.` or `~`,
   goes straight to the builtin. `cd ..`, `cd -`, `cd ~/x` are untouched.
2. A single word that exists as a directory here.
3. A single word that is a shortcut.
4. Two words that work as the builtin's `cd old new` substitution.
5. The best-scored learned directory containing the words in order.
6. The builtin's normal error.

### Shortcuts

```zsh
cdalias osa ~/Projects/notes   # "cd osa" always goes there
cdalias dl                               # current directory becomes "dl"
cdalias                                  # list
cdunalias dl                             # remove
```

Shortcuts can also be declared in `.zshrc` before sourcing, and those win over
saved ones:

```zsh
typeset -gA CDS_ALIASES=(osa ~/Projects/notes)
```

### Maintenance

```zsh
cdlearn PATH     # learn a directory without visiting it
cdforget PATH    # remove one
cdlist           # learned directories with scores
cdsmart-help     # short reminder of all of this
```

### Configuration

Set before sourcing.

| variable      | default                      | meaning                                   |
|---------------|------------------------------|-------------------------------------------|
| `CDS_DB`      | `cd-smart.tsv` beside script | learned-directory database                |
| `CDS_ROOTS`   | `$HOME` (and `/zpool` if present) | only directories under these are learned |
| `CDS_MAXAGE`  | `1000`                       | aging threshold, see below                |
| `CDS_ALIASES` | empty                        | shortcuts declared in `.zshrc`            |

## How ranking works

Each learned directory has a score and a last-visit time. A visit adds 1 to
the score. At lookup time a candidate's rank is its score plus a bonus for an
exact basename match (+100) or basename prefix (+50) on the last query word,
plus a recency bonus (20 within an hour, 15 within a day, 10 within a week,
5 within a month).

Growth is bounded by aging. When the sum of all scores exceeds `CDS_MAXAGE`,
every score is multiplied by `0.9 × CDS_MAXAGE / total`, entries that fall
below 1 are dropped, and directories that no longer exist are pruned. Places
you keep returning to stay; one-off visits fade out.

## Tests

```zsh
zsh ~/.zsh/cd-smart.test.zsh
```

Runs in a throwaway sandbox and never touches your real database.

## Compared with zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide) solves the same problem and
is the obvious alternative. The ranking model here is deliberately close to
its design. The differences are mostly about scope.

| | cd-smart | zoxide |
|---|---|---|
| Implementation | ~250 lines of zsh, one file | ~2,000 lines of Rust plus a shell template per shell |
| Shells | zsh only | bash, zsh, fish, nushell, PowerShell, and others |
| Database | plain TSV you can read and edit | binary, with file locking |
| Command | wraps `cd` itself | separate `z` and `zi`; `--cmd cd` can replace `cd` |
| Real directories vs. guesses | an existing local directory always wins, then shortcuts, then learned matches | with `--cmd cd`, an existing path also wins; otherwise `z` always guesses |
| Tab completion | learned matches and shortcuts appear inside normal `cd <TAB>` | completion on the `z` command only |
| Shortcuts | built in (`cdalias`) | none; use shell aliases |
| Where learning happens | only under `CDS_ROOTS` | everywhere, minus `_ZO_EXCLUDE_DIRS` |
| Multi-word queries | words in order anywhere in the path; last word gets basename bonuses | words in order; last word must match the last path component |
| Recency | additive bonus by age bucket | multiplier by age bucket (4×, 2×, 0.5×, 0.25×) |
| Aging | same scheme: scale by 0.9 × cap / total, drop below 1, prune dead paths | same, default cap 10,000 |
| Concurrency | last writer wins if two shells `cd` at the same instant | locked writes |
| External processes | none on `cd` or lookup | one binary launch per `cd` and per query |
| Speed at 300 entries (typical after aging) | ~3.5 ms per `cd`, ~1 ms per lookup | a few ms, dominated by the launch |
| Speed at 2,000 entries | ~17 ms per `cd`, ~7 ms per lookup | a few ms |
| Tests | 45 smoke tests in one script | full Rust test suite |

In short: zoxide is safer under concurrent shells and portable, and stays
fast at any database size.
cd-smart is smaller, fully inspectable, restricted to the directories you
care about, and integrates with `cd` and its completion rather than adding a
second command. In practice aging keeps the database in the low hundreds of
entries, where neither tool is perceptibly slower than a plain `cd`.
