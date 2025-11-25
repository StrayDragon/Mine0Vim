return {
	-- OneNord 主题
	{
		"rmehri01/onenord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onenord").setup({
				theme = "dark",
				borders = true,
				disable = { eob_lines = true },
			})
		end,
	},

	-- Alpha 启动界面
	{
		"goolord/alpha-nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			-- 检查并设置文件图标
			if dashboard.file_icons then
				dashboard.file_icons.provider = "devicons"
			end

			-- 设置自定义头部
			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
				"                                                     ",
				"                🚀 Neovim Ready!                     ",
				"                                                     ",
			}

			-- 设置快捷按钮
			dashboard.section.buttons.val = {
				dashboard.button("e", "📄 New file", ":ene <BAR> startinsert<CR>"),
				dashboard.button("f", "🔍 Find file", ":FzfLua files<CR>"),
				dashboard.button("r", "📚 Recent files", ":FzfLua oldfiles<CR>"),
				dashboard.button("g", "🔎 Grep", ":FzfLua live_grep<CR>"),
				dashboard.button("s", "⚙️  Settings", ":e ~/.config/nvim/lua/config/options.lua<CR>"),
				dashboard.button("u", "🔧 Update", ":Lazy sync<CR>"),
				dashboard.button("q", "💤 Quit", ":qa<CR>"),
			}

			-- 设置 footer
			dashboard.section.footer.val = "Happy Coding! 🎉"

			-- 配置布局
			local opts = {
				layout = {
					{ type = "padding", val = 2 },
					dashboard.section.header,
					{ type = "padding", val = 2 },
					dashboard.section.buttons,
					{ type = "padding", val = 1 },
					dashboard.section.footer,
				},
				opts = {
					margin = 5,
					setup = function()
						vim.cmd([[
						augroup AlphaCommands
						autocmd!
						autocmd User AlphaReady silent! set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
						augroup END
						]])
					end,
				},
			}

			require("alpha").setup(opts)
		end,
	},

	-- 状态栏
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "onenord",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "NvimTree", "fzf", "FzfLua", "dap-repl", "alpha" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}

