-- Rust 文件类型插件，用于增强 rustaceanvim 集成
-- 此文件提供与 rustaceanvim 配合使用的 Rust 专用键位映射和命令

local bufnr = vim.api.nvim_get_current_buf()
local opts = { buffer = bufnr, noremap = true, silent = true, desc = '' }

-- 增强的 LSP 导航（保留现有模式但增加 Rust 增强）
vim.keymap.set('n', 'gd', function()
  -- 优先使用 rustaceanvim 的增强跳转定义，失败则回退到标准 LSP
  local ok, result = pcall(function()
    vim.cmd.RustLsp('gotoLocation')
  end)
  if not ok then
    vim.lsp.buf.definition()
  end
end, vim.tbl_extend('force', opts, { desc = '跳转到定义（增强版）' }))

-- 增强的悬停操作
vim.keymap.set('n', 'K', function()
  -- 在 Rust 文件中使用 rustaceanvim 悬停操作
  vim.cmd.RustLsp { 'hover', 'actions' }
end, vim.tbl_extend('force', opts, { desc = '悬停并显示操作' }))

-- rust-analyzer 诊断的快速修复
vim.keymap.set('n', 'gq', function()
  vim.lsp.buf.code_action({
    context = {
      only = { 'quickfix' },
      diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    },
    apply = true
  })
end, vim.tbl_extend('force', opts, { desc = '快速修复 Rust 问题' }))

-- 增强的重命名，支持 rust-analyzer 智能功能
vim.keymap.set('n', '<leader>rn', function()
  local current_word = vim.fn.expand('<cword>')
  local new_name = vim.fn.input('新名称: ', current_word)
  if new_name and new_name ~= '' and new_name ~= current_word then
    vim.lsp.buf.rename(new_name)
  end
end, vim.tbl_extend('force', opts, { desc = '智能重命名' }))

-- 全面的代码操作
vim.keymap.set({ 'n', 'x' }, '<leader>a', function()
  -- 使用 rustaceanvim 的分组代码操作
  vim.cmd.RustLsp('codeAction')
end, vim.tbl_extend('force', opts, { desc = 'Rust 代码操作（分组）' }))

-- Cargo 专用操作
vim.keymap.set('n', '<leader>cb', function()
  vim.cmd('!cargo build')
end, vim.tbl_extend('force', opts, { desc = 'Cargo 构建' }))

vim.keymap.set('n', '<leader>cr', function()
  vim.cmd('!cargo run')
end, vim.tbl_extend('force', opts, { desc = 'Cargo 运行' }))

vim.keymap.set('n', '<leader>ct', function()
  vim.cmd('!cargo test')
end, vim.tbl_extend('force', opts, { desc = 'Cargo 测试' }))

vim.keymap.set('n', '<leader>cc', function()
  vim.cmd('!cargo check')
end, vim.tbl_extend('force', opts, { desc = 'Cargo 检查' }))

vim.keymap.set('n', '<leader>cq', function()
  vim.cmd('!cargo clippy -- -D warnings')
end, vim.tbl_extend('force', opts, { desc = 'Cargo Clippy 检查' }))

-- 增强的测试集成
vim.keymap.set('n', '<leader>tn', function()
  -- 使用 rustaceanvim 测试最近的函数
  vim.cmd.RustLsp('testables')
end, vim.tbl_extend('force', opts, { desc = '测试最近函数' }))

vim.keymap.set('n', '<leader>tf', function()
  -- 测试当前文件
  vim.cmd('!cargo test -- %')
end, vim.tbl_extend('force', opts, { desc = '测试当前文件' }))

vim.keymap.set('n', '<leader>ts', function()
  -- 测试整个工作区
  vim.cmd('!cargo test')
end, vim.tbl_extend('force', opts, { desc = '测试套件' }))

-- 增强调试快捷键
vim.keymap.set('n', '<leader>db', function()
  -- 调试当前目标
  vim.cmd.RustLsp('debuggables')
end, vim.tbl_extend('force', opts, { desc = '调试目标' }))

-- 文档和帮助
vim.keymap.set('n', '<leader>hd', function()
  -- 打开光标下项目的 docs.rs 文档
  vim.cmd.RustLsp('openDocs')
end, vim.tbl_extend('force', opts, { desc = '打开文档' }))

