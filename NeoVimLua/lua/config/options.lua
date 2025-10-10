-- Neovim 基础配置
local opt = vim.opt
local g = vim.g

-- 主键位设置
g.mapleader = " "
g.maplocalleader = "\\"

-- 文件编码设置
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8,gbk,gb18030,gb2312,cp936,ucs-bom,cp936"
opt.fileformats = "unix,dos,mac"

-- 界面显示设置
opt.number = true          -- 显示行号
opt.relativenumber = false -- 不显示相对行号
opt.cursorline = true      -- 高亮当前行
opt.signcolumn = "yes:1"   -- 显示符号列
opt.cmdheight = 1          -- 命令行高度
opt.laststatus = 2         -- 始终显示状态栏
opt.showmode = false       -- 不显示模式（由插件替代）
opt.showcmd = true         -- 显示命令
opt.ruler = true           -- 显示位置信息
opt.wildmenu = true        -- 命令行补全菜单
opt.wildmode = "longest:full,full" -- 补全模式
opt.pumheight = 10         -- 补全菜单最大高度

-- 窗口分割行为
opt.splitbelow = true  -- 水平分割时在下方打开新窗口
opt.splitright = true  -- 垂直分割时在右侧打开新窗口

-- 制表符和缩进
opt.tabstop = 4         -- 制表符宽度
opt.softtabstop = 4     -- 软制表符宽度
opt.shiftwidth = 4      -- 自动缩进宽度
opt.expandtab = true    -- 使用空格替代制表符
opt.autoindent = true   -- 自动缩进
opt.smartindent = true  -- 智能缩进

-- 搜索设置
opt.ignorecase = true   -- 忽略大小写搜索
opt.smartcase = true    -- 智能大小写（有大写字母时区分大小写）
opt.hlsearch = true     -- 高亮搜索结果
opt.incsearch = true    -- 增量搜索

-- 性能和超时设置
opt.updatetime = 300    -- 更新时间（毫秒）
opt.timeoutlen = 500    -- 键映射超时时间
opt.redrawtime = 10000  -- 重绘时间限制
opt.ttimeoutlen = 50    -- 键码超时时间

-- 编辑器行为
opt.backspace = "indent,eol,start"      -- 退格键行为
opt.completeopt = "menu,menuone,noselect" -- 补全选项
opt.shortmess:append("c")                -- 简化补全消息
opt.whichwrap:append("<,>,[,],h,l")      -- 允许跨行移动

-- 文件处理
opt.hidden = true          -- 隐藏缓冲区而不保存
opt.backup = false         -- 不创建备份文件
opt.writebackup = false    -- 不创建写入备份
opt.swapfile = false       -- 不创建交换文件
opt.autoread = true        -- 自动读取文件变化

-- 视觉效果
opt.wrap = false           -- 不自动换行
opt.scrolloff = 8          -- 垂直滚动时保持的行数
opt.sidescrolloff = 8      -- 水平滚动时保持的列数
opt.list = false           -- 不显示隐藏字符
opt.listchars = "tab:▸ ,trail:·,eol:¬,nbsp:_" -- 隐藏字符样式
opt.selection = "exclusive" -- 选择模式

-- 折叠设置
opt.foldenable = true      -- 启用折叠
opt.foldmethod = "indent"  -- 按缩进折叠
opt.foldlevel = 99         -- 默认折叠层级

-- 忽略文件类型（通配符模式）
opt.wildignore = {
  "*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib",                    -- 编译产物
  "*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex", -- 动态库和字节码
  "*.log,*.pyc,*.sqlite,*.sqlite3,*.min.js,*.min.css,*.tags", -- 日志和压缩文件
  "*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz",   -- 压缩文件
  "*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso", -- 图像文件
  "*.pdf,*.dmg,*.app,*.ipa,*.apk,*.mobi,*.epub",           -- 文档和应用
  "*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc",             -- 视频文件
  "*.ppt,*.pptx,*.doc,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps", -- 办公文档
  "*/.git/*,*/.svn/*,*/.DS_Store",                         -- 版本控制文件
  "*/node_modules/*,*/bower_components/*,*/tmp/*"           -- 依赖和临时目录
}

