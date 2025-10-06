# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modern Neovim configuration migrated from vim-plug to lazy.nvim, written in Lua. The configuration is designed to be a drop-in replacement for ~/.config/nvim and provides a complete development environment with LSP support, completion, syntax highlighting, and various productivity plugins.

## Configuration Architecture

### Entry Points
- `init.lua` - Bridge entry point that loads lua/init.lua (handles errors gracefully)
- `lua/init.lua` - Main configuration bootstrap that loads all modules

### Core Structure
```
lua/
├── config/           # Core Neovim settings
│   ├── lazy.lua      # lazy.nvim bootstrap and setup
│   ├── options.lua   # Vim options (migrated from core/settings.vim)
│   └── keymaps.lua   # Key mappings (migrated from core/mapping.vim)
└── plugins/          # Plugin configurations organized by function
    ├── completion.lua # blink.cmp completion engine
    ├── lsp.lua       # LSP + mason configuration
    ├── treesitter.lua # Syntax highlighting
    ├── ui.lua        # UI plugins (themes, status line, file explorer)
    └── misc.lua      # Other utilities (git, terminal, etc.)
```

### Plugin System
Uses **lazy.nvim** as the plugin manager with:
- Lazy loading for performance
- Auto-installation on first run
- Plugin health checking
- Module-based plugin organization

## Key Development Commands

### Plugin Management
```bash
# Update all plugins (run from within Neovim)
:Lazy update

# Clean unused plugins
:Lazy clean

# Install missing plugins
:Lazy install

# Check plugin health
:Lazy health
```

### LSP Management
```bash
# Open LSP installer (Mason)
:Mason

# Install LSP server manually
:MasonInstall basedpyright
:MasonInstall lua_ls

# LSP information and diagnostics
:LspInfo
:Telescope diagnostics
```

### Common Development Tasks
```bash
# Format current buffer
<leader>f

# Show available LSP code actions
<leader>a

# Quick fix
gq

# Navigate diagnostics
g[ (previous), g] (next)

# Toggle floating diagnostics
<space>e

# Show command palette
<space>c

# Show document symbols
<space>s

# Toggle outline/aerial view
<space>o
```

## LSP Configuration

### Supported Languages
- **Python**: basedpyright (auto-installed) with inlay hints
- **Lua**: lua_ls (auto-installed)
- **Rust**: rust-analyzer (auto-installed) with comprehensive Rust support

