" Remove all autocmds, so they are not loaded twice
if has("autocmd")
  autocmd!
endif
set nocompatible
scriptencoding utf-8

set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

set cursorline
set fo=croq
set mousehide
set background=dark
set number

set ignorecase    " Ignore case when searching
set smartcase     " Except when uppercase is used
set incsearch
set hlsearch
set showcmd
set autoindent

" --- Auto complete options
set wildmode=list:longest,full  " TODO document the awesomeness of this
set wildmenu
set wildignore+=*.o,*.obj,*.pyc,*.pyo,*.pyd,*.class,*.lock
set wildignore+=*.png,*.gif,*.jpg,*.ico
set wildignore+=',.svn,.hg
set showcmd
set mouse=a
set smartcase
set autoread

" Create a tmp folder in the home directory for swap, backup and undo files
if isdirectory($HOME . '/tmp') == 0
  :silent !mkdir -p ~/tmp > /dev/null 2>&1
endif

set backupdir=~/tmp
set backup
set directory=~/tmp
set swapfile
if exists("+undofile")
  set undodir=~/tmp
  set undofile
endif

inoremap nn <Esc>

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
inoremap <LEADER>ll <ESC>:w<CR>:!pdflatex %<CR>i
inoremap <LEADER>lv <ESC>:w<CR>:!evince %:r.pdf > /dev/null 2> /dev/null &<CR>i
nnoremap <LEADER>ll <ESC>:w<CR>:!pdflatex %<CR>
nnoremap <LEADER>lv <ESC>:w<CR>:!evince %:r.pdf > /dev/null 2> /dev/null &<CR>

" pathogen
call pathogen#incubate()
call pathogen#helptags()

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ }
let g:ruby_path =  '/usr/bin/ruby'
