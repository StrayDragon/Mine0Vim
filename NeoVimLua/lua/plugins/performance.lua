return {
  -- Essential snacks.nvim features for enhanced editing experience
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",  -- For better icons
    },
    opts = function()
      return {
        -- Big file handling - essential for performance
        bigfile = {
          enabled = true,
          notify = true,
          size = 1.5 * 1024 * 1024,  -- 1.5MB threshold
          line_length = 1000,

          setup = function(ctx)
            local opts = { buffer = ctx.buf, silent = true }

            -- Disable performance-intensive features for large files
            vim.opt_local.wrap = false
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.foldenable = false
            vim.opt_local.cursorline = false
            vim.opt_local.cursorcolumn = false
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.spell = false
            vim.opt_local.list = false

            -- Reduce syntax highlighting complexity
            vim.opt_local.syntax = "OFF"
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ctx.buf) then
                vim.bo[ctx.buf].syntax = ctx.ft
                if ctx.ft == "json" or ctx.ft == "xml" then
                  vim.cmd("syntax match Normal /\\v./")
                end
              end
            end)

            -- Disable plugin features for this buffer
            vim.b.minianimate_disable = true
            vim.b.minicursorword_disable = true
            vim.b.minicompletion_disable = true

            -- Show notification
            vim.notify(
              string.format("Large file detected (%.2fMB). Performance optimizations applied.", ctx.size / (1024 * 1024)),
              vim.log.levels.INFO,
              { title = "Big File Mode" }
            )
          end,
        },

        -- Terminal configuration - useful floating terminal
        terminal = {
          enabled = true,
          win = {
            position = "float",
            border = "rounded",
            style = "minimal",
            width = 0.8,
            height = 0.8,
          },
        },

        -- Quick file navigation
        quickfile = {
          enabled = true,
          exclude = { "NvimTree", "neo-tree", "dashboard" },
        },

        -- Scrolling enhancement
        scroll = {
          enabled = true,
          animate = {
            easing = "outQuad",
            duration = { step = 10, total = 150 },
          },
        },

        -- Words configuration for text navigation
        words = {
          enabled = true,
          jump = {
            freq = 100,
          },
        },

        -- Zen mode for focused work
        zen = {
          enabled = true,
          enter = false,
          fixbuf = false,
          minimal = false,
          width = 120,
          height = 0,
          backdrop = {
            transparent = true,
            blend = 40
          },
          keys = { q = false },
          zindex = 40,
          wo = {
            winhighlight = "NormalFloat:Normal",
          },
        },

        -- Status column configuration
        statuscolumn = {
          enabled = true,
          left = { "mark", "sign" },
          right = { "fold", "git" },
        },

        -- Styles configuration
        styles = {
          notification = {
            wo = { wrap = true },
          },
        },
      }
    end,
    config = function(_, opts)
      require("snacks").setup(opts)

      local snacks = require("snacks")
      local map = vim.keymap.set

      -- Key mappings for useful features
      map("n", "<leader>z", function() snacks.zen.toggle() end,
        { noremap = true, silent = true, desc = "Toggle zen mode" })

      map("n", "<leader>tt", function() snacks.terminal.toggle() end,
        { noremap = true, silent = true, desc = "Toggle terminal" })

      map("n", "<leader>bd", function() snacks.bufdelete() end,
        { noremap = true, silent = true, desc = "Delete buffer" })

      -- Create user commands
      vim.api.nvim_create_user_command("ZenMode", function()
        snacks.zen.toggle()
      end, { desc = "Toggle zen mode" })

      vim.api.nvim_create_user_command("BigFileMode", function()
        local buf = vim.api.nvim_get_current_buf()
        local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))

        if file_size > 1.5 * 1024 * 1024 then
          snacks.bigfile.setup({
            size = file_size,
            ft = vim.bo[buf].filetype,
            buf = buf,
          })
          vim.notify("Big file mode enabled manually", vim.log.levels.INFO)
        else
          vim.notify("Current file is not large enough for big file mode", vim.log.levels.WARN)
        end
      end, { desc = "Manually enable big file mode" })

    end,
  },
}