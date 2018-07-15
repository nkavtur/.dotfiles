set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}


" Set compatibility to Vim only.
set nocompatible

" Turn on syntax highlighting.
syntax on

" Display options
set showmode
set showcmd


" Speed up scrolling in Vim
set ttyfast

" Status bar
set laststatus=2

" Show line numbers
set number

if filereadable(expand("~/.vimrc.plug"))
    source ~/.vimrc.plug
endif
