" Plug 'skywind3000/vim-quickui'

"# Context/Action
let content = [
            \ ["surround &[]", 'normal ysiw['],
            \ ["surround &()", 'normal ysiw('],
            \ ["surround &{}", 'normal ysiw{'],
            \ ["&help Keyword\t\\ch", 'echo 100' ],
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
" enable to display tips in the cmdline
" let g:quickui_show_tip = 1


"# Menus
" clear all the menus
call quickui#menu#reset()
" install a 'File' menu, use [text, command] to represent an item.
" call quickui#menu#install('&File', [
"             \ [ "&New File\tCtrl+n", 'echo 0' ],
"             \ [ "&Open File\t(F3)", 'echo 1' ],
"             \ [ "&Close", 'echo 2' ],
"             \ [ "--", '' ],
"             \ [ "&Save\tCtrl+s", 'echo 3'],
"             \ [ "Save &As", 'echo 4' ],
"             \ [ "Save All", 'echo 5' ],
"             \ [ "--", '' ],
"             \ [ "E&xit\tAlt+x", 'echo 6' ],
"             \ ])
" " items containing tips, tips will display in the cmdline
" call quickui#menu#install('&Edit', [
"             \ [ '&Copy', 'echo 1', 'help 1' ],
"             \ [ '&Paste', 'echo 2', 'help 2' ],
"             \ [ '&Find', 'echo 3', 'help 3' ],
"             \ ])
" " script inside %{...} will be evaluated and expanded in the string
" call quickui#menu#install("&Option", [
" 			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
" 			\ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
" 			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
" 			\ ])
" " register HELP menu with weight 10000
" call quickui#menu#install('H&elp', [
" 			\ ["&Cheatsheet", 'help index', ''],
" 			\ ['T&ips', 'help tips', ''],
" 			\ ['--',''],
" 			\ ["&Tutorial", 'help tutor', ''],
" 			\ ['&Quick Reference', 'help quickref', ''],
" 			\ ['&Summary', 'help summary', ''],
" 			\ ], 10000)
function! MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
 
function! MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

call quickui#menu#install('&Buffer', [
			\ ["rotate Top-Down", 'normal <C-w>t<C-w>H<ESC>', ''],
			\ ["rotate Left-Right", '<C-w>t<C-w>K<ESC>', ''],
			\ ['--',''],
			\ ["move to next tab", 'call MoveToNextTab()', ''],
			\ ["move to prev tab", 'call MoveToPrevTab()', ''],
			\ ['--',''],
			\ ["&Tutorial", 'help tutor', ''],
			\ ], 10000)

" hit space twice to open menu
noremap <silent> <A-m> :call quickui#menu#open()<cr>

"# ListBox
let listbox_content = [
            \ [ 'echo 1', 'echo 100' ],
            \ [ 'echo 2', 'echo 200' ],
            \ [ 'echo 3', 'echo 300' ],
            \ [ 'echo 4' ],
            \ [ 'echo 5', 'echo 500' ],
            \]
let listbox_opts = {'title': 'select one'}
noremap <silent> <A-l> :call quickui#listbox#open(listbox_content, listbox_opts)<CR>

