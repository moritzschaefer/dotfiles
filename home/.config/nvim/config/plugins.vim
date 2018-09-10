" deoplete
let g:deoplete#enable_at_startup = 1
let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }
let g:neomake_javascript_enabled_makers = ['jshint']
set completeopt=longest,menuone,preview
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']

" tern
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']
" tern
if exists('g:plugs["tern_for_vim"]')
  let g:deoplete#omni#functions = {}
  " let g:deoplete#omni#functions.javascript = [
  "   \ 'tern#Complete',
  "   \ 'jspc#omni'
  " \]
endif

let g:airline#extensions#ale#enabled = 1
let g:ale_fixers = {
\   'javascript': ['prettier_eslint'],
\   'typescript': ['prettier'],
\   'python': ['autopep8'],
\}
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\}
let g:ale_javascript_prettier_options = ''
let g:ale_lint_on_save = 1
let g:ale_enabled = 1
nmap <silent> [a <Plug>(ale_previous_wrap)
nmap <silent> ]a <Plug>(ale_next_wrap)
nnoremap <C-f> :ALEFix<CR>

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_flow_exe = 'flow'

" tsuquyomi
autocmd FileType typescript setlocal completeopt+=menu,preview
let g:tsuquyomi_disable_quickfix = 1

" typescript-vim
" set filetypes as typescript.jsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.jsx

" jsx
let g:jsx_ext_required = 0

" vim-fugitive
nmap     <Leader>gs :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>
nnoremap <silent> <Leader>dg :diffget<CR>
nnoremap <silent> <Leader>dp :diffput<CR>

" gitgutter
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" supertab
" close the preview window when you're not using it
let g:SuperTabClosePreviewOnPopupClose = 1
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:UltiSnipsExpandTrigger="<C-j>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" fzf
nnoremap <C-p> :FZF<cr>

"---------------------------------------------------------------------------
" denite.nvim
"

"nnoremap <C-p> :deniteprojectdir file_rec buffer<cr>
" nnoremap <silent> <C-p> :<C-u>Denite
"       \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>

if executable('rg')
  call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '5'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
else
  call denite#custom#var('file_rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#source('file_old', 'matchers',
      \ ['matcher_fuzzy', 'matcher_project_files'])
if has('nvim')
  call denite#custom#source('file_rec,grep', 'matchers',
        \ ['matcher_cpsm'])
endif
call denite#custom#source('file_old', 'converters',
      \ ['converter_relative_word'])

call denite#custom#map('insert', '<C-j>',
      \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>',
      \ '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', ",",
      \ '<denite:move_to_next_line>', 'noremap')

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

" call denite#custom#option('default', 'prompt', '>')
" call denite#custom#option('default', 'short_source_names', v:true)
call denite#custom#option('default', {
      \ 'prompt': '>', 'short_source_names': v:true
      \ })

let s:menus = {}
let s:menus.configs = {
    \ 'description': 'Configuration files',
    \ }
let s:menus.configs.file_candidates = [
    \ ['    > Edit VIM configuration file ', '~/.config/nvim/config/'],
    \ ['    > Edit ZSH configuration file', '~/.zshrc'],
    \ ['    > Edit TMUX configuration file', '~/.tmux.conf']
    \ ]
call denite#custom#var('menu', 'menus', s:menus)
nnoremap <Leader>c :Denite menu:configs<CR>

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

nnoremap <space>/ :Denite grep:.<cr>
let g:denite_source_history_yank_enable = 1
nnoremap <space>s :Denite buffer<cr>

" miniyank
nnoremap <Leader>p :Denite miniyank<CR>

"easymotion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_keys='uiaenrtdosxvlcwkhgfqßyüöäpzbm,.jUIAENRDXVLCOWSKHGFQÜÖÄPMJ\/{}():-*?…[]<>=&'
"let g:EasyMotion_leader_key = '<Leader>'
nmap f <Plug>(easymotion-overwin-f)
let g:EasyMotion_smartcase = 1
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

"incsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
" incsearch-easymotion
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

" camel case
call camelcasemotion#CreateMotionMappings(',')


nnoremap <Leader>nt :NERDTreeToggle<CR>

" ambienter-vim
let sensor_path = "/sys/devices/platform/applesmc.768/light"

if filereadable(sensor_path)
  let g:ambienter_config = {
              \     "sensor": {
              \         "path": sensor_path,
              \         "value": {"min": 13 }
              \     },
              \     "disable": 0,
              \     "debug": 0,
              \     "theme": {
              \         "light": {
              \             "background": "light",
              \             "colorsheme": "hybrid"
              \         },
              \         "dark": {
              \             "background": "dark",
              \             "colorsheme": "hybrid"
              \         }
              \     },
              \     "callbacks": [function("airline#load_theme")]
              \ }
else
  let g:ambienter_config = []
endif


au WinEnter,BufEnter * call Ambienter.Sensor() " Adapt colorsheme to ambient light

" disable colorizer at startup
let g:colorizer_startup = 0
" let g:colorizer_nomap = 0

" completion " TODO really good?
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end
