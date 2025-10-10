-- 代码工具配置
-- 包含补全、格式化、检查等功能

return {
	-- Mini.snippets 配置
	{
		"echasnovski/mini.snippets",
		lazy = false,
		config = function()
			require("mini.snippets").setup({
				-- Global snippets
				snippets = {
					-- 可以在这里添加全局代码片段
				},
				-- Filetype-specific snippets
				filetypes = {
					lua = {
						-- Lua 特定代码片段
					},
					python = {
						-- Python 特定代码片段
					},
				},
			})
		end,
	},

	-- Blink.cmp 补全引擎 - 最新版本 v1.7.0
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"nvim-tree/nvim-web-devicons",
			"echasnovski/mini.snippets",
		},
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<C-Space>"] = { "show", "show_documentation" },
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },
			},
			completion = {
				list = {
					selection = { preselect = true, auto_insert = true },
				},
				menu = {
					border = "rounded",
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = true },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = { min_keyword_length = 1 },
					path = { min_keyword_length = 1 },
					snippets = { min_keyword_length = 1 },
				},
			},
			snippets = { preset = "mini_snippets" },
		},
	},

	-- 代码格式化
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					local conform = require("conform")
					local formatters = conform.list_formatters(0)

					if #formatters == 0 then
						vim.notify(
							"No formatters available for " .. (vim.bo.filetype or "current filetype"),
							vim.log.levels.WARN
						)
						return
					end

					conform.format({
						async = true,
						lsp_fallback = true,
						timeout_ms = 1000,
					})
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			format_on_save = function(bufnr)
				local conform = require("conform")
				local formatters = conform.list_formatters(bufnr)

				if #formatters == 0 then
					return nil
				end

				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,
			formatters_by_ft = {
				python = { "ruff_format" },
				go = { "gofmt" },
				json = { "prettierd", "prettier", "json-lsp" },
				jsonc = { "prettierd", "prettier", "json-lsp" },
				jsonp = { "prettierd", "prettier", "json-lsp" },
				lua = { "stylua" },
				rust = { "rustfmt" },
			},
			format = {
				timeout_ms = 1000,
				lsp_fallback = true,
				quiet = false,
			},
			notify_on_error = true,
			log_level = vim.log.levels.WARN,
		},
	},

	-- 代码检查
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" },
				go = { "golangci-lint" },
				lua = { "luacheck" },
				rust = { "clippy" },
			}

			vim.api.nvim_create_autocmd({
				"BufWritePost",
				"InsertLeave",
				"TextChanged",
			}, {
				group = vim.api.nvim_create_augroup("nvim-lint-autocmd", { clear = true }),
				callback = function()
					if vim.b.lint_debounce_active then
						return
					end

					local debounce_timer = vim.loop.new_timer()
					vim.b.lint_debounce_active = true

					debounce_timer:start(
						500,
						0,
						vim.schedule_wrap(function()
							local linters = lint.linters_by_ft[vim.bo.filetype]
							if linters and #linters > 0 then
								require("lint").try_lint()
							end
							debounce_timer:close()
							vim.b.lint_debounce_active = false
						end)
					)
				end,
			})

			vim.api.nvim_create_user_command("Lint", function()
				require("lint").try_lint()
			end, { desc = "Run linters for current buffer" })
		end,
	},
}

