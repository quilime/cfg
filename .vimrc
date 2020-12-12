filetype plugin indent on

" syntax highlighting
syntax on
set encoding=utf-8
" don't beep
set noerrorbells
" visual bell
"set visualbell 
"setup default tab/shift/expand
set tabstop=4 shiftwidth=4 expandtab 
" Highlight current line
"set cursorline
" hightlight search and incremental seach
set hlsearch incsearch
" global replace by default
set gdefault
" not wrap lines
set nowrap
" show line numbers ( ':set nu!' to toggle )
" set nu
" enable mouse in all modes
set mouse=a
" show cursor position
set ruler
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Show “invisible” characters
" set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" set list

" draw vertical column at 80
"  set colorcolumn=80 
" show hidden files in nerdtree

" use ctrl +jkhl to navigate panes
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif


" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
map <F8> :Vex<CR>
" auto open netrw
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END
