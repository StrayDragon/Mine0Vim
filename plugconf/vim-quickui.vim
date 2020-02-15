"- Plug 'skywind3000/vim-quickui'
let content = [
            \ ["&help Keyword\t\\ch", 'echo 100' ],
            \ ["&signature\t\\cs", 'echo 101'],
            \ ['-'],
            \ ["find in &file\t\\cx", 'echo 200' ],
            \ ["find in &project\t\\cp", 'echo 300' ],
            \ ["find in &defintion\t\\cd", 'echo 400' ],
            \ ["search &references\t\\cr", 'echo 500'],
            \ ['-'],
            \ ["&documentation\t\\cm", 'echo 600'],
            \ ]

" set cursor to the last position
let opts = {'index':g:quickui#context#cursor}
nnoremap <silent> <M-Enter> :call quickui#context#open(content, opts)<CR>
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'papercol dark'
