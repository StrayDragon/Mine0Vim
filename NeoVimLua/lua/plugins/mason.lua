return {
  -- Mason configuration for automatic tool installation
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      -- Core LSP servers for backend development
      local lsp_servers = {
        -- Python
        "basedpyright",    -- Modern Python LSP (successor to pyright)
        "ruff",            -- Python linter and formatter (LSP)

        -- Lua
        "lua_ls",          -- Lua Language Server

        -- Go
        "gopls",           -- Go Language Server

        -- Rust
        "rust-analyzer",   -- Rust Language Server

        -- Configuration files
        "json-lsp",        -- JSON/JSONC/JSONP Language Server
        "yaml-language-server", -- YAML Language Server
        "taplo",           -- TOML Language Server
      }

      -- DAP (Debug Adapter Protocol) servers
      local dap_servers = {
        -- Python
        "debugpy",         -- Python debugger

        -- Go
        "delve",           -- Go debugger

        -- Rust
        "codelldb",        -- Rust debugger (lldb-based)
        "lldb-dap",        -- Alternative Rust debugger
      }

      -- Linters for code quality
      local linters = {
        -- Python
        "ruff",            -- Python linter (fast and comprehensive)

        -- Lua
        "luacheck",        -- Lua linter

        -- Go
        "golangci-lint",   -- Go comprehensive linter

        -- Rust
        -- Note: clippy is included with rust-analyzer

        -- Configuration files
        "yamllint",        -- YAML linter
        "vint",            -- Vim script linter
      }

      -- Formatters for code style
      local formatters = {
        -- Python
        "ruff",            -- Python formatter

        -- Lua
        "stylua",          -- Lua formatter

        -- Go
        -- Note: gofmt is built-in, no need to install

        -- Rust
        -- Note: rustfmt is included with rust-analyzer

        -- Configuration files
        "yamlfmt",         -- YAML formatter
        "taplo",           -- TOML formatter
      }

      -- Additional utilities
      local utilities = {
        "tree-sitter-cli", -- Parser generator for TreeSitter grammars
      }

      -- Combine all tools
      local all_tools = {}
      vim.list_extend(all_tools, lsp_servers)
      vim.list_extend(all_tools, dap_servers)
      vim.list_extend(all_tools, linters)
      vim.list_extend(all_tools, formatters)
      vim.list_extend(all_tools, utilities)

      -- Remove duplicates while preserving order
      local seen = {}
      local unique_tools = {}
      for _, tool in ipairs(all_tools) do
        if not seen[tool] then
          seen[tool] = true
          table.insert(unique_tools, tool)
        end
      end

      -- Add to ensure_installed
      vim.list_extend(opts.ensure_installed, unique_tools)

      -- Optional: Configure Mason settings for better performance
      opts.ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        keymaps = {
          toggle_package_expand = "<CR>",
          install_package = "i",
          update_package = "u",
          check_package_version = "c",
          update_all_packages = "U",
          uninstall_package = "X",
          cancel_installation = "<C-c>",
        },
      }

      -- Configure pip settings for Python packages
      opts.pip = {
        upgrade_pip = false,
        install_args = {},
      }

      -- Log level configuration
      opts.log_level = vim.log.levels.INFO
    end,
  },

  -- Mason LSP configuration (separate from Mason for clarity)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "basedpyright",
          "lua_ls",
          "gopls",
          "rust_analyzer",
          "jsonls",
          "yamlls",
          "taplo",
        },
        automatic_installation = true,
      })
    end,
  },
}