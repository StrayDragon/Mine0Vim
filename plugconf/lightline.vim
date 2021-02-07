"## Statusline
"- lightline.vim configuration
let g:lightline = {
     \    'colorscheme': 'jellybeans',
     \    'active': {
     \      'left': [ [ 'mode', 'paste' ],
     \                [  'git_branch', 'cocstatus', 'readonly', 'filename', 'modified' ] ],
     \      'right':[
     \        [ 'fileencoding', 'lineinfo'],
     \        [ 'blame' ]
     \      ],
     \    },
     \    'component_function': {
     \      'cocstatus': 'coc#status',
     \      'blame': 'LightlineGitBlame',
     \      'git_branch' : 'LightlineGitBranch'
     \    },
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
