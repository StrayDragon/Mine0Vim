return {
  { "stevearc/aerial.nvim", opts = {}, keys = {
      { "<C-7>", "<cmd>AerialToggle!<CR>", mode = "n", desc = "Toggle Aerial" },
      { "<space>o", "<cmd>AerialToggle!<CR>", mode = "n", desc = "Toggle Outline View" },
    }
  },
  { "ingur/floatty.nvim", config = function()
      local term = require("floatty").setup({})
      -- Terminal toggle (Ctrl+F12, macOS-friendly)
      vim.keymap.set('n', '<C-F12>', function() term.toggle() end, { desc = 'Toggle Terminal (Ctrl+F12)' })
      vim.keymap.set('t', '<C-F12>', function() term.toggle() end, { desc = 'Toggle Terminal (Ctrl+F12)' })
    end
  },
  { "nvim-lualine/lualine.nvim",
    lazy = false,  -- 立即加载状态栏
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Custom LSP status component
      local function lsp_status()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = {}

        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = bufnr })
        elseif vim.lsp.get_active_clients then
          clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        end

        if #clients == 0 then
          return ''
        end

        local client_names = {}
        for _, client in ipairs(clients) do
          if client.name ~= 'null-ls' then
            table.insert(client_names, client.name)
          end
        end

        if #client_names > 0 then
          return '🔧 ' .. table.concat(client_names, ', ')
        else
          return ''
        end
      end

      -- Custom inlay hints status component
      local function inlay_hints_status()
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.lsp.inlay_hint then
          return ''
        end

        local enabled = false
        if vim.lsp.inlay_hint.is_enabled then
          local ok, val = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
          if not ok then
            ok, val = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
          end
          if ok then enabled = val end
        end

        return enabled and '💡 Hints' or ''
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'PaperColor',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {
              'NvimTree',
              'neo-tree',
              'neo-tree-popup',
              'aerial',
              'aerial-nav',
              'toggleterm',
              'fzf',
              'FzfLua',
              'TelescopePrompt',
              'TelescopeResults',
              'undotree',
              'git',
              'diff',
              'help',
              'lazy',
              'mason',
              'mason.nvim',
              'qf',
              'quickfix',
              'starter',
              'alpha',
              'dashboard',
              'oil',
              'minifiles',
              'netrw',
              'Trouble'
            },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff',
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              sections = { 'error', 'warn', 'info', 'hint' },
              diagnostics_color = {
                error = 'DiagnosticError',
                warn  = 'DiagnosticWarn',
                info  = 'DiagnosticInfo',
                hint  = 'DiagnosticHint',
              },
              symbols = {error = '🔴', warn = '🟡', info = '🔵', hint = '⚪'},
              colored = true,
              always_visible = false,
            }
          },
          lualine_c = {
            {
              'filename',
              file_status = true,      -- Displays file status (readonly status, modified status)
              newfile_status = false,  -- Display new file status (new file means no write after created)
              path = 0,                -- 0: Just the filename
              shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[No Name]',
                newfile = '[New]'
              }
            },
          },
          lualine_x = {
            { lsp_status, color = { fg = '#666666' } },
            { inlay_hints_status, color = { fg = '#888888' } },
            'encoding',
            'fileformat',
            'filetype'
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end
  },
  { "Yggdroot/indentLine", config = function()
      -- Configure indentLine only for Python files as per legacy config
      vim.g.indentLine_fileType = { "python" }
    end
  },
  { "doums/darcula" },
  { "sainnhe/edge" },
  { "NLKNguyen/papercolor-theme", config = function()
      -- Try to use PaperColor by default; if not, fall back to edge or habamax
      local ok = pcall(vim.cmd.colorscheme, "PaperColor")
      if not ok then
        local ok2 = pcall(vim.cmd.colorscheme, "edge")
        if not ok2 then
          pcall(vim.cmd.colorscheme, "habamax")
        end
      end

      -- Ensure LspInlayHint has proper highlighting to avoid error decorators
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Set subtle inlay hint styling
          vim.api.nvim_set_hl(0, "LspInlayHint", {
            fg = "#6c6c6c",
            bg = "NONE",
            italic = true,
          })

          -- Set FloatBorder with better contrast
          vim.api.nvim_set_hl(0, "FloatBorder", {
            fg = "#666666",
            bg = "NONE",
          })
        end,
      })

      -- Apply immediately for the current colorscheme
      pcall(function()
        vim.api.nvim_set_hl(0, "LspInlayHint", {
          fg = "#6c6c6c",
          bg = "NONE",
          italic = true,
        })

        -- Set FloatBorder with better contrast
        vim.api.nvim_set_hl(0, "FloatBorder", {
          fg = "#666666",
          bg = "NONE",
        })
      end)
    end
  },
}