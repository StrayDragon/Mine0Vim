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

### Common Key Bindings
```bash
<leader>f        # Format code
<leader>a        # Code actions
gq               # Quick fix
gd               # Go to definition
gr               # Find references
K                # Hover documentation
<leader>         # Show all keybindings (Which-Key)
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

### Which-Key Integration
- Intelligent key mapping discovery system
- Auto-detects existing keybindings without manual maintenance
- Categorized display with filtering
- Statistics and refresh capabilities

### Performance Optimizations
- Lazy loading for non-essential plugins
- Debounced inlay hints and diagnostics
- Optimized completion system
- Buffer-based limits for large files

### Debug Support
- Multi-debugger support (codelldb, lldb-vscode)
- Integrated with rustaceanvim for Rust
- Debug adapter protocol configuration

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