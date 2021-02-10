"# `coc.nvim` Extensions Management
let g:coc_global_extensions = [
  \ 'coc-explorer', 
  \ 'coc-yank', 
  \ 'coc-pairs', 
  \ 'coc-smartf', 
  \ 'coc-marketplace',
  \ 'coc-highlight',
  \ 'coc-git',
  \ 'coc-gitignore',
  \ 'coc-lists',
  \ 'coc-json', 
  \ 'coc-snippets', 
  \ "coc-floaterm",   
  \ "coc-translator",   
  \ ]
call coc#add_extension(
  \ 'coc-python',
  \ 'coc-go',
  \ "coc-postfix",   
  \ 'coc-rls',
  \ 'coc-vimlsp',
  \ "coc-docker")  
