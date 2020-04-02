"- vim-plug
let g:plug_threads = 32
let g:plug_timeout = 45
" let g:plug_url_format = 'https://git::@github.com/%s.git'

"# Plugins Management
"- Use plug.vim
call plug#begin('~/.config/nvim/plugged')

"## Startup Time and Profile
Plug 'tweekmonster/startuptime.vim' , { 'on': ['StartupTime'] }

"## Session Management
"- use coc-lists (session integrated)
" Plug 'xolox/vim-session'
" Plug 'xolox/vim-misc' " xolox/vim-session deps

"## Fix functions
" Plug 'drmikehenry/vim-fixkey'

"## Time statistics
Plug 'wakatime/vim-wakatime'

"## Auto Switch IM
Plug 'StrayDragon/vim-smartim'

"## Finder
" Plug 'dyng/ctrlsf.vim'
Plug 'brooth/far.vim'
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
"Plug 'junegunn/fzf.vim'
"Plug 'liuchengxu/vim-clap' "FIXME:HowToUSE

"## File Navigation
"- use coc-explorer
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

"## Undo Tree
Plug 'mbbill/undotree'

"## Terminal
Plug 'voldikss/vim-floaterm'

"## Language Server :Auto Complete, Navigate, Snippets...
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"## Debug integrated
Plug 'puremourning/vimspector' , { 'dir': '~/.config/nvim/plugged/vimspector', 'do': './install_gadget.py --all --disable-tcl --disable-bash' }
"Plug 'cpiger/NeoDebug' , { 'on': ['NeoDebug', 'NeoDebugStop'] }
"Plug 'strottos/vim-padre', { 'dir': '~/.vim/plugged/vim-padre', 'do':'make' }
"Plug 'dbgx/lldb.nvim'

"## Taglist
Plug 'liuchengxu/vista.vim'

"## linter
"- use coc's LSP

"## Git
Plug 'tpope/vim-fugitive' 
" Plug 'jreybert/vimagit'
" Plug 'lambdalisue/gina.vim'
"Plug 'airblade/vim-gitgutter'
"Plug 'theniceboy/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] } "FIXME:HowToUSE
"Plug 'fszymanski/fzf-gitignore', { 'do': ':UpdateRemotePlugins' } "FIXME:HowToUSE
"Plug 'junegunn/gv.vim' " gv (normal) to show git log "FIXME:HowToUSE

"## Editor functions enhancement
Plug 'skywind3000/vim-terminal-help'
Plug 'skywind3000/vim-quickui'
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'
Plug 'farmergreg/vim-lastplace'
" Plug 'aperezdc/vim-template', { 'on': ['Template', 'TemplateHere'] }
"Plug 'tpope/vim-capslock'"FIXME:HowToUSE

"### QuickStart
Plug 'mhinz/vim-startify'

"### Edit
Plug 'AndrewRadev/switch.vim'
Plug 'tpope/vim-surround'
" Plug 'terryma/vim-multiple-cursors'
"Plug 'junegunn/vim-easy-align' "FIXME:HowToUSE
"Plug 'gcmt/wildfire.vim' "FIXME:HowToUSE
"Plug 'tpope/vim-abolish' "FIXME:HowToUSE

"### Move
"- use coc-smartf
" Plug 'easymotion/vim-easymotion', { 'on' : ['<Plug>(easymotion-s2)'] }
Plug 'gryf/dragvisuals'

"## Global Colorschemes/Themes
Plug 'doums/darcula'
" Plug 'lifepillar/vim-solarized8'
" Plug 'rakr/vim-one'
" Plug 'joshdick/onedark.vim'
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'ayu-theme/ayu-vim'
" Plug 'morhetz/gruvbox'
" Plug 'arcticicestudio/nord-vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'ayu-theme/ayu-vim'
" Plug 'jacoborus/tender.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'sonph/onehalf' , { 'rtp': 'vim' }
" Plug 'Marfisc/vorange'
" Plug 'altercation/vim-colors-solarized'

"### Status line and themes
Plug 'itchyny/lightline.vim'

"### Display effect enhance
Plug 'Yggdroot/indentLine'
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
" Plug 'TaDaa/vimade'

