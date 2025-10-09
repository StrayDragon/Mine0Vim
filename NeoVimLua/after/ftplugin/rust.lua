-- Rust 文件类型插件 - 遵循公共优先原则
-- 基础 LSP 键位在 keymaps.lua 中定义，这里只添加 Rust 特定增强功能

local bufnr = vim.api.nvim_get_current_buf()
local opts = { buffer = bufnr, noremap = true, silent = true, desc = '' }

-- === Rust 特定增强功能（不与公共键位冲突）===

-- Rust 增强悬停（覆盖基础 K 键位）
vim.keymap.set('n', 'K', function()
  vim.cmd.RustLsp { 'hover', 'actions' }
end, vim.tbl_extend('force', opts, { desc = 'Rust 增强悬停' }))

-- === Rust 语言工具前缀系统 (<leader>xr) ===
-- 这些键位在全局配置中预留，专门用于 Rust 特定功能

-- Rust 分组代码动作（支持 rust-analyzer 分组功能）
vim.keymap.set({ 'n', 'x' }, '<leader>xra', function()
  vim.cmd.RustLsp('codeAction')
end, vim.tbl_extend('force', opts, { desc = 'Rust 代码动作（分组）' }))

-- 运行和调试
vim.keymap.set('n', '<leader>xrr', function()
  vim.cmd.RustLsp('runnables')
end, vim.tbl_extend('force', opts, { desc = 'Rust 运行/测试' }))

vim.keymap.set('n', '<leader>xrd', function()
  vim.cmd.RustLsp('debuggables')
end, vim.tbl_extend('force', opts, { desc = 'Rust 调试' }))

-- 宏相关
vim.keymap.set('n', '<leader>xrm', function()
  vim.cmd.RustLsp('expandMacro')
end, vim.tbl_extend('force', opts, { desc = 'Rust 展开宏' }))

vim.keymap.set('n', '<leader>xrR', function()
  vim.cmd.RustLsp('rebuildProcMacros')
end, vim.tbl_extend('force', opts, { desc = 'Rust 重建过程宏' }))

-- 错误处理
vim.keymap.set('n', '<leader>xre', function()
  vim.cmd.RustLsp('explainError')
end, vim.tbl_extend('force', opts, { desc = 'Rust 解释错误' }))

vim.keymap.set('n', '<leader>xrE', function()
  vim.cmd.RustLsp('renderDiagnostic')
end, vim.tbl_extend('force', opts, { desc = 'Rust 渲染诊断' }))

-- 文档和导航
vim.keymap.set('n', '<leader>xrh', function()
  vim.cmd.RustLsp('openDocs')
end, vim.tbl_extend('force', opts, { desc = 'Rust 打开文档' }))

vim.keymap.set('n', '<leader>xrp', function()
  vim.cmd.RustLsp('parentModule')
end, vim.tbl_extend('force', opts, { desc = 'Rust 父模块' }))

-- 结构化搜索替换 (SSR)
vim.keymap.set('n', '<leader>xrs', function()
  local pattern = vim.fn.input('SSR 模式: ')
  if pattern and pattern ~= '' then
    vim.cmd.RustLsp { 'ssr', pattern }
  end
end, vim.tbl_extend('force', opts, { desc = 'Rust 结构化搜索替换' }))

vim.keymap.set('x', '<leader>xrs', function()
  local pattern = vim.fn.input('SSR 模式（选择）: ')
  if pattern and pattern ~= '' then
    vim.cmd.RustLsp { 'ssr', pattern }
  end
end, vim.tbl_extend('force', opts, { desc = 'Rust 选区SSR' }))

-- Cargo 操作
vim.keymap.set('n', '<leader>xrc', function()
  vim.cmd.RustLsp('openCargo')
end, vim.tbl_extend('force', opts, { desc = 'Rust 打开 Cargo.toml' }))

-- 代码重构
vim.keymap.set('n', '<leader>xru', function()
  vim.cmd.RustLsp { 'moveItem', 'up' }
end, vim.tbl_extend('force', opts, { desc = 'Rust 向上移动项目' }))

vim.keymap.set('n', '<leader>xrD', function()
  vim.cmd.RustLsp { 'moveItem', 'down' }
end, vim.tbl_extend('force', opts, { desc = 'Rust 向下移动项目' }))

vim.keymap.set('n', '<leader>xrj', function()
  vim.cmd.RustLsp('joinLines')
end, vim.tbl_extend('force', opts, { desc = 'Rust 连接行' }))

-- 高级功能
vim.keymap.set('n', '<leader>xrg', function()
  vim.cmd.RustLsp('crateGraph')
end, vim.tbl_extend('force', opts, { desc = 'Rust Crate 图' }))

vim.keymap.set('n', '<leader>xrt', function()
  vim.cmd.RustLsp('syntaxTree')
end, vim.tbl_extend('force', opts, { desc = 'Rust 语法树' }))

-- === 状态检查 ===
vim.keymap.set('n', '<leader>xr?', function()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local rustacean_found = false
  for _, client in ipairs(clients) do
    if client.name == 'rust-analyzer' then
      rustacean_found = true
      break
    end
  end

  if rustacean_found then
    print("✓ rust-analyzer 活跃")
  else
    print("✗ rust-analyzer 未运行")
  end
end, vim.tbl_extend('force', opts, { desc = 'Rust 状态检查' }))

print("Rust 文件类型配置已加载（公共优先原则）")