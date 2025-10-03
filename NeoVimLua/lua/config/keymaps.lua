-- 键位映射配置
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 取消 s 和 S 映射以避免与 leader+s 和 leader+S 冲突
map({"n","x","o"}, "s", "<nop>")
map({"n","x","o"}, "S", "<nop>")

-- 命令行导航键位
vim.cmd([[
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
]])

-- 窗口切换
map('n', 'gw', '<C-w>w', opts)

-- 替换当前单词
map('n', '<Leader>y', [[:%s/<C-r><C-w>/]], { noremap = true })
-- 复制所有内容到系统剪贴板
map('n', '<Leader>Y', [[ggVG"+y<CR><C-o><C-o>]], { noremap = true, silent = true })

-- 窗口分割
map('n', '<Leader>SL', ':set splitright<CR>:vsplit<CR>', { noremap = true })  -- 右侧垂直分割
map('n', '<Leader>SH', ':set nosplitright<CR>:vsplit<CR>', { noremap = true }) -- 左侧垂直分割
map('n', '<Leader>SK', ':set nosplitbelow<CR>:split<CR>', { noremap = true }) -- 上方水平分割
map('n', '<Leader>SJ', ':set splitbelow<CR>:split<CR>', { noremap = true })   -- 下方水平分割

-- 移动分割布局
map('n', '<Leader>Sr', '<C-w>t<C-w>H<Esc>', { noremap = true })  -- 水平转垂直
map('n', '<Leader>SR', '<C-w>t<C-w>K<Esc>', { noremap = true })  -- 垂直转水平

-- 调整窗口大小
map('n', '<Leader>S<up>', ':resize +4<CR>', { noremap = true })      -- 增加高度
map('n', '<Leader>S<down>', ':resize -4<CR>', { noremap = true })    -- 减少高度
map('n', '<Leader>S<left>', ':vertical resize -4<CR>', { noremap = true }) -- 减少宽度
map('n', '<Leader>S<right>', ':vertical resize +4<CR>', { noremap = true }) -- 增加宽度

-- 标签页操作
map('n', '<Leader>TE', ':tabe<CR>', { noremap = true })       -- 新建标签页
map('n', '<Leader>TH', ':tabprevious<CR>', { noremap = true }) -- 上一个标签页
map('n', '<Leader>TL', ':tabnext<CR>', { noremap = true })    -- 下一个标签页

-- 使用方向键导航 quickfix 列表
map('n', '<RIGHT>', ':cnext<CR>', { silent = true })          -- 下一个 quickfix 项目
map('n', '<RIGHT><RIGHT>', ':cnfile<CR><C-G>', { silent = true }) -- 下一个文件
map('n', '<LEFT>', ':cprev<CR>', { silent = true })           -- 上一个 quickfix 项目
map('n', '<LEFT><LEFT>', ':cpfile<CR><C-G>', { silent = true })   -- 上一个文件

-- 切换内联提示
vim.keymap.set('n', '<leader>ui', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = false
  if vim.lsp.inlay_hint then
    if vim.lsp.inlay_hint.is_enabled then
      -- 尝试两种 is_enabled 签名
      local ok, val = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
      if not ok then
        ok, val = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
      end
      if ok then enabled = val end
    end
    if enabled then
      -- 尝试新API: enable(bufnr, false); 回退到旧API: enable(false, {bufnr=})
      local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, false)
      if not ok then pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr }) end
    else
      local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, true)
      if not ok then pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr }) end
    end
  end
end, { desc = '切换内联提示' })

-- 快速修复（代码动作），类似 coc.nvim 的 gq 映射
vim.keymap.set('n', 'gq', function()
  -- 优先使用光标位置的快速修复代码动作
  vim.lsp.buf.code_action({
    context = { only = { 'quickfix' } },
  })
end, { noremap = true, silent = true, desc = 'LSP 快速修复（代码动作）' })

-- 终端导航：使用 Esc 退出终端模式
vim.cmd([[
  " 使用 Esc 退出终端模式（类似 Vim）
  tnoremap <Esc> <C-\><C-N>
]])
