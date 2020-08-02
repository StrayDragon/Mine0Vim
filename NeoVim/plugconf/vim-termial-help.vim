" Plug 'skywind3000/vim-terminal-help'
" REF: https://github.com/skywind3000/vim-terminal-help#settings
" g:terminal_key: which key will be used to toggle terminal window, default to <m-=>.
" g:terminal_cwd: initialize working dir: 0 for unchanged, 1 for file path and 2 for project root.
let g:terminal_cwd = 0
" g:terminal_height: new terminal height, default to 10.
let g:terminal_height = 12
" g:terminal_pos: where to open the terminal, default to rightbelow.
" g:terminal_shell: specify shell rather than default one.
" g:terminal_edit: command to open the file in vim, default to tab drop.
" g:terminal_kill: set to term to kill term session when exiting vim.
" g:terminal_list: set to 0 to hide terminal buffer in the buffer list.
let g:terminal_list = 1
" g:terminal_fixheight: set to 1 to set winfixheight for the terminal window.
let g:terminal_fixheight = 1

" REF: https://github.com/skywind3000/vim-terminal-help#usage
" ALT + =: toggle terminal below.
" ALT + SHIFT + h: move to the window on the left.
" ALT + SHIFT + l: move to the window on the right.
" ALT + SHIFT + j: move to the window below.
" ALT + SHIFT + k: move to the window above.
" ALT + SHIFT + p: move to the previous window.
" ALT + -: paste register 0 to terminal.
" ALT + q: switch to terminal normal mode.

" Autoclose popup when exit terminal
let g:terminal_close = 1
