return {
  -- Minimal linting configuration with nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype - minimal set only
      lint.linters_by_ft = {
        python = { "ruff" },
        go = { "golangci-lint" },
        lua = { "luacheck" },
        rust = { "clippy" },
      }

      -- Auto-trigger linting on certain events
      vim.api.nvim_create_autocmd({
        "BufWritePost",     -- Lint after saving
        "InsertLeave",     -- Lint after leaving insert mode
        "TextChanged",     -- Lint after text changes (debounced)
      }, {
        group = vim.api.nvim_create_augroup("nvim-lint-autocmd", { clear = true }),
        callback = function()
          -- Debounce the linting to avoid too frequent calls
          if vim.b.lint_debounce_active then
            return
          end

          local debounce_timer = vim.loop.new_timer()
          vim.b.lint_debounce_active = true

          debounce_timer:start(500, 0, vim.schedule_wrap(function()
            -- Only try to lint if linters are available for this filetype
            local linters = lint.linters_by_ft[vim.bo.filetype]
            if linters and #linters > 0 then
              require("lint").try_lint()
            end
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
            -- Only try to lint if linters are available for this filetype
            local linters = lint.linters_by_ft[vim.bo.filetype]
            if linters and #linters > 0 then
              require("lint").try_lint()
            end
          end)
        end,
      })

      -- Create user commands
      vim.api.nvim_create_user_command("Lint", function()
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if not linters or #linters == 0 then
          vim.notify("No linters configured for " .. (vim.bo.filetype or "current filetype"), vim.log.levels.WARN)
          return
        end
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
    end,
  },
}