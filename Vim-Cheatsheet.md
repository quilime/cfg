# Vim Cheatsheet

After using Emacs exclusively for years as my main editor, I was interested in
learning Vim, at least enough to have parity with what I was familiar with in
Emacs. Things like buffers/tabs, selecting blocks of text, copying and pasting,
loading files, and project trees were all something I was familiar how to do in
Emacs but I was completely lost in Vim.

I have used many Vim cheatsheets to learn, and found it helpful to create my
own. If you create your own cheatsheat, use Vim to create it.

## Config

  - For Vim: `~/.vimrc.`

Disable cursor keys. (They will still work in Insert mode)

```
" remove cursor keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
```


## Insert Mode

  - `i` - `i`nsert content before selected char
  - `a` - Insert content `a`fter select char
  - `A` - Insert content `A`fter last char on line
  - `o` - `o`pen new line below current
  - `O` - `O`pen new line above current
  - `esc`, `ctrl-c` - Exit Insert mode


## Visual Mode

  - `v` - Enter `v`isual mode
  - `d` - `d`elete. Like "ctrl-x - cut", puts text in clipboard
  - `y` - `y`ank. Like "ctrl-c - copy", puts text in clipbaord
  - `c` - `c`hange. Deletes (cuts) and enter Insert mode immediately

## Normal Mode Commands

  - `dd` - `dd`elete line (places line in clipboard)

### Files

  - `:e` or `:edit` - Edit (open) new file in current buffer
  - `:Vex` - Open `V`ertical file `ex`plorer
  - `:Hex` - Open `H`orizontal file `ex`plorer

### Tabs

  - `:tabnew` or `:tabe` - Open a new tab.
  - `:tabclose` or `:tabc` - Close the current tab.
  - `:tabonly` or `:tabo` - Close every other tab except the current one.
  - `gt` - `g`o `t`o next tab
  - `gT` - `g`o `T`o previous tab


## References

Vim cheatsheet references

  - [Vim for Beginners](https://thevaluable.dev/vim-for-beginners/)
  - [Vim for Intermediate Users](https://thevaluable.dev/vim-intermediate/)

## Vim & Neovim

  - [Neovim](https://neovim.io/)
  - Neovim Config: ~/.config/nvim/init.vim or ~/nvim/init.vim (depending on
the value of the environment variable $XDG_CONFIG_HOME).
