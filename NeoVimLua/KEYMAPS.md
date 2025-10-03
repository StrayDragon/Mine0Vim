# Neovim 快捷键参考文档

## 📋 目录
- [基础导航](#基础导航)
- [窗口和标签页管理](#窗口和标签页管理)
- [搜索和文件操作](#搜索和文件操作)
- [LSP 功能](#lsp-功能)
- [FZF-Lua 模糊搜索](#fzf-lua-模糊搜索)
- [Rust 开发](#rust-开发)
- [Git 操作](#git-操作)
- [重构工具](#重构工具)
- [测试](#测试)
- [UI 和工具](#ui-和工具)
- [快速菜单](#快速菜单)
- [多光标模式](#多光标模式)

## 🚀 基础导航

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `j` / `k` | Normal | 上下移动（在 quickui 菜单中也用于导航） |
| `h` / `l` | Normal | 左右移动（在 quickui 菜单中也用于导航） |
| `gd` | Normal | 跳转到定义 |
| `gy` | Normal | 跳转到类型定义 |
| `gi` | Normal | 跳转到实现 |
| `gr` | Normal | 查找引用 |
| `K` | Normal | 显示悬停文档 |
| `g[` / `g]` | Normal | 上一个/下一个诊断 |
| `gq` | Normal | 快速修复（代码操作） |
| `gw` | Normal | 切换窗口 |

## 🪟 窗口和标签页管理

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<Leader>SL` | Normal | 右侧垂直分割 |
| `<Leader>SH` | Normal | 左侧垂直分割 |
| `<Leader>SK` | Normal | 上方水平分割 |
| `<Leader>SJ` | Normal | 下方水平分割 |
| `<Leader>Sr` | Normal | 旋转窗口布局为水平 |
| `<Leader>SR` | Normal | 旋转窗口布局为垂直 |
| `<Leader>S<up>` | Normal | 增加窗口高度 |
| `<Leader>S<down>` | Normal | 减少窗口高度 |
| `<Leader>S<left>` | Normal | 减少窗口宽度 |
| `<Leader>S<right>` | Normal | 增加窗口宽度 |
| `<Leader>TE` | Normal | 新标签页 |
| `<Leader>TH` | Normal | 上一个标签页 |
| `<Leader>TL` | Normal | 下一个标签页 |

## 🔍 搜索和文件操作

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<Leader>y` | Normal | 替换当前单词 |
| `<Leader>Y` | Normal | 复制所有内容到剪贴板 |
| `<RIGHT>` | Normal | 下一个 quickfix 项目 |
| `<RIGHT><RIGHT>` | Normal | 下一个 quickfix 文件 |
| `<LEFT>` | Normal | 上一个 quickfix 项目 |
| `<LEFT><LEFT>` | Normal | 上一个 quickfix 文件 |

## 🔧 LSP 功能

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>rn` | Normal | 重命名符号 |
| `<leader>a` | Normal/Visual | 代码操作 |
| `<leader>f` | Normal/Visual | 格式化代码 |
| `<space>e` | Normal | 显示诊断浮动窗口 |
| `<leader>ui` | Normal | 切换内联提示 |

## 🔎 FZF-Lua 模糊搜索

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>s` | Normal | 文档符号（FZF 悬浮框） |
| `<leader>S` | Normal | 工作区符号（FZF 悬浮框） |
| `<leader>d` | Normal | 缓冲区诊断 |
| `<leader>D` | Normal | 工作区诊断 |
| `<leader>c` | Normal | 命令 |
| `<leader>g` | Normal | 实时搜索 |
| `<leader>f` | Normal | 查找文件 |
| `<leader>b` | Normal | 缓冲区列表 |
| `gd` | Normal | FZF 定义跳转 |
| `gr` | Normal | FZF 引用查找 |
| `gi` | Normal | FZF 实现跳转 |
| `gy` | Normal | FZF 类型定义跳转 |

## 🦀 Rust 开发

### 运行和调试
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>rr` | Normal | Rust 可运行项 |
| `<leader>rR` | Normal | 重新运行上一个 |
| `<leader>dr` | Normal | Rust 可调试项 |
| `<leader>dR` | Normal | 重新调试上一个 |

### 测试
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>tn` | Normal | 测试最近函数 |
| `<leader>tf` | Normal | 测试当前文件 |
| `<leader>ts` | Normal | 测试整个套件 |
| `<leader>tl` | Normal | 重新运行最后测试 |

### 代码操作
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>ca` | Normal | Rust 代码操作（增强版） |
| `<leader>rm` | Normal | 展开宏 |
| `<leader>rM` | Normal | 展开宏递归 |
| `<leader>gs` | Normal | 结构化搜索替换 |
| `<leader>rd` | Normal | 渲染诊断 |
| `<leader>re` | Normal | 解释错误 |
| `<leader>gj` | Normal | 跳转到实现 |
| `<leader>gi` | Normal | 跳转到父模块 |
| `<leader>gk` | Normal | 跳转到父 impl 块 |

### Cargo 管理
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>ct` | Normal | 切换 crate 版本 |
| `<leader>cu` | Normal | 升级 crate |
| `<leader>cA` | Normal | 升级所有 crate |
| `<leader>cr` | Normal | 重新加载 crates |
| `<leader>cg` | Normal | 查看 crate 图 |
| `<leader>cs` | Normal | 查看稳定 Rust 文档 |
| `<leader>cc` | Normal | Cargo 检查运行 |
| `<leader>cC` | Normal | Cargo 检查清除 |
| `<leader>cX` | Normal | Cargo 检查取消 |

### 其他 Rust 功能
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>ra` | Normal | 悬停操作 |
| `<leader>rh` | Normal | 查看类型层次结构 |
| `<leader>ro` | Normal | 打开外部文档 |
| `<leader>rp` | Normal | 查看父模块 |
| `<leader>rhb` | Normal | Rustc HIR（需要 nightly） |
| `<leader>rbm` | Normal | Rustc 机器可读 HIR |
| `<leader>rih` | Normal | Rustc 内联 HIR |
| `<leader>rl` | Normal | 查看日志 |

### QuickUI 菜单中的 Rust 操作（Ctrl+Enter）
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `\rr` | 菜单 | Rust 可运行项 |
| `\rt` | 菜单 | Rust 可测试项 |
| `\rd` | 菜单 | Rust 可调试项 |
| `\ro` | 菜单 | 打开 Cargo.toml |

## 📚 Git 操作

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-g>` | Normal | Git 命令模式 |

## 🔨 重构工具

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<leader>re` | Visual | 提取函数 |
| `<leader>rf` | Visual | 提取到文件 |
| `<leader>rv` | Visual | 提取变量 |
| `<leader>ri` | Normal/Visual | 内联变量 |
| `<leader>rI` | Normal | 内联函数 |
| `<leader>rb` | Normal | 提取代码块 |
| `<leader>rbf` | Normal | 提取代码块到文件 |

### QuickUI 菜单中的重构操作（Ctrl+Enter）
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `\re` | 菜单 | 重构菜单 |
| `\cc` | 菜单 | 注释 |
| `\cyc` | 菜单 | 循环 |

## 🧪 测试

### vim-test
| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-t>` | Normal/Visual | 测试最近函数/选择 |

## 🎨 UI 和工具

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-1>` | Normal | 切换文件浏览器（neo-tree） |
| `<C-3>` | Normal | 切换撤销树 |
| `<C-F12>` | Normal/Terminal | 切换终端 |
| `<C-Enter>` | Normal | 快速菜单（vim-quickui） |
| `<A-Enter>` | Normal | LSP 代码操作（避免冲突） |

### QuickUI 菜单操作（Ctrl+Enter 打开后）

#### 导航 LSP
| 快捷键 | 功能描述 |
|--------|----------|
| `\gd` | 跳转到定义 |
| `\gy` | 跳转到类型定义 |
| `\gi` | 跳转到实现 |
| `\gr` | 查找引用 |

#### 文件操作
| 快捷键 | 功能描述 |
|--------|----------|
| `\c1` | 文件浏览器 |
| `\cf` | 查找文件 |
| `\cg` | 实时搜索 |
| `\cs` | 文档符号 |

#### 代码操作
| 快捷键 | 功能描述 |
|--------|----------|
| `\ca` | 代码操作 |
| `\cr` | 重命名符号 |
| `\cf` | 格式化代码 |
| `\cq` | 快速修复 |

#### 工具和帮助
| 快捷键 | 功能描述 |
|--------|----------|
| `\ch` | 帮助 |
| `\cl` | LSP 信息 |
| `\cm` | 键映射 |
| `\cM` | 显示消息 |

**注意**：在 QuickUI 菜单中，可以使用 `hjkl` 键进行导航，`Enter` 选择，`Esc` 取消。

## 🎯 多光标模式 (vim-visual-multi)

| 快捷键 | 模式 | 功能描述 |
|--------|------|----------|
| `<C-d>` | Normal | 选择下一个匹配项 |
| `<C-c>` | Normal | 跳过当前匹配项 |
| `<C-s>` | Normal | Treesitter 增量选择 |

## 📝 特殊说明

### 键映射前缀
- **Leader**: `<Space>` (空格键)
- **Local Leader**: `\` (反斜杠)

### 冲突解决
- `<C-Enter>`: vim-quickui 上下文菜单
- `<A-Enter>`: LSP 代码操作（避免与 vim-quickui 冲突）
- `hjkl`: 在 vim-quickui 菜单中受保护用于导航

### 模式标识
- **Normal**: 普通模式
- **Visual**: 可视模式
- **Insert**: 插入模式
- **Terminal**: 终端模式

### 上下文相关
- 部分快捷键仅在特定文件类型中可用（如 Rust 特定命令）
- LSP 相关快捷键需要相应的 LSP 服务器运行
- FZF-Lua 功能需要安装 fzf

---

*最后更新: 2025-10-03*