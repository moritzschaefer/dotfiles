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

"search replace
nnoremap <Leader>sc :,$s/\<<C-r><C-w>\>//gc\|1,''-&&<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap <Leader>sg :,$s/\<<C-r><C-w>\>//g\|1,''-&&<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

"Latex 
let g:tex_flavor='latex'

autocmd BufNewFile  *.tex	0r ~/.vim/templates/template.tex

"Latex compiling
"inoremap <LEADER>ll <ESC>:w<CR>:!latex %<CR>i
"inoremap <LEADER>lv <ESC>:w<CR>:!evince %:r.dvi > /dev/null 2> /dev/null &<CR>i
inoremap <LEADER>ll <ESC>:w<CR>:!pdflatex %<CR>i
inoremap <LEADER>lv <ESC>:w<CR>:!evince %:r.pdf > /dev/null 2> /dev/null &<CR>i
"nmap <LEADER>ll <ESC>:w<CR>:!latex %<CR>
"nmap <LEADER>lv <ESC>:w<CR>:!evince %:r.dvi > /dev/null 2> /dev/null &<CR>
nnoremap <LEADER>ll <ESC>:w<CR>:!pdflatex %<CR>
nnoremap <LEADER>lv <ESC>:w<CR>:!evince %:r.pdf > /dev/null 2> /dev/null &<CR>