"### Vimer est
Plug 'takac/vim-hardtime'

"### Comment shortcuts
Plug 'tpope/vim-commentary'

"### Bookmarks
"- use coc-bookmark
"Plug 'kshenoy/vim-signature' "FIXME:HowToUSE
"Plug 'mhinz/vim-signify' "FIXME:HowToUSE
"Plug 'MattesGroeger/vim-bookmarks'

"### Documentation

"#### Find
Plug 'KabbAmine/zeavim.vim' 

"#### Edit
Plug 'kkoomen/vim-doge'

"#### Fold
Plug 'pseewald/vim-anyfold'

"## Special Language enhancements

"### snippets
"- use coc-snippets
Plug 'honza/vim-snippets' " coc-snippets deps
" Plug 'SirVer/ultisnips'

"### Dart/Flutter
Plug 'dart-lang/dart-vim-plugin', { 'for' : [ 'dart', 'vim-plug' ] }

"### Rust
Plug 'cespare/vim-toml' , { 'for' :[ 'toml', 'vim-plug' ] }
if has('nvim')
Plug 'mhinz/vim-crates', { 'for' :[ 'toml', 'vim-plug' ] }
endif

"### Cpp
"Plug 'octol/vim-cpp-enhanced-highlight'

"### Tex
"Plug 'lervag/vimtex'

"### HTML, CSS, JavaScript, PHP, JSON, etc.
"Plug 'elzr/vim-json'
"Plug 'hail2u/vim-css3-syntax'
"Plug 'spf13/PIV'                 , { 'for' :['php', 'vim-plug'] }
"Plug 'gko/vim-coloresque'        , { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
"Plug 'pangloss/vim-javascript' " , { 'for' :['javascript', 'vim-plug'] }
"Plug 'yuezk/vim-js'
"Plug 'MaxMEllon/vim-jsx-pretty'
"Plug 'jelera/vim-javascript-syntax'

"### Go
" Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*', 'do': ':GoUpdateBinaries' }

"### Python
if has('nvim')
Plug 'numirias/semshi'            ,  { 'do': ':UpdateRemotePlugins' }
endif
"Plug 'tweekmonster/braceless.vim'
"Plug 'tmhedberg/SimpylFold'
"Plug 'Vimjas/vim-python-pep8-indent' , { 'for' :['python', 'vim-plug'] }
"Plug 'vim-scripts/indentpython.vim'  , { 'for' :['python', 'vim-plug'] }
"Plug 'plytophogy/vim-virtualenv'     , { 'for' :['python', 'vim-plug'] }

"### Markdown
Plug 'gabrielelana/vim-markdown'    , { 'for' :['markdown', 'vim-plug']  }
Plug 'iamcco/markdown-preview.nvim' , { 'for' :['markdown', 'vim-plug'] , 'do': 'cd app & yarn install' }
Plug 'godlygeek/tabular'            , { 'for' :['python', 'vim','zsh','markdown', 'vim-plug']}
Plug 'dbridges/vim-markdown-runner' , { 'for' :['markdown', 'vim-plug']  }
" Plug 'gpanders/vim-medieval'     , { 'for' :['markdown', 'vim-plug'] }
" Plug 'plasticboy/vim-markdown', { 'for' :['markdown', 'vim-plug'] }
"Plug 'tpope/vim-markdown' , { 'for': [ 'md', 'markdown'] }
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for' :['markdown', 'vim-plug']  }
"Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }

"## Others Plugins
"Plug 'reedes/vim-wordy' "FIXME:HowToUSE
"Plug 'voldikss/vim-translate-me', { 'on' : ['Translate','TranslateW','TranslateR','TranslateH'] }
"Plug 'ron89/thesaurus_query.vim' "FIXME:HowToUSE
"Plug 'osyo-manga/vim-anzu' "FIXME:HowToUSE
"Plug 'voldikss/vim-floaterm' "FIXME:HowToUSE
"Plug 'jceb/vim-orgmode' "FIXME:HowToUSE
"Plug 'tpope/vim-eunuch' " do stuff like :SudoWrite
call plug#end()
