"- Plug 'mbbill/undotree'
"  Undo Tree style
let g:undotree_WindowLayout = 1
"  undotree window width
let g:undotree_SplitWidth = 24
"  vim启动时打开NerdTree与Startify
"autocmd VimEnter *
            "\   if !argc()
            "\ |   Startify
            "\ |   NERDTree
            "\ |   wincmd w
            "\ | endif
" nnoremap <silent> <Leader>3 :UndotreeToggle<CR>
nnoremap <silent> <A-3> :UndotreeToggle<CR>
