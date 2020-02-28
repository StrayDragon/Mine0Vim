let g:far#source = 'rg'

let g:far#window_layout = 'bottom'
let g:far#window_width = 60
let g:far#window_height = 20

let g:far#preview_window_layout = 'bottom'
let g:far#preview_window_width = 60
let g:far#preview_window_height = 11

let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.html', '**/*.js', '**/*.css']

let g:far#enable_undo = 1

" shortcut for far.vim find
nnoremap <silent> <M-f>  :Farf<cr>
vnoremap <silent> <M-f>  :Farf<cr>

" shortcut for far.vim replace
nnoremap <silent> <M-r>  :Farr<cr>
vnoremap <silent> <M-r>  :Farr<cr>
