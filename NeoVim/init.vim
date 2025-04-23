"# First startup
"- plug.vim installation and PlugInstall
" if has('nvim') && empty(glob('~/.config/nvim/autoload/plug.vim'))
" 	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
" 				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif


if get(s:, 'mine0vim_loaded', 0) != 0
	finish
else
	let s:mine0vim_loaded = 1
endif

exec 'source' fnamemodify(expand('<sfile>'), ':h').'/core/__init__.vim'

lua require('init')
