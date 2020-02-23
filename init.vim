"# First startup
"- plug.vim installation and PlugInstall
if has('nvim') && empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


exec 'source' fnamemodify(expand('<sfile>'), ':h').'/core/__init__.vim'
