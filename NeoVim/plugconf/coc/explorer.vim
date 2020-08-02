call coc#add_extension('coc-explorer')

let g:coc_explorer_global_presets = {
\   'nvim': {
\      'root-uri': '~/.config/nvim',
\   },
\   'floating': {
\      'position': 'floating',
\   },
\   'floatingLeftside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'floatingRightside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'simplify': {
\     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }

" Use preset argument to open it
" nmap <space>ed :CocCommand explorer --preset nvim<CR>
nmap <silent> <M-1> :CocCommand explorer --preset simplify<CR>

" List all presets
" nmap <space>el :CocList explPresets
