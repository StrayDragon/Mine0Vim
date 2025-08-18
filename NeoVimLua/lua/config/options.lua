-- Neovim options configuration - Migrated from core/settings.vim
local opt = vim.opt
local g = vim.g

-- Leader keys
g.mapleader = " "
g.maplocalleader = "\\"

-- File and Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileencodings = "utf-8,gbk,gb18030,gb2312,cp936,ucs-bom,cp936"
opt.fileformats = "unix,dos,mac"

-- Interface
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.signcolumn = "yes:1"
opt.cmdheight = 1
opt.laststatus = 2
opt.showmode = false
opt.showcmd = true
opt.ruler = true
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.pumheight = 10

-- Window behavior
opt.splitbelow = true
opt.splitright = true

-- Tabs and Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance
opt.updatetime = 300
opt.timeoutlen = 500
opt.redrawtime = 10000
opt.ttimeoutlen = 50

-- Editor behavior
opt.backspace = "indent,eol,start"
opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append("c")
opt.whichwrap:append("<,>,[,],h,l")

-- File handling
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true

-- Visual
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.list = false
opt.listchars = "tab:▸ ,trail:·,eol:¬,nbsp:_"

-- Folding
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldlevel = 99

-- Wildignore patterns
opt.wildignore = {
  "*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib",
  "*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex",
  "*.log,*.pyc,*.sqlite,*.sqlite3,*.min.js,*.min.css,*.tags",
  "*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz",
  "*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso",
  "*.pdf,*.dmg,*.app,*.ipa,*.apk,*.mobi,*.epub",
  "*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc",
  "*.ppt,*.pptx,*.doc,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps",
  "*/.git/*,*/.svn/*,*/.DS_Store",
  "*/node_modules/*,*/bower_components/*,*/tmp/*"
}

-- Python providers (avoid loading if not needed)
-- 仅使用配置目录下的 .venv；不回退到系统 Python
vim.g.python_host_prog = ""
vim.g.python3_host_prog = ""

-- Only search from config home (~/.config/nvim/.venv); no env or project fallback
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

-- Node.js provider host detection (neovim-node-host)
-- 仅使用配置目录下的 node_modules；不回退到 PATH
 do
  local cfg = vim.fn.stdpath("config")
  local candidate = nil
  
  -- Try to find neovim package dynamically
  local function find_neovim_cli()
    -- Method 1: Use node to resolve the neovim package path
    local cmd = string.format('cd "%s" && node -p "require.resolve(\\"neovim/package.json\\")" 2>/dev/null', cfg)
    local package_json_path = vim.fn.system(cmd):gsub("%s+$", "")
    
    if vim.v.shell_error == 0 and package_json_path ~= "" then
      local neovim_dir = vim.fn.fnamemodify(package_json_path, ":h")
      local cli_path = neovim_dir .. "/bin/cli.js"
      if vim.fn.filereadable(cli_path) == 1 then
        return cli_path
      end
    end
    
    -- Method 2: Fallback to the .bin shim
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
          string.format("[nvim] 未找到 Node provider。请在 %s 下安装: npm i -D neovim 或 pnpm add -D neovim", cfg),
          vim.log.levels.WARN
        )
      end)
    end
    -- 禁用 Node provider，避免回退到系统 PATH
    vim.g.loaded_node_provider = 0
  end
end

-- Disable some built-in plugins for startup performance
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

-- Terminal colors (migrated from theme.vim)
-- Enable true color support
if vim.fn.empty(vim.env.TMUX) == 1 then
  if vim.fn.has("termguicolors") == 1 then
    opt.termguicolors = true
  end
end

-- Syntax highlighting
vim.cmd.syntax("enable")

-- Set default background
opt.background = "light"

-- GUI specific
if vim.fn.has("gui_running") == 1 then
  opt.guifont = "Monaco:h13"
end

-- Disable mouse for consistent terminal behavior
opt.mouse = ""