augroup InitFileTypesGroup
	au!
	au FileType c,cpp setlocal commentstring=//\ %s
	au FileType markdown setlocal wrap
	au FileType lisp setlocal ts=8 sts=2 sw=2 et
	au FileType scala setlocal sts=4 sw=4 noet
	au FileType haskell setlocal et
	au FileType qf setlocal nonumber
	au BufNewFile,BufRead *.as setlocal filetype=actionscript
	au BufNewFile,BufRead *.pro setlocal filetype=prolog
	au BufNewFile,BufRead *.es setlocal filetype=erlang
	au BufNewFile,BufRead *.asc setlocal filetype=asciidoc
	au BufNewFile,BufRead *.vl setlocal filetype=verilog
augroup END
