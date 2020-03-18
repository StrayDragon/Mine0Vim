" Plug 'dbridges/vim-markdown-runner' , { 'for' :['markdown', 'vim-plug']  }
autocmd FileType markdown nnoremap <buffer> <Leader>r :MarkdownRunner<CR>
autocmd FileType markdown nnoremap <buffer> <Leader>R :MarkdownRunnerInsert<CR>
" Specify an alternate shell command for a certain language
" let g:markdown_runners['python'] = 'python3'

" Specify your own Vim script function for further customization.
" The function should receive a list of strings, representing the contents of
" the code block, and return a single string with the results.
" function! MyHtmlRunner(src)
"   " ... your custom processing
"   return "Results"
" endfunction

" let g:markdown_runners['html'] = function('MyHtmlRunner')
