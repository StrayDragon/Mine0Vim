"- jsonc
syn region  jsoncLineComment    start=+\/\/+ end=+$+ keepend
syn region  jsoncLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend fold
syn region  jsoncComment        start="/\*"  end="\*/" fold
hi def link jsoncLineComment        Comment
autocmd FileType json syntax match Comment +\/\/.\+$+
