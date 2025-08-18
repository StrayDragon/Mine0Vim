# Mine0Vim NeoVimLua Configuration

Modern Neovim configuration migrated from [vim-plug](https://github.com/junegunn/vim-plug) to [lazy.nvim](https://github.com/folke/lazy.nvim).

## ✅ Migration Status: Complete

All core features have been successfully migrated from the legacy vim-plug configuration to a modern lazy.nvim-based setup with Lua configuration.

## 🚀 Key Features

- **Plugin Manager**: [folke/lazy.nvim](https://github.com/folke/lazy.nvim) with lazy loading
- **LSP Support**: [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim)
- **Completion**: [blink.cmp](https://github.com/Saghen/blink.cmp) with snippet support
- **Syntax Highlighting**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- **Terminal**: [floatty.nvim](https://github.com/ingur/floatty.nvim) for floating terminals
- **Theme**: PaperColor with lightline.vim status bar

## 📦 Plugin Migration Map

| Feature | Old (vim-plug) | New (lazy.nvim) | Status |
|---------|---------------|-----------------|---------|
| Plugin Manager | vim-plug | [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | ✅ Complete |
| Language Support | coc.nvim | [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | ✅ Complete |
| LSP Installation | coc marketplace | [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | ✅ Complete |
| Completion | coc.nvim | [Saghen/blink.cmp](https://github.com/Saghen/blink.cmp) | ✅ Complete |
| Syntax Highlighting | coc.nvim | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | ✅ Complete |
| Terminal | vim-floaterm | [ingur/floatty.nvim](https://github.com/ingur/floatty.nvim) | ✅ Complete |
| Code Navigation | aerial.nvim | aerial.nvim | ✅ Complete |
| Status Line | lightline.vim | lightline.vim | ✅ Complete |
| Themes | PaperColor/edge | PaperColor/edge | ✅ Complete |

## 🛠 Configuration Structure

```
├── lua/
│   ├── init.lua              # Main Lua bootstrap  
│   ├── config/
│   │   ├── lazy.lua          # lazy.nvim setup
│   │   ├── options.lua       # Vim options
│   │   └── keymaps.lua       # Key mappings
│   └── plugins/
│       ├── completion.lua    # blink.cmp completion
│       ├── lsp.lua          # LSP + mason configuration
│       ├── treesitter.lua   # Syntax highlighting
│       ├── ui.lua           # UI plugins (themes, status line)
│       └── misc.lua         # Other plugins
└── README.md                # This documentation
```

## 🔧 Usage

1. **First Time Setup**: Open Neovim - lazy.nvim will automatically install all plugins
2. **LSP Servers**: Mason will auto-install basedpyright and lua_ls
3. **Key Bindings**: All previous LSP key bindings have been preserved (gd, K, g[, \<leader\>rn, etc.)

## 🎯 LSP Support

- **Python**: basedpyright (auto-installed via mason) with inlay hints
- **Lua**: lua_ls (auto-installed via mason)

All LSP servers maintain consistent key bindings for seamless editing experience.