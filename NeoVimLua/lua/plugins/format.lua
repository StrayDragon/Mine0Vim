return {
	-- Minimal formatting configuration with conform.nvim
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
						-- Check if there are configured formatters for this filetype
						local configured_formatters = conform.formatters_by_ft[vim.bo.filetype]
						if configured_formatters and #configured_formatters > 0 then
							vim.notify(
								string.format(
									"Formatters configured but not available for %s: %s\nRun :Mason to install missing formatters.",
									vim.bo.filetype or "current filetype",
									table.concat(configured_formatters, ", ")
								),
								vim.log.levels.WARN
							)
						else
							vim.notify(
								"No formatters configured for " .. (vim.bo.filetype or "current filetype"),
								vim.log.levels.WARN
							)
						end
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
			-- Format on save
			format_on_save = function(bufnr)
				-- Only format on save if formatters are available
				local conform = require("conform")
				local formatters = conform.list_formatters(bufnr)

				if #formatters == 0 then
					return nil -- Skip formatting
				end

				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,

			-- Formatters by filetype - minimal set only
			formatters_by_ft = {
				python = { "ruff_format" },
				go = { "gofmt" },
				json = { "json-lsp" },
				jsonc = { "json-lsp" },
				jsonp = { "json-lsp" },
				lua = { "stylua" },
				rust = { "rustfmt" },
			},

			-- Default format options
			format = {
				timeout_ms = 1000,
				lsp_fallback = true,
				quiet = false,
			},

			-- Notification settings
			notify_on_error = true,
			log_level = vim.log.levels.WARN,
		},
		init = function()
			-- Configure formatter-specific options
			local formatters = require("conform.formatters")

			-- Configure stylua for 2-space indentation
			formatters.stylua = {
				prepend_args = {
					"--indent-type",
					"Spaces",
					"--indent-width",
					"2",
					"--quote-style",
					"AutoPreferDouble",
				},
			}

			-- Configure yamlfmt for 2-space indentation
			formatters.yamlfmt = {
				prepend_args = {
					"--indent",
					"2",
				},
			}

			-- Configure taplo (TOML formatter) for 2-space indentation
			formatters.taplo = {
				prepend_args = {
					"--option",
					"indent_string=\"  \"",
				},
			}

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
					lsp_fallback = true,
				})
			end, { range = true })

			vim.api.nvim_create_user_command("FormatInfo", function()
				require("conform").info()
			end, {})
		end,
	},
}