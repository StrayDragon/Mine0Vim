" Plug 'mhinz/vim-crates'
if has('nvim')
  autocmd BufRead Cargo.toml setlocal spell
  autocmd BufRead Cargo.toml call crates#toggle()
endif
