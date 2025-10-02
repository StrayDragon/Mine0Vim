# 跨语言统一快捷键配置

## 🎯 已实现的统一快捷键

您的配置已经实现了跨语言的统一快捷键，可以在 Python、Lua、Rust 等语言中使用相同的操作：

### 📝 基础 LSP 操作
- `<leader>rn` - **重命名符号** (所有语言通用)
- `<leader>a` - **代码动作** (所有语言通用)
- `<leader>f` - **格式化代码** (所有语言通用)
- `gd` - **跳转到定义** (所有语言通用)
- `gy` - **跳转到类型定义** (所有语言通用)
- `gi` - **跳转到实现** (所有语言通用)
- `gr` - **查找引用** (所有语言通用)
- `K` - **悬停文档** (所有语言通用)

### 🔍 诊断导航
- `g[` - **上一个诊断** (所有语言通用)
- `g]` - **下一个诊断** (所有语言通用)
- `<space>e` - **浮动诊断窗口** (所有语言通用)

## 🦀 Rust 增强功能

Rust 有额外的专用快捷键，但不影响基础功能：

### Rust 专用增强
- `<leader>ca` - **Rust 代码动作** (分组支持，增强版)
- `<leader>ra` - **执行悬停操作** (快速访问)
- `<leader>gs` - **结构化搜索替换** (SSR)
- `<leader>rr` - **Rust 运行目标选择器**
- `<leader>dr` - **Rust 调试目标选择器**
- `<leader>tn` - **测试最近函数**

## 🐍 Python 特定功能

由 basedpyright 提供支持：
- **内联提示**: 自动显示变量类型和函数返回类型
- **类型检查**: 实时类型诊断和错误提示
- **导入建议**: 自动导入和排序

## 🔧 配置原理

### 统一配置机制
```lua
-- lsp.lua 中的通用 LSP 配置
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- 这些快捷键对所有支持的语言都生效
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({'n', 'x'}, '<leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set({'n', 'x'}, '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  -- ... 更多通用映射
end
```

### 语言特定增强
```lua
-- misc.lua 中的 Rust 专用增强
-- 只添加 Rust 特有的功能，不重复通用功能
vim.keymap.set('n', '<leader>ca', function()
  vim.cmd.RustLsp('codeAction')  -- Rust 增强版代码动作
end, opts)
```

## 🚀 使用示例

### 重命名操作 (跨语言)
```bash
# 在任何支持的语言文件中：
# 1. 将光标放在要重命名的符号上
# 2. 按 <leader>rn
# 3. 输入新名称
# 4. 按 Enter 确认

# Python: 重命名变量、函数、类
# Rust: 重命名变量、函数、结构体、枚举
# Lua: 重命名变量、函数
```

### 代码动作 (跨语言)
```bash
# 在任何支持的语言文件中：
# 1. 将光标放在有问题的代码上
# 2. 按 <leader>a
# 3. 选择建议的修复动作

# Python: 导入缺失模块、修复语法错误
# Rust: 实现接口、导入模块、修复错误
# Lua: 修复语法问题、代码建议
```

### 格式化 (跨语言)
```bash
# 在任何支持的语言文件中：
# 1. 按 <leader>f 格式化当前文件
# 2. 或在可视模式下选择代码后按 <leader>f 格式化选中部分

# Python: 使用 black 或 autopep8
# Rust: 使用 rustfmt
# Lua: 使用 stylua
```

## 📋 支持的语言

### ✅ 完全支持
- **Python**: basedpyright (高级功能)
- **Rust**: rust-analyzer + rustaceanvim (完整功能)
- **Lua**: lua_ls (基础功能)

### 🔄 易于扩展
如需添加其他语言，只需在 `lua/plugins/lsp.lua` 中添加相应的 LSP 配置：

```lua
-- 示例：添加 TypeScript 支持
lsp_configs.tsserver = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript" },
  capabilities = capabilities,
  on_attach = on_attach,  -- 自动获得所有统一快捷键
}
```

## 🎨 最佳实践

1. **记忆统一快捷键**: 只需记住一套快捷键即可在所有语言中使用
2. **语言特定功能**: 每种语言可能有额外的专用功能，但基础操作保持一致
3. **渐进式学习**: 先掌握统一的基础功能，再学习特定语言的增强功能

这样的设计确保了您在不同语言项目中切换时，核心开发体验保持完全一致。