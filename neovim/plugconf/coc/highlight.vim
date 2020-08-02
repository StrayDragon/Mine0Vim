call coc#add_extension('coc-highlight')

autocmd CursorHold * silent call CocActionAsync('highlight')
nnoremap <leader>P :call CocAction('pickColor')<CR>
nnoremap <leader>C :call CocAction('colorPresentation')<CR>
