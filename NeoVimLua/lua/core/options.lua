-- NeoVimLua 基本设置
-- 从 settings.vim 迁移

local opt = vim.opt
local g = vim.g
local fn = vim.fn

-- Leader 键
g.mapleader = ','
g.maplocalleader = ' '

-- 基础设置
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

opt.autochdir = false      -- 不自动改变工作目录
opt.wildmenu = true        -- 命令行补全菜单
opt.backup = false         -- 不创建备份文件
opt.writebackup = false    -- 不创建写入备份
opt.swapfile = false       -- 不创建交换文件
opt.autoread = true        -- 自动读取修改
opt.autowrite = true       -- 自动保存
opt.confirm = true         -- 确认保存对话框
opt.splitbelow = true      -- 在下方打开新窗口
opt.mouse = 'a'            -- 启用鼠标
opt.encoding = 'UTF-8'     -- 编码设置
opt.laststatus = 2         -- 总是显示状态栏
opt.showtabline = 2        -- 总是显示标签栏
opt.scrolloff = 4          -- 滚动时距离顶/底部保持4行
opt.history = 2000         -- 历史命令数量

-- 复制粘贴联通系统粘贴板
opt.clipboard = 'unnamedplus'

-- 界面设置
opt.number = true          -- 显示行号
opt.signcolumn = 'yes'     -- 总是显示符号列
opt.showmode = false       -- 不显示模式，由插件替代
opt.shortmess:append('c')  -- 减少一些消息提示
opt.termguicolors = true   -- 启用终端真彩色
opt.guifont = 'JetbrainsMono NF:h14'  -- GUI字体

-- 超时和更新
opt.timeout = true
opt.ttimeout = true
opt.timeoutlen = 500
opt.updatetime = 100

-- 如果在Tmux中则设置ttimeoutlen为30
if os.getenv("TMUX") ~= nil then
    opt.ttimeoutlen = 30
elseif (opt.ttimeoutlen:get() > 80 or opt.ttimeoutlen:get() <= 0) then
    opt.ttimeoutlen = 80
end

-- 缩进和制表符
opt.expandtab = true       -- 空格替代制表符
opt.tabstop = 2            -- Tab宽度
opt.softtabstop = 2        -- 软制表符宽度
opt.shiftwidth = 2         -- 自动缩进宽度
opt.smarttab = true        -- 智能制表符
opt.autoindent = true      -- 自动缩进
opt.smartindent = true     -- 智能缩进
opt.shiftround = true      -- 缩进到shiftwidth的倍数

-- 撤销设置
opt.undofile = true        -- 持久撤销
-- 创建撤销目录如果不存在
local undodir = os.getenv("HOME") .. "/.tmp/undo"
local handle = io.popen("mkdir -p " .. undodir)
if handle then
    handle:close()
end
opt.undodir = undodir      -- 撤销文件目录

-- 搜索设置
opt.ignorecase = true      -- 搜索忽略大小写
opt.smartcase = true       -- 搜索智能大小写
opt.infercase = true       -- 补全智能大小写
opt.incsearch = true       -- 增量搜索
opt.hlsearch = true        -- 高亮搜索结果
opt.inccommand = 'nosplit' -- 实时显示搜索替换

-- 清除搜索高亮
vim.cmd('nohlsearch')

-- 行为设置
opt.hidden = true          -- 允许切换未保存的缓冲区
opt.wrap = true            -- 折行
opt.wrapscan = true        -- 搜索时循环
opt.linebreak = true       -- 按单词折行
opt.backspace = 'indent,eol,start'  -- 退格键行为
opt.textwidth = 200        -- 文本宽度

-- 匹配项设置
opt.showmatch = true       -- 括号匹配高亮
opt.matchpairs:append('<:>')  -- 匹配尖括号
opt.matchtime = 1          -- 匹配显示时间
vim.cmd('set cpoptions-=m') -- 匹配在插入模式下可见

-- grep 程序设置
opt.grepprg = "rg --vimgrep $*"

-- 忽略文件设置 (从vim转为lua的简化处理)
local wildignore = {
    "*.o", "*.obj", "*~", "*.exe", "*.a", "*.pdb", "*.lib",
    "*.so", "*.dll", "*.swp", "*.egg", "*.jar", "*.class", "*.pyc", "*.pyo", "*.bin", "*.dex",
    "*.zip", "*.7z", "*.rar", "*.gz", "*.tar", "*.gzip", "*.bz2", "*.tgz", "*.xz",
    "*DS_Store*", "*.ipch",
    "*.gem",
    "*.png", "*.jpg", "*.gif", "*.bmp", "*.tga", "*.pcx", "*.ppm", "*.img", "*.iso",
    "*.pdf", "*.dmg", "*/.rbenv/**",
    "*/.nx/**", "*.app", "*.git", ".git",
    "*.wav", "*.mp3", "*.ogg", "*.pcm",
    "*.mht", "*.suo", "*.sdf", "*.jnlp",
    "*.chm", "*.epub", "*.pdf", "*.mobi", "*.ttf",
    "*.mp4", "*.avi", "*.flv", "*.mov", "*.mkv", "*.swf", "*.swc",
    "*.ppt", "*.pptx", "*.docx", "*.xlt", "*.xls", "*.xlsx", "*.odt", "*.wps",
    "*.msi", "*.crx", "*.deb", "*.vfd", "*.apk", "*.ipa", "*.bin", "*.msu",
    "*.gba", "*.sfc", "*.078", "*.nds", "*.smd", "*.smc",
    "*.linux2", "*.win32", "*.darwin", "*.freebsd", "*.linux", "*.android"
}

opt.wildignore = table.concat(wildignore, ',')

-- 折叠设置
if fn.has('folding') == 1 then
    opt.foldenable = true       -- 启用折叠
    opt.foldmethod = 'syntax'   -- 语法折叠
    opt.foldlevelstart = 99     -- 默认展开所有折叠
end

-- 隐藏标记设置
if fn.has('conceal') == 1 then
    opt.conceallevel = 0
    opt.concealcursor = 'niv'
end

-- Mac 特定设置
if fn.has('mac') == 1 then
    opt.guicursor = ''
    -- 解决一些插件设置guicursor的问题
    vim.cmd('autocmd OptionSet guicursor noautocmd set guicursor=')
end