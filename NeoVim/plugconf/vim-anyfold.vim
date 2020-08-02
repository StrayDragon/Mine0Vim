" Plug 'pseewald/vim-anyfold'
hi Folded term=NONE cterm=NONE
let g:anyfold_fold_comments=1
let g:anyfold_motion = 0
" disable anyfold for large files
" let g:LargeFile = 1000000 " file is large if size greater than 1MB
" activate anyfold by default
" augroup anyfold
"     autocmd!
"     autocmd Filetype python AnyFoldActivate
" augroup END
" autocmd BufReadPre,BufRead * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
" function LargeFile()
"     augroup anyfold
"         autocmd! " remove AnyFoldActivate
"         autocmd Filetype python setlocal foldmethod=indent " fall back to indent folding
"     augroup END
" endfunction
