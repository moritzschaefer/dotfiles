
" Eclim
" first disable ycm key
let g:ycm_key_detailed_diagnostics = ''
nnoremap <silent> <buffer> <Leader>i :JavaImport<CR>
nnoremap <silent> <buffer> <Leader>d :JavaDocSearch -x declarations<cr>
nnoremap <silent> <buffer> <Leader>q :JavaCorrect<cr>
nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
