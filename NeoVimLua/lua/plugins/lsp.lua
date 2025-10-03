return {
  -- Mason and LSP configuration - immediate load
  {
    "williamboman/mason.nvim",
    lazy = false,  -- 立即加载 LSP 工具
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,  -- 立即加载 LSP 配置
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      -- Only ensure installation, no automatic setup or enabling
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "basedpyright" },
        automatic_installation = false,
        -- Disable automatic enabling of LSP servers (Neovim 0.11+)
        automatic_enable = false,
        -- Explicitly prevent any automatic setup by providing empty handlers
        handlers = {},
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,  -- 立即加载 LSP 核心配置
    dependencies = { "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- Unify position encodings across all clients to avoid mixed UTF-8/UTF-16 warnings
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-8" }

      -- Setup keymaps on attach
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Preserve Coc.nvim keybindings for seamless transition
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        -- hover documentation
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- diagnostic navigation
        vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, opts)

        -- actions
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'x'}, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set({'n', 'x'}, '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- Show diagnostics in floating window
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

        -- Fix window parameter issues for code action range in Neovim 0.11.4+
        -- Override make_range_params to ensure valid window parameter
        local orig_make_range_params = vim.lsp.util.make_range_params
        vim.lsp.util.make_range_params = function(opts)
          opts = opts or {}
          -- Use current window to avoid "Expected Lua number" error
          opts.window = vim.api.nvim_get_current_win()
          -- Set position encoding to avoid mixed encoding warnings
          opts.position_encoding = opts.position_encoding or "utf-8"
          return orig_make_range_params(opts)
        end

        -- Safely enable inlay hints with robust error handling for Neovim 0.11+
        if client.server_capabilities.inlayHintProvider then
          vim.schedule(function()
            local ok, err = pcall(function()
              if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                -- Add autocmd to disable inlay hints during text changes to prevent col out of range
                local group = vim.api.nvim_create_augroup("InlayHintProtection_" .. bufnr, { clear = true })
                vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufDelete", "BufWipeout" }, {
                  group = group,
                  buffer = bufnr,
                  callback = function()
                    pcall(function()
                      if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                        -- Re-enable after a brief delay
                        vim.defer_fn(function()
                          if vim.api.nvim_buf_is_valid(bufnr) then
                            pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
                          end
                        end, 100)
                      end
                    end)
                  end,
                })
              end
            end)
            if not ok then
              vim.notify("Failed to enable inlay hints: " .. tostring(err), vim.log.levels.WARN)
            end
          end)
        end
      end

      -- Use new vim.lsp.config API (Neovim 0.11+)
      local lsp_configs = {
        -- Python LSP (primary requirement)
        basedpyright = {
          cmd = { "basedpyright-langserver", "--stdio" },
          filetypes = { "python" },
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                -- Enable inlay hints for type annotations
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  callArgumentNames = "partial",
                },
              },
            },
          },
        },

        -- Lua LSP
        lua_ls = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        }

      -- Register LSP configurations using new API
      for server_name, config in pairs(lsp_configs) do
        vim.lsp.config(server_name, config)
      end

      -- Auto-start LSP servers for appropriate filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local filetype = args.file
          local lsp_map = {
            python = "basedpyright",
            lua = "lua_ls",
          }

          local server = lsp_map[filetype]
          if server then
            vim.lsp.enable(server)
          end
        end,
      })

      -- Note: LSP hover and signature help borders are now controlled by
      -- vim.o.winborder = "rounded" in config/options.lua
      -- This applies to all floating windows globally in Neovim 0.11+

      -- Diagnostics configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = {
            {"┌", "FloatBorder"},
            {"─", "FloatBorder"},
            {"┐", "FloatBorder"},
            {"│", "FloatBorder"},
            {"┘", "FloatBorder"},
            {"─", "FloatBorder"},
            {"┚", "FloatBorder"},
            {"│", "FloatBorder"},
          },
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
}
