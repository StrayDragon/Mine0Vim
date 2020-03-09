" Plug 'numirias/semshi'
if has('nvim')
let g:semshi#mark_selected_nodes = 0
let g:semshi#simplify_markup = v:false
let g:semshi#error_sign =  v:false
let g:semshi#excluded_hl_groups = ['local', 'unresolved', 'global', 'free', 'attribute']

function CustomDarculeHighlightsWithSemshiForPython()
    " see: https://jonasjacek.github.io/colors/
    " Builtin: MediumPurple3
    hi semshiBuiltin         ctermfg=98 guifg=#8888c6
    " Self: Magenta2
    hi semshiSelf            ctermfg=200 guifg=#94558d
    " Parameter: Silver
    hi semshiParameter       ctermfg=61 guifg=#A9B7C6 cterm=italic gui=italic 
    hi semshiParameterUnused ctermfg=63 guifg=#9e9e9e cterm=underline gui=underline
    hi semshiImported        ctermfg=214 guifg=#d7af00 cterm=bold gui=bold

    hi semshiGlobal          ctermfg=214 guifg=#ffaf00
    " hi semshiAttribute       ctermfg=49  guifg=#00ffaf
    " hi semshiFree            ctermfg=218 guifg=#ffafd7
    " hi semshiUnresolved      ctermfg=226 guifg=#ffff00 cterm=underline gui=underline
    " hi semshiLocal           ctermfg=209 guifg=#ff875f
    " hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f
    " hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    " hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    " sign define semshiError text=E> texthl=semshiErrorSign
    hi! link pythonDecoratorName Define
endfunction
autocmd FileType python call CustomDarculeHighlightsWithSemshiForPython()

endif
