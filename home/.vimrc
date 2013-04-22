set nocompatible

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab


set fo=croq
set mousehide
set background=dark
set number

set incsearch
set hlsearch
set showcmd
set autoindent

set wildmenu

set mouse=a

set smartcase
inoremap jj <Esc>

nnoremap JJJJ <Nop>

syntax on
filetype on 
filetype indent on
filetype plugin on


"autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd BufNewFile,BufRead *html.erb set filetype=html.eruby 
"autocmd BufNewFile,BufRead *html.erb setlocal shiftwidth=2 tabstop=2

"mips techgi2
autocmd BufNewFile,BufRead *.s set filetype=mips

"Opal
autocmd BufNewFile,BufRead *.sign,*.impl  set ft=opal

"Brandpunkt
autocmd BufNewFile,BufRead *.tpl set filetype=html


"Change buffers wihtout save
set hidden
 
" Necessary from latex-suite:
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
