"- WARNING: 取消 s 映射
map s <nop>
"map S :w<CR>
"map Q :q<CR>
"map R :source $MYVIMRC<CR>
"- WARNING: 映射
"  k        i
" h l  ==> j l
"  j        k
"noremap i k
"noremap k j
"noremap j h
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <c-d>
cnoremap <c-b> <left>
cnoremap <c-d> <del>
cnoremap <c-_> <c-k>


nnoremap gw <C-w>w

"- 替换当前单词
nnoremap <Leader>y :%s/<C-r><C-w>/
"- 复制到(全局)剪切板
nnoremap <Leader>Y ggVG"+y<CR><C-o><C-o>

"- 英文拼写检查相关
"-  `z=` 打开建议列表
" nnoremap <Leader>OC :set spell!<CR>
"  - NOTE: need turn on spell(call the above cmd)
" noremap <C-x> ea<C-x>s
" inoremap <C-x> <Esc>ea<C-x>s

"## 窗口管理
"- 分屏(Split)
nnoremap <Leader>SL :set splitright<CR>:vsplit<CR>
nnoremap <Leader>SH :set nosplitright<CR>:vsplit<CR>
nnoremap <Leader>SK :set nosplitbelow<CR>:split<CR>
nnoremap <Leader>SJ :set splitbelow<CR>:split<CR>

"- 调整分屏转换 R: HL->KJ r: KJ->HL
nnoremap <Leader>Sr <C-w>t<C-w>H<Esc>
nnoremap <Leader>SR <C-w>t<C-w>K<Esc>

"- 调整分屏大小
nnoremap <Leader>S<up> :resize +4<CR>
nnoremap <Leader>S<down> :resize -4<CR>
nnoremap <Leader>S<left> :vertical resize -4<CR>
nnoremap <Leader>S<right> :vertical resize +4<CR>

" - 新窗口(Tab)
nnoremap <Leader>TE :tabe<CR>
nnoremap <Leader>TH :tabprevious<CR>
nnoremap <Leader>TL :tabnext<CR>

"- TODO:拼写检查开关
"map <Leader>sc :set spell!<CR>

"- 切换亮/暗主题
" map <Leader>bl :set background=light<CR>
" map <Leader>bd :set background=dark<CR>nnoremap gw <C-w>w

"- 替换当前单词
nnoremap <Leader>y :%s/<C-r><C-w>/
"- 复制到(全局)剪切板
nnoremap <Leader>Y ggVG"+y<CR><C-o><C-o>

"- 英文拼写检查相关
"-  `z=` 打开建议列表
" nnoremap <Leader>OC :set spell!<CR>
"  - NOTE: need turn on spell(call the above cmd)
" noremap <C-x> ea<C-x>s
" inoremap <C-x> <Esc>ea<C-x>s

"## 窗口管理
"- 分屏(Split)
nnoremap <Leader>SL :set splitright<CR>:vsplit<CR>
nnoremap <Leader>SH :set nosplitright<CR>:vsplit<CR>
nnoremap <Leader>SK :set nosplitbelow<CR>:split<CR>
nnoremap <Leader>SJ :set splitbelow<CR>:split<CR>

"- 调整分屏转换 R: HL->KJ r: KJ->HL
nnoremap <Leader>Sr <C-w>t<C-w>H<Esc>
nnoremap <Leader>SR <C-w>t<C-w>K<Esc>

"- 调整分屏大小
nnoremap <Leader>S<up> :resize +4<CR>
nnoremap <Leader>S<down> :resize -4<CR>
nnoremap <Leader>S<left> :vertical resize -4<CR>
nnoremap <Leader>S<right> :vertical resize +4<CR>

" - 新窗口(Tab)
nnoremap <Leader>TE :tabe<CR>
nnoremap <Leader>TH :tabprevious<CR>
nnoremap <Leader>TL :tabnext<CR>

"- TODO:拼写检查开关
"map <Leader>sc :set spell!<CR>

"- 切换亮/暗主题
" map <Leader>bl :set background=light<CR>
" map <Leader>bd :set background=dark<CR>

" # 学会使用帮助
" - 自动补全帮助主题信息
" `:help STRING<TAB>`
" - 模糊匹配帮助信息
" `:helpgrep` PATTERN
"   - `:cnext`/ `:cprev` 所有帮助匹配项下一个/上一个
"   - `:cnfile` / `:cpfile` 所有帮助匹配项以文件为单位上一个/下一个查找
nmap <silent> <RIGHT> :cnext<CR>
nmap <silent> <RIGHT><RIGHT> :cnfile<CR><C-G>
nmap <silent> <LEFT> :cprev<CR>
nmap <silent> <LEFT><LEFT> :cpfile<CR><C-G>
