# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Neovim configuration written in Lua using the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager. The configuration is organized with modular structure for maintainability.

## Architecture

### Entry Points
- `init.lua` - Bridge entrypoint that delegates to `lua/init.lua`
- `lua/init.lua` - Main configuration loader that sets up lazy.nvim and loads core modules

### Core Configuration Structure
- `lua/config/` - Basic Neovim configuration
  - `lazy.lua` - Plugin manager setup
  - `options.lua` - Editor options and settings
  - `keymaps.lua` - Key mappings and shortcuts

### Plugin Configuration Structure
- `lua/plugins/` - Plugin specifications organized by functionality:
  - `core.lua` - Essential plugins (lazy.nvim, which-key, etc.)
  - `lsp.lua` - Language server protocol configuration
  - `mason.lua` - LSP package manager
  - `dap.lua` - Debug adapter protocol setup
  - `code.lua` - Code completion and snippets (nvim-cmp, luasnip)
  - `editing.lua` - Text editing enhancements
  - `navigation.lua` - File navigation and search (telescope, treesitter)
  - `buffer.lua` - Buffer and window management
  - `git.lua` - Git integration
  - `rust.lua` - Rust-specific development tools
  - `ui.lua` - User interface improvements
  - `tools.lua` - Development utilities
  - `refactor.lua` - Code refactoring tools

## Common Development Commands

### Linting and Formatting
```bash
# Run Lua linter
luacheck lua/

# Note: stylua is not currently installed in the environment
```

### Neovim Testing
```bash
# Test configuration by running Neovim with this config
nvim --config /home/l8ng/Kits/Mine0Vim/NeoVimLua/init.lua

# Check Neovim version
nvim --version
```

### Plugin Management
The configuration uses lazy.nvim for plugin management. Plugins are managed through:

- `:Lazy` - Interactive plugin manager UI
- `:Lazy sync` - Synchronize plugins
- `:Lazy install` - Install missing plugins
- `:Lazy update` - Update all plugins
- `:Lazy clean` - Remove unused plugins

due to network issues, prefer use user `. proxing on` to source proxy env to do this update and `. proxing off` to disable

## Configuration Details

### Theme
- Primary theme: `onenord` with fallbacks to `edge` and `habamax`
- Theme is set in `lua/init.lua:14`

### LSP Setup
- Uses LSP config with Mason for automatic LSP server installation
- Debug Adapter Protocol (DAP) configured for debugging support
- Language-specific configurations, particularly for Rust development

### Key Features
- Modular plugin organization for easy maintenance
- Comprehensive LSP and debugging support
- Git integration
- Telescope for fuzzy finding and navigation
- Tree-sitter for syntax highlighting and code understanding
- Which-key for keybinding discovery

## File Structure Notes

- Configuration follows Neovim's standard Lua module loading
- Each plugin module focuses on specific functionality areas
- Core settings are separated from plugin configurations for clarity
- The `lazy-lock.json` file pins plugin versions for reproducibility

## Development Environment

- Requires Neovim 0.5+ with Lua support
- Uses Python virtual environment (`.venv`) for some integrations
- Node.js dependencies managed with pnpm
- Luacheck configured for static analysis (see `.luacheckrc`)