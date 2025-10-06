return {
  -- Enhanced linting system with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    dependencies = {
      "williamboman/mason.nvim", -- Ensure linters are available via Mason
    },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      lint.linters_by_ft = {
        -- Python linters - using ruff only (complement basedpyright)
        python = { "ruff" },

        -- Lua linters (complement lua_ls)
        lua = { "luacheck" },

        -- JavaScript/TypeScript linters
        javascript = { "eslint_d", "eslint" },
        typescript = { "eslint_d", "eslint" },
        javascriptreact = { "eslint_d", "eslint" },
        typescriptreact = { "eslint_d", "eslint" },

        -- Go linters (complement gopls)
        go = { "golangcilint", "staticcheck" },

        -- Rust linters disabled (rust-analyzer provides comprehensive diagnostics)
        -- rust = { "clippy" },

        -- Shell script linters
        bash = { "shellcheck" },
        sh = { "shellcheck" },

        -- Docker linters
        dockerfile = { "hadolint" },

        -- YAML linters
        yaml = { "yamllint" },

        -- Markdown linters (暂时禁用，工具未安装)
        -- markdown = { "markdownlint", "vale" },

        -- SQL linters
        sql = { "sqlfluff" },

        -- JSON linters (commented out until jsonlint is available)
        -- json = { "jsonlint" },

        -- TOML linters
        toml = { "taplo" },

        -- C/C++ linters
        c = { "clangtidy" },
        cpp = { "clangtidy" },

        -- Configuration file linters
        vim = { "vint" },
      }

      -- Configure ruff linter for Python
      lint.linters.ruff = {
        cmd = "ruff",
        stdin = false,
        args = {
          "check",
          "--format=json",
          "--no-fix",
          "--line-length=88",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        parser = function(output, bufnr, cwd)
          local success, decoded = pcall(vim.json.decode, output)
          if not success or not decoded then
            return {}
          end

          local diagnostics = {}
          for _, item in ipairs(decoded) do
            if item.location then
              table.insert(diagnostics, {
                lnum = item.location.row - 1,
                col = item.location.column - 1,
                end_lnum = item.end_location and item.end_location.row - 1 or nil,
                end_col = item.end_location and item.end_location.column - 1 or nil,
                severity = item.message:lower():match("error") and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                message = item.message,
                code = item.code,
                source = "ruff",
                user_data = {
                  lint = {
                    severity = item.message:lower():match("error") and "error" or "warning",
                    ruleId = item.code,
                  },
                },
              })
            end
          end
          return diagnostics
        end,
      }

      -- Configure individual linter settings
      lint.linters.pylint = {
        cmd = "pylint",
        stdin = false,
        args = {
          "--from-stdin",
          "--msg-template='{path}:{line}: {msg_id}({symbol}), {obj}: {msg}'",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        parser = require("lint.parser").from_pattern(
          [[([^:]+):(%d+): (%w+)%((%w+)%), (.+): (.+)]],
          {
            file = 1,
            lnum = 2,
            code = 3,
            type = 4,
            severity = 3,
            message = 6,
          },
          {
            ["error"] = vim.diagnostic.severity.ERROR,
            ["warning"] = vim.diagnostic.severity.WARN,
            ["convention"] = vim.diagnostic.severity.HINT,
            ["refactor"] = vim.diagnostic.severity.HINT,
            ["info"] = vim.diagnostic.severity.INFO,
          }
        ),
      }

      lint.linters.mypy = {
        cmd = "mypy",
        stdin = false,
        args = {
          "--show-column-numbers",
          "--hide-error-context",
          "--hide-error-codes",
          "--no-error-summary",
          "--no-pretty",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        parser = require("lint.parser").from_pattern(
          [[([^:]+):(%d+):(%d+): (error|warning|note): (.+)]],
          {
            file = 1,
            lnum = 2,
            col = 3,
            severity = 4,
            message = 5,
          },
          {
            ["error"] = vim.diagnostic.severity.ERROR,
            ["warning"] = vim.diagnostic.severity.WARN,
            ["note"] = vim.diagnostic.severity.INFO,
          }
        ),
      }

      lint.linters.luacheck = {
        cmd = "luacheck",
        stdin = false,
        args = {
          "--formatter",
          "plain",
          "--codes",
          "--ranges",
          "--filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
          "-",
        },
        parser = require("lint.parser").from_pattern(
          [[([^:]+):(%d+):(%d+)-(%d+): ([WEF]): (.+)]],
          {
            file = 1,
            lnum = 2,
            col = 3,
            end_col = 4,
            code = 5,
            message = 6,
          },
          {
            ["W"] = vim.diagnostic.severity.WARN,
            ["E"] = vim.diagnostic.severity.ERROR,
            ["F"] = vim.diagnostic.severity.ERROR,
          }
        ),
      }

      lint.linters.eslint_d = {
        cmd = "eslint_d",
        stdin = false,
        args = { "--format", "json", "--stdin", "--stdin-filename", function() return vim.api.nvim_buf_get_name(0) end },
        parser = function(output, bufnr, cwd)
          local success, decoded = pcall(vim.json.decode, output)
          if not success or not decoded then
            return {}
          end

          local diagnostics = {}
          for _, message in ipairs(decoded) do
            if message.line then
              table.insert(diagnostics, {
                lnum = message.line,
                col = message.column,
                end_lnum = message.endLine or message.line,
                end_col = message.endColumn or message.column,
                severity = message.severity == 1 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                message = message.message,
                code = message.ruleId,
                source = "eslint_d",
                user_data = {
                  lint = {
                    severity = message.severity == 1 and "error" or "warning",
                    ruleId = message.ruleId,
                  },
                },
              })
            end
          end
          return diagnostics
        end,
      }

      lint.linters.golangcilint = {
        cmd = "golangci-lint",
        stdin = false,
        args = {
          "run",
          "--out-format",
          "json",
          "--enable-all",
          "--disable",
          "typecheck", -- Avoid conflicts with gopls
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
        parser = function(output, bufnr, cwd)
          local success, decoded = pcall(vim.json.decode, output)
          if not success or not decoded or not decoded.Issues then
            return {}
          end

          local diagnostics = {}
          for _, issue in ipairs(decoded.Issues) do
            if issue.FromLinter and issue.Pos then
              table.insert(diagnostics, {
                lnum = issue.Pos.Line,
                col = issue.Pos.Column,
                severity = issue.Severity == "error" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                message = issue.Text,
                code = issue.FromLinter,
                source = "golangci-lint",
              })
            end
          end
          return diagnostics
        end,
      }

      -- Auto-trigger linting on certain events
      lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft, {
        -- Enable auto-linting for these filetypes
        ["*"] = { "typos" }, -- Spelling checker for all files
      })

      -- Set up autocommands for automatic linting
      vim.api.nvim_create_autocmd({
        "BufWritePost",         -- Lint after saving
        "InsertLeave",         -- Lint after leaving insert mode
        "TextChanged",         -- Lint after text changes (debounced)
      }, {
        group = vim.api.nvim_create_augroup("nvim-lint-autocmd", { clear = true }),
        callback = function()
          -- Debounce the linting to avoid too frequent calls
          if vim.b.lint_debounce_active then
            -- If debouncing is already active, skip this call
            return
          end

          local debounce_timer = vim.loop.new_timer()
          -- Timer objects can't be stored as buffer variables
          -- Use a simple boolean flag instead
          vim.b.lint_debounce_active = true

          debounce_timer:start(500, 0, vim.schedule_wrap(function()
            require("lint").try_lint()
            debounce_timer:close()
            vim.b.lint_debounce_active = false
          end))
        end,
      })

      -- Set up autocommand for linting on buffer read (with delay)
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("nvim-lint-bufread", { clear = true }),
        callback = function()
          -- Delay linting on buffer read to avoid conflicts with LSP initialization
          vim.schedule(function()
            require("lint").try_lint()
          end)
        end,
      })

      -- Create user commands
      vim.api.nvim_create_user_command("Lint", function()
        require("lint").try_lint()
      end, { desc = "Run linters for current buffer" })

      vim.api.nvim_create_user_command("LintInfo", function()
        local linters = lint.get_running()
        if #linters == 0 then
          vim.notify("No linters running", vim.log.levels.INFO)
        else
          vim.notify("Running linters: " .. table.concat(linters, ", "), vim.log.levels.INFO)
        end
      end, { desc = "Show running linters" })

      vim.api.nvim_create_user_command("LintReset", function()
        local linters = lint.get_running()
        for _, linter in ipairs(linters) do
          if lint.try_lint then
            vim.schedule(function()
              require("lint").try_lint()
            end)
          end
        end
        vim.notify("Linters reset", vim.log.levels.INFO)
      end, { desc = "Reset all linters" })

      -- Add linting status to statusline (if lualine is available)
      if package.loaded["lualine"] then
        vim.defer_fn(function()
          local lualine = require("lualine")
          if lualine then
            local lint_status = function()
              local linters = require("lint").get_running()
              if #linters == 0 then
                return ""
              end
              return "󱉶 " .. table.concat(linters, ",")
            end

            lualine.setup({
              sections = {
                lualine_c = {
                  {
                    "filename",
                    file_status = true,
                    path = 0,
                  },
                },
                lualine_x = {
                  { lint_status },
                  "encoding",
                  "fileformat",
                  "filetype",
                },
              },
            })
          end
        end, 100)
      end
    end,
  },

  -- Optional: Add Mason integration for automatic linter installation
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Add common linters to Mason's auto-install list
      vim.list_extend(opts.ensure_installed, {
        -- Python
        "ruff",

        -- Lua
        "luacheck",

        -- JavaScript/TypeScript
        "eslint_d",

        -- Go
        "golangci-lint",

        -- Shell
        "shellcheck",

        -- Docker
        "hadolint",

        -- YAML
        "yamllint",

        -- Markdown
        "markdownlint",

        -- C/C++
        "clang-tidy",

        -- General
        "typos",
      })
    end,
  },
}