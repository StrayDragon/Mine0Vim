"# Plugins Management
if has('nvim')
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
"## Startup Time and Profile
Plug 'tweekmonster/startuptime.vim' , { 'on': ['StartupTime'] }
"## auto switch im
Plug 'StrayDragon/vim-smartim'
"## Find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
"## File Navigation
"- Use coc-explorer
"## Undo Tree
Plug 'mbbill/undotree' , { 'on':['UndotreeToggle'] }
"## Language Server :Auto Complete, Navigate, Snippets...
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"## Debug integrated
Plug 'puremourning/vimspector'
"Plug 'cpiger/NeoDebug' , { 'on': ['NeoDebug', 'NeoDebugStop'] }
"Plug 'strottos/vim-padre', { 'dir': '~/.vim/plugged/vim-padre', 'do':'make' }
"Plug 'dbgx/lldb.nvim'
"## Taglist
Plug 'liuchengxu/vista.vim'
"## linter
"- Use coc's LSP
"## Global Themes
Plug 'doums/darcula'
Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'jacoborus/tender.vim'
Plug 'cocopon/iceberg.vim'
Plug 'sonph/onehalf' , { 'rtp': 'vim' }
" Plug 'Marfisc/vorange'
" Plug 'altercation/vim-colors-solarized'
"## Status line and themes
Plug 'itchyny/lightline.vim'
"## Editor display enhance
Plug 'Yggdroot/indentLine'
Plug 'tweekmonster/braceless.vim'
"## Editor functions enhancement
Plug 'mhinz/vim-startify'
" Plug 'easymotion/vim-easymotion', { 'on' : ['<Plug>(easymotion-s2)'] }
" Plug 'junegunn/goyo.vim'
" Plug 'junegunn/limelight.vim'
Plug 'takac/vim-hardtime'
Plug 'gryf/dragvisuals'
Plug 'TaDaa/vimade'
Plug 'dyng/ctrlsf.vim'
Plug 'skywind3000/vim-quickui'
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'
Plug 'tpope/vim-commentary'
Plug 'aperezdc/vim-template', { 'on': ['Template', 'TemplateHere'] }
Plug 'AndrewRadev/switch.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
"Plug 'junegunn/vim-easy-align' "FIXME:HowToUSE
"Plug 'gcmt/wildfire.vim' "FIXME:HowToUSE
"Plug 'godlygeek/tabular' "FIXME:HowToUSE
"Plug 'tpope/vim-capslock'"FIXME:HowToUSE
"Plug 'tpope/vim-abolish' "FIXME:HowToUSE
"Plug 'kshenoy/vim-signature' "FIXME:HowToUSE
"Plug 'mhinz/vim-signify' "FIXME:HowToUSE
Plug 'MattesGroeger/vim-bookmarks'
"Plug 'reedes/vim-wordy' "FIXME:HowToUSE
Plug 'voldikss/vim-translate-me', { 'on' : ['Translate','TranslateW','TranslateR','TranslateH'] }
"Plug 'ron89/thesaurus_query.vim' "FIXME:HowToUSE
"Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Fardo'] } "FIXME:HowToUSE
"Plug 'osyo-manga/vim-anzu' "FIXME:HowToUSE
"Plug 'voldikss/vim-floaterm' "FIXME:HowToUSE
"Plug 'liuchengxu/vim-clap' "FIXME:HowToUSE
"Plug 'jceb/vim-orgmode' "FIXME:HowToUSE
"Plug 'tpope/vim-eunuch' " do stuff like :SudoWrite
"## Documentation
Plug 'KabbAmine/zeavim.vim' " <LEADER>z to find doc
"## Git
Plug 'airblade/vim-gitgutter'
"Plug 'theniceboy/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] } "FIXME:HowToUSE
"Plug 'fszymanski/fzf-gitignore', { 'do': ':UpdateRemotePlugins' } "FIXME:HowToUSE
"Plug 'tpope/vim-fugitive' " gv dependency "FIXME:HowToUSE
"Plug 'junegunn/gv.vim' " gv (normal) to show git log "FIXME:HowToUSE
"Plug 'lambdalisue/gina.vim'
"## Genreal Highlighter FIXME:LSP Replace possibility
"Plug 'jaxbot/semantic-highlight.vim'
"Plug 'chrisbra/Colorizer' " Show colors with :ColorHighlight
"## Special Highlighter
"Cpp
"Plug 'octol/vim-cpp-enhanced-highlight'
"## Target Language edit enhancement
"- Tex
"Plug 'lervag/vimtex'
"- HTML, CSS, JavaScript, PHP, JSON, etc.
"Plug 'elzr/vim-json'
"Plug 'hail2u/vim-css3-syntax'
"Plug 'spf13/PIV', { 'for' :['php', 'vim-plug'] }
"Plug 'gko/vim-coloresque', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
"Plug 'pangloss/vim-javascript' ", { 'for' :['javascript', 'vim-plug'] }
"Plug 'yuezk/vim-js'
"Plug 'MaxMEllon/vim-jsx-pretty'
"Plug 'jelera/vim-javascript-syntax'
"-Dart/Flutter
Plug 'dart-lang/dart-vim-plugin', { 'for' : [ 'dart', 'vim-plug' ] }
"- Rust
Plug 'cespare/vim-toml' , { 'for' :[ 'toml', 'vim-plug' ] }
Plug 'mhinz/vim-crates', { 'for' :[ 'toml', 'vim-plug' ] }
" - Go
" Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }
" Plug 'fatih/vim-go' " , { 'do': ':GoUpdateBinaries' }
"- Python
"Plug 'tmhedberg/SimpylFold'
"Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] }
"Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
"Plug 'vim-scripts/indentpython.vim', { 'for' :['python', 'vim-plug'] }
"Plug 'plytophogy/vim-virtualenv', { 'for' :['python', 'vim-plug'] }
" Markdown
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
"Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
"Plug 'theniceboy/bullets.vim'
call plug#end()
