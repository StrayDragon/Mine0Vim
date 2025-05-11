-- NeoVimLua 自动命令
local api = vim.api

-- 创建自动命令组
local augroup = function(name)
  return api.nvim_create_augroup("NeoVimLua_" .. name, { clear = true })
end

-- 高亮复制内容
api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- 自动恢复上次位置
api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 自动调整窗口大小
api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- 退出插入模式时自动保存
api.nvim_create_autocmd("InsertLeave", {
  group = augroup("auto_save"),
  pattern = "*",
  command = "silent! update",
})

-- 自动切换相对行号
api.nvim_create_autocmd({ "InsertEnter" }, {
  group = augroup("numbertoggle"),
  callback = function()
    if vim.o.number and vim.o.relativenumber then
      vim.o.relativenumber = false
    end
  end,
})

api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
  group = augroup("numbertoggle"),
  callback = function()
    if vim.o.number then
      vim.o.relativenumber = true
    end
  end,
})

-- 自动删除无用空格
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_remove_whitespace"),
  pattern = "*",
  callback = function()
    -- 排除某些文件类型
    local exclude_ft = { "markdown", "text" }
    local ft = vim.bo.filetype
    if not vim.tbl_contains(exclude_ft, ft) then
      local cursor_pos = api.nvim_win_get_cursor(0)
      vim.cmd([[%s/\s\+$//e]])
      api.nvim_win_set_cursor(0, cursor_pos)
    end
  end,
})

-- 大文件处理
api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(ev)
    -- 超过10MB的文件被认为是大文件
    local max_filesize = 10 * 1024 * 1024 -- 10 MB
    local ok, stats = pcall(vim.loop.fs_stat, ev.match)
    if ok and stats and stats.size > max_filesize then
      vim.b[ev.buf].large_file = true

      -- 为大文件禁用某些功能
      vim.opt_local.foldmethod = "manual"  -- 禁用自动折叠
      vim.opt_local.swapfile = false       -- 禁用交换文件
      vim.opt_local.undolevels = -1        -- 禁用撤销
      vim.opt_local.undoreload = 0         -- 禁用撤销重载
      vim.opt_local.syntax = ""            -- 禁用语法高亮

      -- 如果有treesitter，禁用它
      pcall(function()
        vim.cmd("TSBufDisable highlight")
      end)

      vim.notify("大文件已加载，某些功能已禁用", vim.log.levels.WARN)
    end
  end,
})

-- 终端设置
api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_settings"),
  callback = function()
    -- 终端模式下设置
    local opts = { noremap = true, silent = true, buffer = 0 }
    -- 直接进入插入模式
    vim.cmd("startinsert")
    -- 禁用行号
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    -- 设置终端退出快捷键
    vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", opts)
  end,
})

-- 文件类型特定设置
api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "lua" },
  callback = function()
    -- Lua文件的缩进为2个空格
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "python" },
  callback = function()
    -- Python文件的缩进为4个空格
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- 仅针对Markdown文件设置拼写检查
api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_spell"),
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
  end,
})