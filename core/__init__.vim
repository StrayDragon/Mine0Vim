"# NoCompatible
if &compatible
	" vint: -ProhibitSetNoCompatible
	set nocompatible
	" vint: +ProhibitSetNoCompatible
endif

"# Optimalize
"## Disable vim distribution plugins
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:loaded_rrhelper = 1  " ?
let g:loaded_shada_plugin = 1  " ?
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1


" Initialize base requirements
" Global Mappings
let g:mapleader="\<Space>"
let g:maplocalleader=','

" Release keymappings prefixes, evict entirely for use of plug-ins.
" nnoremap <Space>  <Nop>
" xnoremap <Space>  <Nop>
" nnoremap ,        <Nop>
" xnoremap ,        <Nop>
" nnoremap ;        <Nop>
" xnoremap ;        <Nop>

" Disable stop key
map s <nop>

if !has('nvim') && has('pythonx')
  if has('python3')
    set pyxversion=3
  elseif has('python')
    set pyxversion=2
  endif
endif

"- start time influenced by remote-plugins
if has('nvim')
  let g:loaded_python_provider=1
  let g:python_host_skip_check=0
  let g:python_host_prog='/usr/bin/python2'
  let g:python3_host_skip_check=1
  let g:python3_host_prog='/usr/bin/python3'
  let g:loaded_ruby_provider=0
endif

let g:mine0vim_path =
	\ get(g:, 'mine0vim_path',
	\   exists('*stdpath') ? stdpath('config') :
	\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
	\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
	\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
	\   ! empty($VIM_PATH) ? expand($VIM_PATH) :
	\   expand('$HOME/.vim')
	\ )

exec 'source' g:mine0vim_path . '/core/settings.vim'
exec 'source' g:mine0vim_path . '/core/mapping.vim'

for plugin_config in split(glob(g:mine0vim_path . '/plugconf/*.vim'), '\n')
  exec 'source' plugin_config
endfor

exec 'source' g:mine0vim_path . '/core/theme.vim'

for coc_extension_config in split(glob(g:mine0vim_path . '/plugconf/coc/*.vim'), '\n')
  exec 'source' coc_extension_config
endfor
