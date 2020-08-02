let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

command! -nargs=1 Mine0vimLoadScript exec 'so '.s:home.'/'.'<args>'

if !exists(":Mine0vimDiffOrig")
  command Mine0vimDiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif
