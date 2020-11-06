"# Themes
"## Colorschemes
"if str2nr( strftime("%H") ) > 8 && str2nr( strftime("%H") < 18 )
"  set background=light
"else
"  set background=dark
"endif
"开启vim 256色
" set t_Co=256
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax enable
set background=dark
colorscheme darcula
" colorscheme one
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

" hi! Cursor ctermfg=1 ctermbg=1 guifg=#FF0000 guibg=#FF0000
" set guicursor=a:block-Cursor/Cursor-blinkon0
" try to fix weird 'ff' charactors
" set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
" \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
" \,sm:block-blinkwait175-blinkoff150-blinkon175
