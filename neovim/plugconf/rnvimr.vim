" Make Ranger replace netrw and be the file explorer
let g:rnvimr_ex_enable = 1

nnoremap <silent> <A-o> :RnvimrToggle<CR>
tnoremap <silent> <A-o> <C-\><C-n>:RnvimrToggle<CR>

" Resize floating window by all preset layouts
tnoremap <silent> <A-O> <C-\><C-n>:RnvimrResize<CR>

" " Resize floating window by special preset layouts
" tnoremap <silent> <A-l> <C-\><C-n>:RnvimrResize 1,8,9,13,11,5<CR>

" Resize floating window by single preset layout
" tnoremap <silent> <A-y> <C-\><C-n>:RnvimrResize 5<CR>

" Customize the initial layout
let g:rnvimr_layout = { 'relative': 'editor',
            \ 'width': float2nr(round(1.0 * &columns)),
            \ 'height': float2nr(round(0.3 * &lines)),
            \ 'col': float2nr(round(1.0 * &columns)),
            \ 'row': float2nr(round(1.0 * &lines)),
            \ 'style': 'minimal' }

" Customize multiple preset layouts
" '{}' represents the initial layout
let g:rnvimr_presets = [
            \ {'width': 0.250, 'height': 0.250},
            \ {'width': 0.333, 'height': 0.333},
            \ {},
            \ {'width': 0.666, 'height': 0.666},
            \ {'width': 0.750, 'height': 0.750},
            \ {'width': 0.900, 'height': 0.900},
            \ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0},
            \ {'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0.5},
            \ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0},
            \ {'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0.5},
            \ {'width': 0.500, 'height': 1.000, 'col': 0, 'row': 0},
            \ {'width': 0.500, 'height': 1.000, 'col': 0.5, 'row': 0},
            \ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0},
            \ {'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0.5}]
