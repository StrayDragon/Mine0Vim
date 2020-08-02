call coc#add_extension('coc-smartf')

" press <esc> to cancel.
nmap <space><space>f <Plug>(coc-smartf-forward)
nmap <space><space>F <Plug>(coc-smartf-backward)
" nmap ; <Plug>(coc-smartf-repeat)
" nmap , <Plug>(coc-smartf-repeat-opposite)

augroup Smartf
  autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=#fa0b0b
  autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
augroup end
