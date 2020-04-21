" Plug 'bootleq/vim-cycle'
nmap <silent> gs <Plug>CycleNext
vmap <silent> gs <Plug>CycleNext

call cycle#add_groups([
      \   [['true', 'false']],
      \   [['True', 'False']],
      \   [['1', '0']],
      \   [['yes', 'no']],
      \   [['on', 'off']],
      \ ])

