"- Plug 'gryf/dragvisuals'
"- 模仿JB IDE整行移动
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()
" vmap  <expr>  <S-LEFT>   DVB_Drag('left')
" vmap  <expr>  <S-RIGHT>  DVB_Drag('right')
" vmap  <expr>  <S-DOWN>   DVB_Drag('down')
" vmap  <expr>  <S-UP>     DVB_Drag('up')

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1