vim.keymap.set('n', '<leader>hp', function()
  -- 打开父模块
  vim.cmd.RustLsp('parentModule')
end, vim.tbl_extend('force', opts, { desc = '父模块' }))

-- 宏展开
vim.keymap.set('n', '<leader>me', function()
  vim.cmd.RustLsp('expandMacro')
end, vim.tbl_extend('force', opts, { desc = '展开宏' }))

vim.keymap.set('n', '<leader>mr', function()
  vim.cmd.RustLsp('rebuildProcMacros')
end, vim.tbl_extend('force', opts, { desc = '重新构建过程宏' }))

-- 结构化搜索替换 (SSR)
vim.keymap.set('n', '<leader>ss', function()
  local pattern = vim.fn.input('SSR 模式: ')
  if pattern and pattern ~= '' then
    vim.cmd.RustLsp { 'ssr', pattern }
  end
end, vim.tbl_extend('force', opts, { desc = '结构化搜索替换' }))

-- 错误诊断
vim.keymap.set('n', '<leader>ee', function()
  vim.cmd.RustLsp('explainError')
end, vim.tbl_extend('force', opts, { desc = '解释错误' }))

vim.keymap.set('n', '<leader>er', function()
  vim.cmd.RustLsp('renderDiagnostic')
end, vim.tbl_extend('force', opts, { desc = '渲染诊断' }))

-- 增强的工作区符号搜索
vim.keymap.set('n', '<leader>ws', function()
  vim.lsp.buf.workspace_symbol()
end, vim.tbl_extend('force', opts, { desc = '工作区符号' }))

-- Cargo 工作区操作
vim.keymap.set('n', '<leader>wo', function()
  vim.cmd.RustLsp('openCargo')
end, vim.tbl_extend('force', opts, { desc = '打开 Cargo.toml' }))

-- 项目操作
vim.keymap.set('n', '<leader>ju', function()
  vim.cmd.RustLsp { 'moveItem', 'up' }
end, vim.tbl_extend('force', opts, { desc = '向上移动项目' }))

vim.keymap.set('n', '<leader>jd', function()
  vim.cmd.RustLsp { 'moveItem', 'down' }
end, vim.tbl_extend('force', opts, { desc = '向下移动项目' }))

-- 智能连接行
vim.keymap.set('n', '<leader>jl', function()
  vim.cmd.RustLsp('joinLines')
end, vim.tbl_extend('force', opts, { desc = '连接行' }))

-- 可视模式增强
vim.keymap.set('x', '<leader>ss', function()
  local pattern = vim.fn.input('SSR 模式（选择）: ')
  if pattern and pattern ~= '' then
    vim.cmd.RustLsp { 'ssr', pattern }
  end
end, vim.tbl_extend('force', opts, { desc = '在选区上应用 SSR' }))

-- 切换内联提示
vim.keymap.set('n', '<leader>ih', function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, vim.tbl_extend('force', opts, { desc = '切换内联提示' }))

-- 快速状态信息
vim.keymap.set('n', '<leader>st', function()
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
end, vim.tbl_extend('force', opts, { desc = '显示 Rust LSP 状态' }))

-- 增强的诊断导航
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, vim.tbl_extend('force', opts, { desc = '上一个错误' }))

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, vim.tbl_extend('force', opts, { desc = '下一个错误' }))

vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, vim.tbl_extend('force', opts, { desc = '上一个警告' }))

vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, vim.tbl_extend('force', opts, { desc = '下一个警告' }))

-- Crate 图（需要 graphviz）
vim.keymap.set('n', '<leader>cg', function()
  vim.cmd.RustLsp('crateGraph')
end, vim.tbl_extend('force', opts, { desc = '显示 Crate 图' }))

-- 语法树视图
vim.keymap.set('n', '<leader>sy', function()
  vim.cmd.RustLsp('syntaxTree')
end, vim.tbl_extend('force', opts, { desc = '显示语法树' }))

-- Rustc unpretty 命令（需要 nightly 工具链）
vim.keymap.set('n', '<leader>rh', function()
  vim.cmd.Rustc { 'unpretty', 'hir' }
end, vim.tbl_extend('force', opts, { desc = '显示 HIR' }))

vim.keymap.set('n', '<leader>rm', function()
  vim.cmd.Rustc { 'unpretty', 'mir' }
end, vim.tbl_extend('force', opts, { desc = '显示 MIR' }))

print("Rust 文件类型配置已加载")