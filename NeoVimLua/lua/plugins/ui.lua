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
  { "itchyny/lightline.vim", config = function()
      -- Statusline configuration preserving legacy settings
      vim.g.lightline = {
        colorscheme = "PaperColor",
        active = {
          left = {
            { "mode", "paste" },
            { "readonly", "filename", "modified" }
          },
          right = {
            { "fileencoding", "lineinfo" },
            { "percent" },
          }
        }
      }
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
        end,
      })

      -- Apply immediately for the current colorscheme
      pcall(function()
        vim.api.nvim_set_hl(0, "LspInlayHint", {
          fg = "#6c6c6c",
          bg = "NONE",
          italic = true,
        })
      end)
    end
  },
}