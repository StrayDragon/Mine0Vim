-- NeoVimLua 键盘映射
-- 从 mapping.vim 迁移

local map = vim.keymap.set
local opt = { noremap = true, silent = true }
local opt_silent = { silent = true }

-- 取消s映射功能
map('n', 's', '<nop>', opt)

-- 命令行移动
map('c', '<c-h>', '<left>', opt)
map('c', '<c-j>', '<down>', opt)
map('c', '<c-k>', '<up>', opt)
map('c', '<c-l>', '<right>', opt)
map('c', '<c-a>', '<home>', opt)
map('c', '<c-e>', '<end>', opt)
map('c', '<c-f>', '<c-d>', opt)
map('c', '<c-b>', '<left>', opt)
map('c', '<c-d>', '<del>', opt)
map('c', '<c-_>', '<c-k>', opt)

-- 窗口切换
map('n', 'gw', '<C-w>w', opt)

-- 替换当前单词
map('n', '<Leader>y', ':%s/<C-r><C-w>/', opt)

-- 复制到全局剪切板
map('n', '<Leader>Y', 'ggVG"+y<CR><C-o><C-o>', opt)

-- 英文拼写检查
-- map('n', '<Leader>sc', ':set spell!<CR>', opt)

-- 窗口管理 - 分屏
map('n', '<Leader>SL', ':set splitright<CR>:vsplit<CR>', opt)
map('n', '<Leader>SH', ':set nosplitright<CR>:vsplit<CR>', opt)
map('n', '<Leader>SK', ':set nosplitbelow<CR>:split<CR>', opt)
map('n', '<Leader>SJ', ':set splitbelow<CR>:split<CR>', opt)

-- 调整分屏转换
map('n', '<Leader>Sr', '<C-w>t<C-w>H<Esc>', opt)
map('n', '<Leader>SR', '<C-w>t<C-w>K<Esc>', opt)

-- 分屏大小调整
map('n', '<Leader>S<up>', ':resize +4<CR>', opt)
map('n', '<Leader>S<down>', ':resize -4<CR>', opt)
map('n', '<Leader>S<left>', ':vertical resize -4<CR>', opt)
map('n', '<Leader>S<right>', ':vertical resize +4<CR>', opt)

-- 标签页管理
map('n', '<Leader>TE', ':tabe<CR>', opt)
map('n', '<Leader>TH', ':tabprevious<CR>', opt)
map('n', '<Leader>TL', ':tabnext<CR>', opt)

-- 帮助信息跳转
map('n', '<RIGHT>', ':cnext<CR>', opt_silent)
map('n', '<RIGHT><RIGHT>', ':cnfile<CR><C-G>', opt_silent)
map('n', '<LEFT>', ':cprev<CR>', opt_silent)
map('n', '<LEFT><LEFT>', ':cpfile<CR><C-G>', opt_silent)

-- 新增: 保存和退出快捷键
map('n', '<Leader>q', ':xa<CR>', opt)             -- 保存所有并退出
map('n', '<Leader>w', ':w<CR>', opt)              -- 保存当前文件

-- 新增: 缓冲区管理
map('n', '<Leader>bd', ':bdelete<CR>', opt)       -- 删除当前buffer
map('n', '<Leader>bn', ':bnext<CR>', opt)         -- 下一个buffer
map('n', '<Leader>bp', ':bprevious<CR>', opt)     -- 上一个buffer
map('n', '<Leader>bc', ':bufdo bd<CR>', opt)      -- 关闭所有buffer

-- 新增: 快速移动
map('n', 'J', '5j', opt)                          -- 向下快速移动
map('n', 'K', '5k', opt)                          -- 向上快速移动
map('v', 'J', '5j', opt)                          -- 可视模式向下移动
map('v', 'K', '5k', opt)                          -- 可视模式向上移动

-- 新增: 代码折叠
map('n', '<Leader>z', 'za', opt)                  -- 折叠/展开当前代码块

-- 新增: 针对Lua的快速重载配置
map('n', '<Leader>R', ':luafile %<CR>', opt)      -- 重载当前lua文件

-- 将插件特定的按键映射保留在各自插件的配置文件中，这里只保留基础映射