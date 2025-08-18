# TODO: 功能迁移对比表

## 已迁移的功能 ✅

| 功能类别 | OLD 配置 | NEW 配置 | 状态 |
|---------|---------|---------|------|
| 核心映射 | `core/mapping.vim` | `lua/config/keymaps.lua` | ✅ 已迁移 |
| LSP | `coc.nvim` | `nvim-lspconfig + blink.cmp` | ✅ 已迁移 |
| 补全 | `coc.nvim` | `blink.cmp` | ✅ 已迁移 |
| 基础设置 | `core/settings.vim` | `lua/config/options.lua` | ✅ 已迁移 |
| 主题配置 | `core/theme.vim` | `lua/plugins/ui.lua` | ✅ 已迁移 |
| 语法高亮 | `nvim-treesitter` | `lua/plugins/treesitter.lua` | ✅ 已迁移 |
| 状态栏 | `lightline.vim` | `lua/plugins/ui.lua` | ✅ 已迁移 |
| 终端 | `vim-floaterm` | `floatty.nvim` | ✅ 已迁移 |
| 文件管理器 | `coc/explorer.vim` | `neo-tree.nvim` (`<C-1>` 切换) | ✅ 已迁移 |
| 撤销树 | `undotree.vim` | `mbbill/undotree` (`<A-3>` 切换) | ✅ 已迁移 |
| Git 集成 | `vim-fugitive.vim` | `tpope/vim-fugitive` (`<A-g>`) | ✅ 已迁移 |
| 注释功能 | `vim-commentary.vim` | `tpope/vim-commentary` (`gc`, `gcc`) | ✅ 已迁移 |
| 快速菜单 | `vim-quickui.vim` | `vim-quickui` (`<M-Enter>`) | ✅ 已迁移 |
| 异步运行 | `asyncrun_vim.vim` | `asyncrun.vim + asynctasks.vim` | ✅ 已迁移 |
| 代码片段 | `coc/snippets.vim` | `honza/vim-snippets`（由 blink.cmp 使用） | ✅ 已迁移 |
| 拖拽可视化 | `dragvisuals.vim` | `jondkinney/dragvisuals.vim`（仅 Visual 模式：← → ↑ ↓，D 复制，自动清理行尾空格） | ✅ 已迁移 |

## 缺失功能需要迁移 ❌

| 功能类别 | OLD 配置文件 | 快捷键/功能 | 优先级 | 状态 |
|---------|-------------|------------|-------|------|
| — | — | — | — | — |

## LSP 功能对照表 🔄

| 功能 | OLD (coc.nvim) | NEW (nvim-lspconfig) | 状态 |
|------|---------------|---------------------|------|
| 跳转定义 | `gd` | `gd` | ✅ |
| 跳转类型定义 | `gy` | `gy` | ✅ |
| 跳转实现 | `gi` | `gi` | ✅ |
| 查找引用 | `gr` | `gr` | ✅ |
| 悬停文档 | `K` | `K` | ✅ |
| 重命名 | `<leader>rn` | `<leader>rn` | ✅ |
| 代码操作 | `<leader>a` | `<leader>a` | ✅ |
| 快速修复 | `gq` | `gq` | ✅ |
| 格式化 | `<leader>f` | `<leader>f` | ✅ |
| 诊断导航 | `g[`, `g]` | `g[`, `g]` | ✅ |
| 浮动诊断 | `<space>e` | `<space>e` | ✅ |
| 诊断列表 | `<space>d` | `<space>d` (Telescope diagnostics) | ✅ 已迁移 |
| 命令列表 | `<space>c` | `<space>c` (Telescope commands) | ✅ 已迁移 |
| 大纲视图 | `<space>o` | `<space>o` (AerialToggle) | ✅ 已迁移 |
| 符号搜索 | `<space>s` | `<space>s` (Telescope document symbols) | ✅ 已迁移 |
| 多光标 | `<C-c>`, `<C-d>` | `<C-d>` 查找下一个, `<C-c>` 跳过当前 (vim-visual-multi) | ✅ 已迁移 |
| 选择范围 | `<C-s>` | `<C-s>` (Treesitter incremental selection) | ✅ 已迁移 |

## 优先级迁移计划 📋

### 高优先级 (立即处理)
1. —

### 中优先级 (近期处理)
1. 翻译功能
2. 剪贴板历史管理
3. 快速导航功能

### 低优先级 (可选处理)
1. 书签管理
2. 代码注释生成
3. 文档预览

## 注意事项 ⚠️

1. Inlay Hints：已加入防抖与错误保护，规避 `col out of range`
2. LSP 重复：优先 `basedpyright`，并禁用/停止 `pyright` 冲突
3. 快捷键：与 `coc.nvim` 主要键位保持一致
4. 插件替代：`neo-tree` 替代 `coc-explorer`；`vim-commentary` 替代注释；`asyncrun/asynctasks` 替代异步任务；`vim-quickui` 提供上下文菜单