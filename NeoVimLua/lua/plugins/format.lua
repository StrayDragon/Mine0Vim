return {
  -- Modern formatting system with conform.nvim
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({
            async = true,
            lsp_fallback = true,
            timeout_ms = 1000,
          })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    dependencies = {
      "williamboman/mason.nvim", -- Ensure formatters are available via Mason
    },
    opts = {
      -- Format on save
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },

      -- Format after save (asynchronous)
      format_after_save = false, -- Disabled to avoid conflicts with format_on_save

      -- Formatters by filetype
      formatters_by_ft = {
        -- Python formatters - using ruff only
        python = { "ruff_format", "ruff_organize_imports" },

        -- Lua formatters
        lua = { "stylua" },

        -- Rust formatters
        rust = { "rustfmt" },

        -- JavaScript/TypeScript formatters
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },

        -- Go formatters
        go = { "gofmt", "gofumpt" },

        -- Web formatters
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        sass = { "prettierd", "prettier" },

        -- JSON/YAML/TOML formatters
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        toml = { "taplo" },

        -- Shell formatters
        bash = { "shfmt" },
        sh = { "shfmt" },

        -- Markdown formatters
        markdown = { "prettierd", "prettier" },

        -- SQL formatters
        sql = { "sqlfmt" },

        -- Other formatters
        proto = { "buf" },
      },

      -- Formatter options
      format = {
        timeout_ms = 1000,
        lsp_fallback = true,
        quiet = false,
      },

      -- Notification settings
      notify_on_error = true,

      -- Log level
      log_level = vim.log.levels.WARN,
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- Custom formatters configuration
      local formatters = require("conform.formatters")

      -- Enhanced Python formatter configuration
      formatters.black = {
        prepend_args = { "--line-length=88", "--target-version=py38" },
      }

      formatters.isort = {
        prepend_args = { "--profile=black" },
      }

      -- Enhanced JavaScript formatter configuration
      formatters.prettierd = {
        command = "prettierd",
        args = { "--stdin-filepath", "$FILENAME" },
        range_args = function(self, ctx)
          return { "--stdin-filepath", ctx.filename, "--range-start", ctx.range.start[1] }
        end,
      }

      -- Enhanced Go formatter configuration
      formatters.gofmt = {
        prepend_args = { "-s", "-w" },
      }

      formatters.gofumpt = {
        prepend_args = { "-extra" },
      }

      -- Rust formatter configuration
      formatters.rustfmt = {
        command = "rustfmt",
        args = { "--emit=stdout" },
        range_args = function(self, ctx)
          return { "--range", string.format("%d:%d", ctx.range.start[1], ctx.range["end"][1]) }
        end,
      }

      -- Shell formatter configuration
      formatters.shfmt = {
        prepend_args = { "-i", "2", "-ci", "-bn" },
      }
    end,
    init = function()
      -- Create user commands for format operations
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({
          range = range,
          async = false,
          lsp_fallback = true
        })
      end, { range = true })

      vim.api.nvim_create_user_command("FormatInfo", function()
        require("conform").info()
      end, {})

      -- Add format command to QuickUI menu (if available)
      vim.defer_fn(function()
        if vim.fn.exists("*quickui#context#open") == 1 then
          -- This will be picked up by the existing QuickUI menu
        end
      end, 1000)
    end,
  },
}