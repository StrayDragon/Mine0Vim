-- 编辑增强功能配置
-- 包含文本编辑、移动、包围、注释等功能

return {
	-- Surround text objects (modern Lua replacement for vim-surround)
	{
		"kylechui/nvim-surround",
		lazy = false,
		version = "*",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},

	-- Comments (gc/gcc)
	{ "tpope/vim-commentary", lazy = false },

	-- Cycle through predefined substitutions (gs to cycle)
	{
		"bootleq/vim-cycle",
		lazy = false,
		config = function()
			vim.cmd([[
        nmap <silent> gs <Plug>CycleNext
        vmap <silent> gs <Plug>CycleNext
      ]])
		end,
	},

	-- Multi-cursor support (vim-visual-multi)
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			-- Map <C-d> to add next occurrence, <C-c> to skip current region
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
				["Find Subword Under"] = "<C-d>",
				["Skip Region"] = "<C-c>",
			}
		end,
	},

	-- Enhanced text editing with snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			return {
				-- Big file handling - essential for performance
				bigfile = {
					enabled = true,
					notify = true,
					size = 1.5 * 1024 * 1024, -- 1.5MB threshold
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
							string.format(
								"Large file detected (%.2fMB). Performance optimizations applied.",
								ctx.size / (1024 * 1024)
							),
							vim.log.levels.INFO,
							{ title = "Big File Mode" }
						)
					end,
				},

				-- Words configuration for text navigation
				words = {
					enabled = true,
					jump = {
						freq = 100,
					},
				},

				-- Scrolling enhancement
				scroll = {
					enabled = true,
					animate = {
						easing = "outQuad",
						duration = { step = 10, total = 150 },
					},
				},

				-- Status column configuration
				statuscolumn = {
					enabled = true,
					left = { "mark", "sign" },
					right = { "fold", "git" },
				},
			}
		end,
		config = function(_, opts)
			require("snacks").setup(opts)

			local snacks = require("snacks")

			-- Create user commands
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

