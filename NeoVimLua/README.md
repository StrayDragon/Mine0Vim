# NeoVim Lua 配置安装指南

## 🚀 一键安装

```bash
# 1. 备份现有配置
mv ~/.config/nvim ~/.config/nvim.bak

# 2. 克隆配置
git clone https://github.com/your-repo/NeoVimLua.git ~/.config/nvim

# 3. 启动 Neovim
nvim
```

首次启动会自动安装所有插件，请耐心等待。

## 📋 前置要求

- **Neovim**: 0.8+ (推荐最新版)
- **Git**: 用于插件管理
- **Rust** (可选): 用于 Rust 开发
- **Python** (可选): 用于 Python 开发

## 🔧 基本使用

| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 文件浏览器 | `Ctrl+1` | 切换文件树 |
| 模糊搜索 | `Space+f` | 查找文件 |
| 全局搜索 | `Space+g` | 实时搜索 |
| 代码格式化 | `Space+f` | 格式化当前文件 |
| 代码动作 | `Space+a` | 显示代码建议 |
| 跳转定义 | `gd` | 跳转到定义 |
| 查找引用 | `gr` | 查找所有引用 |
| 终端 | `Ctrl+F12` | 切换终端 |

## 🎯 语言开发

### Rust
- 运行: `Space+rr`
- 测试: `Space+tn` (最近函数) / `Space+tf` (当前文件)
- 调试: `Space+dr`

### Python
- 运行: `!python %`
- LSP 会自动启动，提供智能补全

### Lua
- 配置检查: `luafile %`

## 🛠️ 常用操作

| 操作 | 快捷键 |
|------|--------|
| 撤销树 | `Ctrl+3` |
| 注释/取消注释 | `gc` / `gcc` |
| 环绕字符 | `ys"` (双引号) / `ysw"` (单词) |
| 多光标 | `Ctrl+d` (添加下一个) |
| 窗口导航 | `gw` |
| 窗口分割 | `Space+SL` (右) / `Space+SJ` (下) |

## 🔍 故障排除

**插件未安装**: 删除 `~/.config/nvim/lazy-lock.json` 重启

**LSP 不工作**: 检查 `:Mason` 中是否安装对应语言服务器

**配置问题**: 查看 `:messages` 了解错误信息

## 📁 配置结构

```
lua/
├── config/          # 基础配置
│   ├── lazy.lua     # 插件管理器
│   ├── options.lua  # 基本选项
│   └── keymaps.lua  # 键位映射
└── plugins/         # 插件配置
    ├── lsp.lua      # LSP 语言服务
    ├── completion.lua # 代码补全
    ├── ui.lua       # 界面主题
    └── misc.lua     # 其他功能
```

## 💡 自定义

在 `lua/custom/` 目录下创建自己的配置文件，避免修改原配置。

---
