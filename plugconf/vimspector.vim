let g:vimspector_enable_mappings = 'HUMAN'

" Key	Function	API
" F5	When debugging, continue. Otherwise start debugging.	vimspector#Continue()
" F3	Stop debugging.	vimspector#Stop()
" F4	Restart debugging with the same configuration.	vimspector#Restart()
" F6	Pause debugee.	vimspector#Pause()
" F9	Toggle line breakpoint on the current line.	vimspector#ToggleBreakpoint()
" F8	Add a function breakpoint for the expression under cursor	vimspector#AddFunctionBreakpoint( '<cexpr>' )
" F10	Step Over	vimspector#StepOver()
" F11	Step Into	vimspector#StepInto()
" F12	Step out of current function scope	vimspector#StepOut()

" let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" Key	Function	API
" F5	When debugging, continue. Otherwise start debugging.	vimspector#Continue()
" Shift F5	Stop debugging.	vimspector#Stop()
" Ctrl Shift F5	Restart debugging with the same configuration.	vimspector#Restart()
" F6	Pause debugee.	vimspector#Pause()
" F9	Toggle line breakpoint on the current line.	vimspector#ToggleBreakpoint()
" Shift F9	Add a function breakpoint for the expression under cursor	vimspector#AddFunctionBreakpoint( '<cexpr>' )
" F10	Step Over	vimspector#StepOver()
" F11	Step Into	vimspector#StepInto()
" Shift F11	Step out of current function scope	vimspector#StepOut()

" Customize keymapping
" JetBrains IDEs
" nmap <F9> <Plug>VimspectorContinue
" nmap <A-F9> <Plug>VimspectorStop
" nmap <S-F9> <Plug>VimspectorRestart
" nmap <C-F9> <Plug>VimspectorPause
" nmap <C-F8> <Plug>VimspectorToggleBreakpoint
" nmap <A-F8> <Plug>VimspectorAddFunctionBreakpoint
" nmap <F7> <Plug>VimspectorStepInto
" nmap <F8> <Plug>VimspectorStepOver
" nmap <S-F8> <Plug>VimspectorStepOut
" "nmap <A-F8> evaluate expression

sign define vimspectorBP text=🔴 texthl=Normal
sign define vimspectorBPDisabled text=🔵 texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBad
