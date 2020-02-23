syntax on
filetype plugin indent on
set autochdir
set wildmenu
if has('gui')
  set guifont=JetbrainsMono:h14
endif
if has('termguicolors')
	set termguicolors
endif
set nobackup
set noswapfile
set autoread
set autowrite
set confirm
set splitbelow
set bsdir=buffer
if has('mouse')
  set mouse=a
endif
if has('vim_starting')
	set encoding=UTF-8
	scriptencoding UTF-8
endif
set laststatus=2
set showtabline=2
set scrolloff=4
if has('clipboard')
	set clipboard& clipboard+=unnamedplus
endif
set history=2000
set number
set timeout ttimeout
set cmdheight=2
set timeoutlen=500
set ttimeoutlen=10
set updatetime=100
set undofile
set undodir=~/.tmp/undo
set relativenumber
set backspace=2
set backspace=indent,eol,start
set textwidth=80
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType python setlocal et sta sw=4 sts=4
autocmd FileType rust setlocal et sta sw=2 sts=2
set smarttab
set autoindent
set smartindent
set shiftround
set hidden
set noshowmode
set shortmess+=c
set signcolumn=yes
set completefunc=emoji#complete
set completeopt =longest,menu
set completeopt-=preview
set list
set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
set ignorecase
set smartcase
set infercase
set incsearch
set hlsearch
execute "nohlsearch"
set wrap
set wrapscan
set linebreak
set showmatch
set matchpairs+=<:>
set matchtime=1
set cpoptions-=m
set grepprg=rg\ --vimgrep\ $*
set wildignore+=*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*
if has('conceal')
	set conceallevel=3 concealcursor=niv
endif
set undofile swapfile nobackup
set directory=$DATA_PATH/swap//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set undodir=$DATA_PATH/undo//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set backupdir=$DATA_PATH/backup/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set viewdir=$DATA_PATH/view/
set nospell spellfile=$VIM_PATH/spell/en.utf-8.add
" History saving
set history=1000
if has('nvim')
	set shada='300,<50,@100,s10,h
else
	set viminfo='300,<10,@50,h,n$DATA_PATH/viminfo
endif
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~'.$USER)
		\ && $HOME ==# expand('~'.$SUDO_USER)
	set noswapfile
	set nobackup
	set nowritebackup
	set noundofile
	if has('nvim')
		set shada="NONE"
	else
		set viminfo="NONE"
	endif
endif
if exists('&backupskip')
	set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
	set backupskip+=.vault.vim
endif
augroup MyAutoCmd
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
augroup END
if has('folding')
	set foldenable
	set foldmethod=syntax
	set foldlevelstart=99
endif