### Key Bindings (Preserved from coc.nvim)
- `gd` - Go to definition
- `gy` - Go to type definition
- `gi` - Go to implementation
- `gr` - Find references
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>a` - Code actions
- `gq` - Quick fix
- `<leader>f` - Format code

### Rust-Specific Key Bindings
- `<leader>ca` - Rust Code Actions (enhanced)
- `<leader>rr` - Run Rust runnables
- `<leader>dr` - Debug Rust targets
- `<leader>rm` - Expand macro at cursor
- `<leader>rs` - Structural Search Replace
- `<leader>rd` - Render diagnostic
- `<leader>re` - Explain error
- `<leader>ct` - Toggle crate versions
- `<leader>cu` - Upgrade crate
- `<leader>cA` - Upgrade all crates
- `<leader>cr` - Reload crates
- `<leader>tn` - Test nearest function
- `<leader>tf` - Test current file
- `<leader>ts` - Test entire suite
- `<leader>tl` - Re-run last test

## Plugin Ecosystem

### Core Replacements (Migration Map)
| Old Plugin | New Replacement | Purpose |
|------------|----------------|---------|
| coc.nvim | nvim-lspconfig + blink.cmp | LSP + completion |
| vim-floaterm | floatty.nvim | Floating terminal |
| coc/explorer | neo-tree.nvim | File explorer (`<C-1>`) |
| vim-commentary | vim-commentary | Comments (`gc`, `gcc`) |
| vim-fugitive | vim-fugitive | Git integration (`<A-g>`) |
| asyncrun_vim | asyncrun.vim + asynctasks.vim | Async tasks |

### UI Configuration
- **Theme**: PaperColor (light) / edge (dark)
- **Status Line**: lightline.vim
- **File Explorer**: neo-tree.nvim (toggle with `<A-1>`)
- **Undo Tree**: undotree (toggle with `<A-3>`)

### Rust Development Tools
- **rustaceanvim**: Comprehensive Rust development environment with rust-analyzer integration
- **crates.nvim**: Cargo.toml dependency management with completion and version info
- **vim-test**: Integrated test runner for Rust projects
- **Rust-specific features**:
  - Enhanced code actions and quick fixes
  - Macro expansion and debugging
  - Structural Search Replace (SSR)
  - Crate version management and updates
  - Integrated testing with cargo
  - Debug configuration with lldb-vscode

## Important Implementation Details

### LSP Setup
- Uses **mason.nvim** for LSP server management
- **blink.cmp** for completion with snippet support
- Automatic LSP server installation for lua_ls, basedpyright, and rust_analyzer
- UTF-8 position encoding to avoid mixed encoding warnings
- Inlay hints with debouncing and error protection

### Rust-Specific LSP Configuration
- **rust-analyzer** with comprehensive settings:
  - Cargo integration with all features enabled
  - Clippy integration for enhanced diagnostics
  - Inlay hints for lifetime elision, parameter types, and chaining
  - Macro expansion support
  - Code actions for common Rust patterns
  - Lens features for implementations, references, and runnables
  - Enhanced completion with postfix snippets

### Performance Considerations
- Lazy loading for all non-essential plugins
- Debounced inlay hints (300ms delay) with error handling
- Optimized plugin loading order to prevent conflicts
- UTF-8 position encoding consistency across LSP clients

### Configuration Patterns
- Modular plugin organization by function
- Preservation of legacy coc.nvim keybindings for migration compatibility
- Error handling in bootstrap (init.lua)
- Automatic plugin installation on first launch

## File Management

### Navigation Shortcuts
- `<A-1>` - Toggle neo-tree file explorer
- `<A-3>` - Toggle undotree
- `<A-7>` - Toggle aerial outline view
- `<A-g>` - Git commands (fugitive)

### Tab Management (IntelliJ Style)
**Note: In Neovim, tabs are different from buffers. Tabs are layout containers.**
- `<C-1>` - Go to first tab
- `<C-2~9>` - Go to tab 2-9
- `<C-Tab>` - Next tab
- `<C-Shift-Tab>` - Previous tab

### Buffer Management (barbar.nvim)
**Note: Buffers are individual file instances, managed by barbar.nvim.**
- `<Leader>b1~9` - Goto buffer 1-9 (primary method)
- `<Leader>b0` - Goto last buffer
- `<A-2~6>, <A-8~9>` - Goto buffer 2-6, 8-9 (alternative, excludes 1 & 7 for panels)
- `<A-,>` - Previous buffer
- `<A-.>` - Next buffer
- `<A-c>` - Close buffer
- `<C-p>` - Buffer pick mode
- `<A-p>` - Pin/unpin buffer

### Key Differences
- **Tabs**: Layout containers (like IntelliJ tabs) - use `:tabnew`, `:tabclose`
- **Buffers**: Individual files (like IntelliJ editor tabs) - managed by barbar.nvim
- **One tab can contain multiple buffers** (via splits)
- **Barbar.nvim shows buffers in the tabline**, not Neovim tabs

### Window Management
- `<Leader>S<direction>` - Resize splits
- `<Leader>S<letter>` - Split layout management
- `gw` - Switch windows

### Multi-cursor & Selection
- `<C-d>` - Find next occurrence (multi-cursor mode)
- `<C-c>` - Skip current occurrence
- `<C-s>` - Treesitter incremental selection

## Testing & Validation

This configuration should work with:
- Neovim 0.8+ (tested with latest stable)
- Python development with basedpyright
- Lua development with lua_ls
- Rust development with rust-analyzer and comprehensive tooling
- All key bindings preserved from the original coc.nvim setup

## Rust Development Workflow

### First-time Setup
1. Install Rust toolchain: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
2. Open a Rust project with Neovim - rust-analyzer will be auto-installed via Mason
3. All Rust-specific features will be available immediately

### Common Rust Development Tasks
- **Code completion**: Enhanced with crate completions and rust-analyzer suggestions
- **Error checking**: Real-time Clippy integration with warnings treated as errors
- **Testing**: Use `<leader>tn/ts/tf/tl` for integrated test running
- **Debugging**: `<leader>dr` to launch debug targets (requires lldb-vscode)
- **Cargo management**: Edit `Cargo.toml` with version hints and upgrade capabilities
- **Macro debugging**: `<leader>rm` to expand macros at cursor
- **Refactoring**: Structural Search Replace with `<leader>rs` for complex code transformations