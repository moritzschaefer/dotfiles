" Remove all autocmds, so they are not loaded twice
if has("autocmd")
  autocmd!
endif
set nocompatible
scriptencoding utf-8

set bs=2
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

inoremap ee <Esc>

" nnoremap JJJJ <Nop>

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

" --- Vundler ----------------------------------------------------------------
" This section should setup VIM with very little interaction, vundle and
" the specified Bundles are installed autmatically

" --- Function to install bundles automagically
function! LoadBundles()
  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
endfunction
" --- Install Vundle and bundles if possible
filetype off                            " required!
if executable("git")
  if !isdirectory(expand("~/.vim/bundle/vundle"))
    echomsg "***************************"
    echomsg "Installing Vundle"
    echomsg "***************************"
    !mkdir -p ~/.vim/bundle && git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let s:bootstrap=1
  endif

  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
  call LoadBundles()

  if exists("s:bootstrap") && s:bootstrap
    unlet s:bootstrap
    BundleInstall
    quit
  endif
endif

filetype plugin indent on               " required!
" --- Helpers ----------------------------------------------------------------
" --- Always jump to last known position if valid
if has ("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g `\"" |
    \ endif
endif

" --- Strip trailing whitespace
function! StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction
if has("autocmd")
  autocmd BufWritePre *  call StripTrailingWhite()
endif

" --- Syntax specific settings -----------------------------------------------
" --- Ruby
if has("autocmd")
  autocmd FileType ruby,eruby setlocal cinwords=do
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading=1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global=1
endif

" --- C,C++,ObjC
if has("autocmd")
  autocmd FileType java,c,cpp,objc setlocal smartindent tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType java,c,cpp,objc let b:loaded_delimitMate = 1
endif

" --- Markdown
if has("autocmd")
  autocmd BufNewFile,BufRead *.mdwn,*.mkd,*.md,*.markdown setlocal filetype=markdown
  autocmd FileType markdown setlocal tabstop=4 shiftwidth=4 softtabstop=4
endif

" --- Finish up --------------------------------------------------------------
set secure
" EOF
