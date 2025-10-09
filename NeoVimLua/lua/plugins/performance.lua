return {
  -- Performance monitoring and big file handling with snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",  -- For better icons
    },
    opts = function()
      return {
        -- Big file handling configuration
        bigfile = {
          enabled = true,
          notify = true,  -- Show notification when big file detected
          size = 1.5 * 1024 * 1024,  -- 1.5MB threshold
          line_length = 1000,  -- Average line length threshold (useful for minified files)

          -- Setup function that executes when a big file is detected
          setup = function(ctx)
            -- Performance optimizations for large files
            local opts = { buffer = ctx.buf, silent = true }

            -- Disable performance-intensive features
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
                -- Use minimal syntax for large files
                if ctx.ft == "json" or ctx.ft == "xml" then
                  vim.cmd("syntax match Normal /\\v./")
                end
              end
            end)

            -- Disable certain plugins for this buffer
            vim.b.minianimate_disable = true
            vim.b.minicursorword_disable = true
            vim.b.minicompletion_disable = true

            -- Disable LSP features for large files
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ctx.buf) then
                local clients = vim.lsp.get_clients({ bufnr = ctx.buf })
                for _, client in ipairs(clients) do
                  if client.server_capabilities.documentHighlightProvider then
                    vim.lsp.buf.clear_references()
                  end
                end

                -- Disable inlay hints for large files
                if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                  pcall(vim.lsp.inlay_hint.enable, false, { bufnr = ctx.buf })
                end
              end
            end)

            -- Show big file notification
            vim.notify(
              string.format("Large file detected (%.2fMB). Performance optimizations applied.", ctx.size / (1024 * 1024)),
              vim.log.levels.INFO,
              { title = "Big File Mode" }
            )

            -- Create user commands for this buffer
            vim.api.nvim_buf_create_user_command(ctx.buf, "BigFileStatus", function()
              local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(ctx.buf))
              local line_count = vim.api.nvim_buf_line_count(ctx.buf)
              print(string.format("Big File Status:\n  Size: %.2f MB\n  Lines: %d\n  Optimizations: Active",
                size / (1024 * 1024), line_count))
            end, { desc = "Show big file status" })
          end,
        },

        -- Performance monitoring configuration
        performance = {
          enabled = true,
          show = "startup",  -- Show startup performance

          -- Performance tracking
          tracker = {
            enabled = true,
            threshold = 100,  -- Only track operations slower than 100ms
          },
        },

        -- Terminal configuration (enhanced)
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

        -- Quick file navigation (enhanced)
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
            freq = 100,  -- How often to check for cursor position changes
          },
        },

        -- Indent guide enhancement
        indent = {
          enabled = false,  -- Disabled for better performance
        },

        -- Dimming inactive windows
        dim = {
          enabled = true,
          animate = {
            enabled = vim.fn.has("nvim-0.10") == 1,
            easing = "outQuad",
            duration = {
              step = 20,
              total = 300
            }
          },
          scope = {
            min_size = 5,
            max_size = 20,
            siblings = true,
          },
          filter = function(buf)
            return vim.g.snacks_dim ~= false and
                   vim.b[buf].snacks_dim ~= false and
                   vim.bo[buf].buftype == ""
          end,
        },

        -- Zen mode for focused work
        zen = {
          enabled = true,
          enter = false,  -- Don't auto-enter zen mode
          fixbuf = false,
          minimal = false,
          width = 120,
          height = 0,
          backdrop = {
            transparent = true,
            blend = 40
          },
          keys = { q = false },  -- Don't override 'q'
          zindex = 40,
          wo = {
            winhighlight = "NormalFloat:Normal",
          },
        },

        -- Image support (optional)
        image = {
          enabled = false,  -- Disabled by default for performance
          doc = {
            enabled = false,
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

      -- Global performance monitoring
      local snacks = require("snacks")

      -- Create performance monitoring commands
      vim.api.nvim_create_user_command("PerformanceStats", function()
        local stats = snacks.performance.stats()
        if stats then
          print("Performance Statistics:")
          for key, value in pairs(stats) do
            print(string.format("  %s: %s", key, value))
          end
        else
          print("No performance statistics available")
        end
      end, { desc = "Show performance statistics" })

      vim.api.nvim_create_user_command("BigFileMode", function()
        local buf = vim.api.nvim_get_current_buf()
        local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))

        if file_size > 1.5 * 1024 * 1024 then  -- If file is larger than 1.5MB
          -- Apply big file optimizations
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

      vim.api.nvim_create_user_command("ZenMode", function()
        snacks.zen.toggle()
      end, { desc = "Toggle zen mode" })

      vim.api.nvim_create_user_command("ToggleDim", function()
        snacks.dim.toggle()
      end, { desc = "Toggle window dimming" })

      -- Performance note: snacks.performance module is not available
      -- Remove performance monitoring to avoid errors

  
      -- Key mappings for performance features
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true, desc = "Performance" }

      -- Toggle zen mode
      map("n", "<leader>z", function() snacks.zen.toggle() end,
        vim.tbl_extend("force", opts, { desc = "Toggle zen mode" }))

      -- Toggle dimming
      map("n", "<leader>ud", function() snacks.dim.toggle() end,
        vim.tbl_extend("force", opts, { desc = "Toggle window dimming" }))

      -- Quick file navigation
      map("n", "<leader>qf", function() snacks.quickfile() end,
        vim.tbl_extend("force", opts, { desc = "Quick file navigation" }))

      end,
  },

  -- Optional: Add startup time monitoring
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
      vim.g.startuptime_format = "markdown"
    end,
  },

  -- Optional: Enhanced startup analysis
  {
    "tweekmonster/startuptime.vim",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_event_width = 20
      vim.g.startuptime_tries = 5
    end,
  },
}