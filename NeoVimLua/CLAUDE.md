# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a modern NeoVim Lua configuration that has been optimized for performance, modularity, and maintainability. The configuration uses lazy.nvim for plugin management and follows a modular architecture with clear separation of concerns.

## Development Commands

### Plugin Management
- **Plugin installation**: Automatically handled by lazy.nvim on startup
- **Update plugins**: `:Lazy update` (in NeoVim)
- **Clean plugins**: `:Lazy clean` (in NeoVim)
- **Plugin status**: `:Lazy` (in NeoVim)

### LSP and Tools
- **Install LSP servers**: `:Mason` (interactive UI) or `:MasonInstall <server>`
- **Update Mason tools**: `:MasonUpdate`
- **LSP info**: `:LspInfo` to check active LSP servers
- **Format code**: LSP formatting is configured, use `:lua vim.lsp.buf.format()`

### Code Quality
- **Lua linting**: `luacheck .` (checks all Lua files in the project)
- **Syntax validation**: Individual files can be checked with `luac -p <file>`

### Debug Adapter Protocol (DAP)
- **Debug adapter installation**: Use Mason to install debug adapters (e.g., `:MasonInstall codelldb` for Rust)
- **Debugging**: DAP is configured with keybindings and UI components

## Architecture Overview

### Entry Points
- **`init.lua`**: Root entry point that delegates to Lua configuration
- **`lua/init.lua`**: Main orchestrator that sets up lazy.nvim and loads core modules
- **`lua/config/`**: Core configuration files (options, keymaps, lazy.nvim setup)
- **`lua/plugins/`**: Modular plugin specifications organized by function

### Plugin Architecture
The configuration uses **lazy.nvim** with a modular approach:

**Core Modules:**
- **`core.lua`**: Treesitter and textobjects - syntax highlighting and intelligent text manipulation
- **`lsp.lua`**: Language Server Protocol configuration with Mason integration
- **`code.lua`**: Code completion (blink.cmp v1.7.0), formatting, and linting
- **`navigation.lua`**: File management, search tools, and navigation
- **`ui.lua`**: Theme (OneNord), status line, and UI enhancements

**Development Tools:**
- **`debug.lua`**: Debug Adapter Protocol (DAP) configuration
- **`rust.lua`**: Rust-specific development setup with rust-analyzer
- **`dap.lua`**: DAP bridge configuration
- **`refactor.lua`**: Refactoring tools and utilities
- **`buffer.lua`**: Buffer management and manipulation
- **`editing.lua`**: Text editing enhancements

**Supporting Modules:**
- **`git.lua`**: Git integration (fugitive, git-blame, etc.)
- **`tools.lua`**: Terminal, AI assistants, notifications
- **`which-key.lua`**: Keybinding discovery system
- **`misc.lua`**: Miscellaneous utilities (kept for compatibility)

### Key Design Principles

#### 1. **Unified Keybinding System**
- Standard LSP keybindings: `gd` (definition), `gr` (references), `gi` (implementation), `gy` (type definition), `K` (hover)
- `<leader>` prefix for custom actions with conflict avoidance
- Disabled `s`/`S` mappings to prevent conflicts with `<leader>s`/`<leader>S`
- Comprehensive description system for all keybindings

#### 2. **Modern NeoVim API Usage**
- No legacy compatibility code - targets modern NeoVim versions
- Uses vim.diagnostic API for diagnostics management
- Modern LSP client capabilities with blink.cmp integration
- Removed redundant plugins (indentLine, performance monitors) in favor of built-in functionality

#### 3. **Performance Optimization**
- Event-based lazy loading for non-essential plugins
- Disabled unused built-in plugins
- Provider management: Python uses local .venv only, Node.js uses local node_modules
- Removed startup time analysis tools (modern NeoVim is sufficiently fast)

#### 4. **Language-Specific Enhancements**
- Rust development with rust-analyzer integration and custom keybindings
- File-type specific configurations in `after/ftplugin/`
- Language-appropriate indentation settings (Lua/JSON/YAML: 2 spaces, others: 4 spaces)

### Plugin Management Specifics

#### Lazy.nvim Configuration
- **Auto-installation**: lazy.nvim clones itself if not present
- **Health checking**: Built-in checker for plugin updates
- **Color schemes**: Fallback order: `onenord` → `edge` → `habamax`
- **Modular imports**: All plugins imported from `lua/plugins/` directory

#### Key Plugins and Their Purposes
- **Completion**: `blink.cmp` (v1.7.0) - modern, fast completion engine
- **Syntax**: `nvim-treesitter` with incremental selection and textobjects
- **LSP**: `nvim-lspconfig` with Mason for automatic server installation
- **Navigation**: `fzf-lua` for fuzzy finding and file navigation
- **Git**: `fugitive` and related tools for Git integration
- **Debug**: DAP with UI components for debugging workflows

### Development Environment

#### Provider Management
- **Python**: Isolated to `.venv` in config directory, no fallback to system Python
- **Node.js**: Uses local `node_modules/.bin`, prevents PATH fallback
- **Ruby**: Disabled by default for performance

#### Code Quality Tools
- **Luacheck**: Configured with appropriate globals for NeoVim and testing frameworks
- **Ignore patterns**: Handles common NeoVim patterns (unused variables, self arguments)

### File Type Configurations
Located in `after/ftplugin/`:
- **Rust**: Extended LSP functionality with additional keybindings
- **Config files**: JSON, YAML, TOML configured with 2-space indentation
- **Lua**: Appropriate settings for NeoVim configuration development

## Recent Optimizations (PLAN.md)

The configuration has undergone significant optimization:
- **Plugin reduction**: Removed redundant plugins (indentLine, floatty.nvim, startup analyzers)
- **Module consolidation**: Combined related functionality into focused modules
- **Performance improvements**: 30-50% startup time reduction expected
- **Architecture simplification**: Clearer module boundaries and reduced complexity

## Working with This Configuration

When modifying this configuration:
1. **Maintain modularity**: Keep changes within the appropriate module files
2. **Follow keybinding conventions**: Use existing patterns and avoid conflicts
3. **Test thoroughly**: Validate with `luacheck` and test NeoVim startup
4. **Document changes**: Add descriptive comments for new keybindings or complex configurations
5. **Use lazy loading**: For new plugins, consider whether they need immediate loading or can be event-triggered

The configuration prioritizes developer productivity while maintaining a clean, maintainable codebase that leverages modern NeoVim capabilities.