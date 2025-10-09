# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modern Neovim configuration migrated from vim-plug to lazy.nvim, written in Lua. It provides a complete development environment with LSP support, intelligent completion, and productivity plugins. The configuration emphasizes performance optimization and includes specialized support for Python, Lua, and Rust development.

## Configuration Architecture

### Entry Points
- `init.lua` - Bridge entry point with graceful error handling
- `lua/init.lua` - Main configuration bootstrap

### Core Structure
```
lua/
├── config/           # Core Neovim settings
│   ├── lazy.lua      # lazy.nvim bootstrap
│   ├── options.lua   # Vim options and editor settings
│   ├── keymaps.lua   # Global key mappings
│   └── dap.lua       # Debug Adapter Protocol
└── plugins/          # Plugin configurations
    ├── completion.lua # blink.cmp completion
    ├── lsp.lua       # LSP + mason configuration
    ├── treesitter.lua # Syntax highlighting
    ├── ui.lua        # UI plugins
    ├── rust.lua      # Rust development
    ├── buffer.lua    # Buffer management
    ├── files.lua     # File navigation
    ├── misc.lua      # Git, terminal, utilities
    ├── format.lua    # Code formatting
    ├── lint.lua      # Linting
    └── which-key.lua # Intelligent key mapping discovery
```

### Plugin System
Uses **lazy.nvim** with:
- Lazy loading for performance optimization
- Auto-installation on first run
- Module-based plugin organization
- Health checking and monitoring

## Key Development Commands

### Plugin Management
```bash
:Lazy update     # Update plugins
:Lazy clean      # Clean unused plugins
:Lazy install    # Install missing plugins
:Lazy health     # Check plugin health
```

### LSP Management
```bash
:Mason           # LSP installer
:LspInfo         # LSP information
:Telescope diagnostics # Show diagnostics
```

### Language Tools Status
```bash
:LangTools       # Show available language-specific tools
```

### Key Binding System

#### 基础LSP键位（跨编辑器通用）
这些键位在所有支持LSP的编辑器中保持一致，减少学习成本：

```bash
gd               # 跳转到定义
gr               # 查找引用
gi               # 跳转到实现
gy               # 跳转到类型定义
K                # 悬停帮助
gq               # 快速修复
<leader>ca       # 代码动作
<leader>rn       # 重命名
<leader>f        # 格式化
<leader>ws       # 工作区符号
```

#### 语言特定前缀系统
```bash
<leader>xr       # Rust 工具
<leader>xp       # Python 工具
<leader>xg       # Go 工具
<leader>xl       # Lua 工具
<leader>xc       # C/C++ 工具
<leader>xa       # 通用工具
```

#### Rust 示例（使用新前缀系统）
```bash
<leader>xra      # Rust 代码动作
<leader>xrb      # Cargo 构建
<leader>xrt      # Cargo 测试
<leader>xre      # Cargo 运行
<leader>xrd      # Rust 调试
<leader>xrm      # 宏展开
```

#### 常用键位
```bash
<leader>f        # 格式化代码（所有语言）
<leader>ca       # 代码动作（所有语言）
<leader>         # 显示所有键绑定（Which-Key）
```

## Language Support

### Python
- **LSP**: basedpyright with enhanced diagnostics
- **Features**: Type hints, auto-imports, workspace analysis

### Lua
- **LSP**: lua_ls with Neovim-specific configuration
- **Features**: Vim globals, runtime files, performance optimized

### Rust (Comprehensive)
- **LSP**: rust-analyzer via rustaceanvim
- **Tools**: crates.nvim for dependency management
- **Features**: Advanced code actions, testing, debugging, macro expansion

## Key Features

### Simplified Key Binding System
- **基础LSP键位**：跨编辑器通用的标准键位 (gd, gr, gi, K, gq, <leader>ca, <leader>rn, <leader>f)
- **语言分层前缀**：`<leader>x{lang}` 系统避免冲突，支持发现式学习
- **Which-Key集成**：自动发现和展示键位映射，无需手动维护
- **清晰分组**：按功能和语言分组，降低记忆负担

### Performance Optimizations
- Lazy loading for non-essential plugins
- Debounced inlay hints and diagnostics
- Optimized completion system
- Buffer-based limits for large files
- 移除了过度复杂的智能路由系统，提升启动性能

### Debug Support
- Multi-debugger support (codelldb, lldb-vscode)
- Integrated with rustaceanvim for Rust
- Debug adapter protocol configuration
- 使用 `<leader>D` 前缀避免与诊断键位冲突

## Important Implementation Details

### LSP Configuration
- Uses Neovim 0.11+ `vim.lsp.config` API
- Automatic server installation via mason.nvim
- UTF-8 position encoding consistency
- Advanced inlay hint management

### Code Patterns
- Modular organization by functionality
- Preservation of legacy coc.nvim keybindings
- Comprehensive error handling
- Automatic plugin installation

## Testing & Validation

Compatible with:
- Neovim 0.11+ (latest stable)
- Python, Lua, Rust development environments
- Performance optimized for large codebases

## Common Issues

### Installation
- Delete `lazy-lock.json` and restart if plugins fail to install
- Use `:Lazy health` and `:Mason` for troubleshooting
- Check `:messages` for error details

### Performance
- Monitor with `:BlinkStats`
- Disable unused plugins if startup is slow
- Adjust lazy loading settings as needed