return {
	"romgrk/barbar.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- for file icons
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		-- 最小化配置
		animation = false,
		clickable = true,
		focus_on_close = "right",

		-- 禁用复杂高亮
		highlight_alternate = false,
		highlight_inactive_file_icons = false,
		highlight_visible = false,

		-- 简化图标
		icons = {
			buffer_index = true,
			buffer_number = false,
			button = "×",
			diagnostics = {
				[vim.diagnostic.severity.ERROR] = { enabled = false },
				[vim.diagnostic.severity.WARN] = { enabled = false },
				[vim.diagnostic.severity.INFO] = { enabled = false },
				[vim.diagnostic.severity.HINT] = { enabled = false },
			},
			filetype = { enabled = true },
			separator = { left = "", right = "" },
			separator_at_end = false,
			modified = { button = "" },
			pinned = { button = "", filename = false },
			current = { buffer_index = false },
			inactive = { buffer_index = false },
			visible = { buffer_index = false },
		},

		-- 简化设置
		maximum_length = 25,
		maximum_padding = 1,
		minimum_length = 8,
		semantic_letters = false,

		-- 侧边栏文件类型
		sidebar_filetypes = {
			NvimTree = { event = "BufWipeout", text = "Files" },
			undotree = { text = "Undo" },
			["neo-tree"] = { event = "BufWipeout", text = "Files" },
			Outline = { event = "BufWinLeave", text = "Outline" },
		},

		no_name_title = "[No Name]",
		preset = "minimal",
		tabline = false,
	},
	config = function(_, opts)
		require("barbar").setup(opts)

		-- Buffer navigation
		vim.keymap.set("n", "<Leader>1", "<Cmd>BufferGoto 1<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>2", "<Cmd>BufferGoto 2<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>3", "<Cmd>BufferGoto 3<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>4", "<Cmd>BufferGoto 4<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>5", "<Cmd>BufferGoto 5<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>6", "<Cmd>BufferGoto 6<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>7", "<Cmd>BufferGoto 7<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>8", "<Cmd>BufferGoto 8<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>9", "<Cmd>BufferGoto 9<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>0", "<Cmd>BufferLast<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>q", "<Cmd>BufferClose<CR>", { silent = true })

		-- Buffer pick mode
		vim.keymap.set("n", "<Leader>p", "<Cmd>BufferPick<CR>", { silent = true })
	end,
}