-- Python 提供者配置
-- 仅使用配置目录下的 .venv；不回退到系统 Python
vim.g.python_host_prog = ""
vim.g.python3_host_prog = ""

-- 从配置目录搜索 Python（仅限 ~/.config/nvim/.venv）
 do
  local function is_exe(p)
    return p and p ~= "" and vim.fn.executable(p) == 1
  end
  local cfg = vim.fn.stdpath("config")
  local candidate = nil
  if is_exe(cfg .. "/.venv/bin/python3") then
    candidate = cfg .. "/.venv/bin/python3"
  elseif is_exe(cfg .. "/.venv/bin/python") then
    candidate = cfg .. "/.venv/bin/python"
  end

  if candidate then
    vim.g.python3_host_prog = candidate
  else
    if not vim.g._provider_python_warned then
      vim.g._provider_python_warned = true
      vim.schedule(function()
        vim.notify(
          string.format("[nvim] 未找到 Python provider。请在 %s 下创建并安装: python3 -m venv .venv && %s/.venv/bin/pip install -U pip pynvim", cfg, cfg),
          vim.log.levels.WARN
        )
      end)
    end
    -- 禁用 Python3 provider，避免回退到系统 Python
    vim.g.loaded_python3_provider = 0
  end
end

-- Node.js 提供者检测 (neovim-node-host)
-- 仅使用配置目录下的 node_modules；不回退到 PATH
 do
  local cfg = vim.fn.stdpath("config")
  local candidate = nil
  
  -- 动态查找 neovim 包
  local function find_neovim_cli()
    -- 方法1：使用 node 解析 neovim 包路径
    local cmd = string.format('cd "%s" && node -p "require.resolve(\\"neovim/package.json\\")" 2>/dev/null', cfg)
    local package_json_path = vim.fn.system(cmd):gsub("%s+$", "")

    if vim.v.shell_error == 0 and package_json_path ~= "" then
      local neovim_dir = vim.fn.fnamemodify(package_json_path, ":h")
      local cli_path = neovim_dir .. "/bin/cli.js"
      if vim.fn.filereadable(cli_path) == 1 then
        return cli_path
      end
    end

    -- 方法2：回退到 .bin 命令
    local bin_shim = cfg .. "/node_modules/.bin/neovim-node-host"
    if vim.fn.executable(bin_shim) == 1 then
      return bin_shim
    end

    return nil
  end
  
  candidate = find_neovim_cli()

  if candidate then
    vim.g.node_host_prog = candidate
  else
    if not vim.g._provider_node_warned then
      vim.g._provider_node_warned = true
      vim.schedule(function()
        vim.notify(
          string.format("[nvim] 未找到 Node provider。请在 %s 下安装: npm i neovim 或 pnpm add neovim", cfg),
          vim.log.levels.WARN
        )
      end)
    end
    -- 禁用 Node provider，避免回退到系统 PATH
    vim.g.loaded_node_provider = 0
  end
end

-- 禁用部分内置插件以提升启动性能
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_rrhelper = 1
g.loaded_2html_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- 终端颜色配置
-- 启用真彩色支持
if vim.fn.empty(vim.env.TMUX) == 1 then
  if vim.fn.has("termguicolors") == 1 then
    opt.termguicolors = true
  end
end

-- 语法高亮
vim.cmd.syntax("enable")

-- 设置默认背景
opt.background = "dark"

-- GUI 特定设置
if vim.fn.has("gui_running") == 1 then
  opt.guifont = "Monaco:h13"
end

-- 启用鼠标支持（所有模式）
opt.mouse = "a"  -- 在普通、可视、插入、命令行模式下启用鼠标

-- 浮动窗口外观
opt.winborder = "rounded"  -- 为所有浮动窗口设置圆角边框

-- 文件类型特定的缩进设置
vim.cmd([[
  " Lua 文件：2 空格缩进
  autocmd FileType lua setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " JSON 文件：2 空格缩进
  autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " JSONC 文件：2 空格缩进
  autocmd FileType jsonc setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " YAML 文件：2 空格缩进
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " TOML 文件：2 空格缩进
  autocmd FileType toml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  " 配置文件通用的 2 空格缩进
  autocmd FileType cfg,ini setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
]])
