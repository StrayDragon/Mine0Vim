"# Themes
"## Colorschemes
"if str2nr( strftime("%H") ) > 8 && str2nr( strftime("%H") < 18 )
"  set background=light
"else
"  set background=dark
"endif
"开启vim 256色
" set t_Co=256
syntax enable 
set background=dark
colorscheme darcula
" colorscheme ayu
" colorscheme onedark
" colorscheme gruvbox
" colorscheme solarized8_flat
" colorscheme palenight 
" colorscheme jellybeans
" colorscheme nord
" colorscheme iceberg
" colorscheme onehalfdark
" colorscheme ayu
" let ayucolor="dark"
" highlight Normal guibg=None ctermfg=None
"## Statusline
"- lightline.vim configuration
let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [  'git_branch', 'cocstatus', 'readonly', 'filename', 'modified' ] ],
        \   'right':[
        \     [ 'fileencoding', 'lineinfo'],
        \     [ 'blame' ]
        \   ],
        \   },
        \ 'component_function': {
        \   'cocstatus': 'coc#status',
        \   'blame': 'LightlineGitBlame',
        \   'git_branch' : 'LightlineGitBranch'
        \ },
        \ }

function LightlineGitBranch() abort
  let git_branch = get(g:, 'coc_git_status', '')
  " return blame
  return winwidth(0) > 120 ? git_branch : ''
endfunction

function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction

" let g:lightline#bufferline#show_number  = 1
" let g:lightline#bufferline#shorten_path = 1
" let g:lightline#bufferline#unnamed      = '[No Name]'

" let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
" let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
" let g:lightline.component_type   = {'buffers': 'tabsel'}

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

