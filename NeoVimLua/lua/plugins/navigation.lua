-- 导航和搜索工具配置
-- 包含文件管理、搜索、大纲等功能

return {
	-- 文件管理器
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			hijack_netrw = false,
			auto_reload_on_write = true,
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			filesystem_watchers = {
				enable = true,
				debounce_delay = 50,
				ignore_dirs = { ".git", "node_modules", "__pycache__", ".venv", "target", "dist", "build" },
			},
			view = {
				width = 30,
				side = "left",
				preserve_window_proportions = true,
				cursorline = true,
				number = false,
				relativenumber = false,
			},
			renderer = {
				group_empty = true,
				indent_markers = {
					enable = true,
				},
				icons = {
					webdev_colors = true,
					git_placement = "signcolumn",
					show = {
						file = true,
						folder = true,
						git = true,
						modified = true,
					},
				},
			},
			git = {
				enable = true,
				timeout = 400,
			},
			diagnostics = {
				enable = true,
				debounce_delay = 50,
			},
			filters = {
				git_ignored = true,
				dotfiles = false,
				custom = {
					".git",
					"node_modules",
					"__pycache__",
					".pytest_cache",
					".mypy_cache",
					".coverage",
					"target",
					"dist",
					"build",
					".DS_Store",
					"*.pyc",
					"*.pyo",
					".venv",
					"venv",
					"env",
					".env",
				},
			},
			actions = {
				open_file = {
					quit_on_open = false,
				},
			},
		},
		config = function(_, opts)
			local api = require("nvim-tree.api")

			local function on_attach(bufnr)
				local function opts_desc(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)

				-- 简化的导航
				vim.keymap.set("n", "l", api.node.open.edit, opts_desc("打开"))
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts_desc("关闭目录"))
				vim.keymap.set("n", "L", api.node.open.vertical, opts_desc("垂直分割打开"))
				vim.keymap.set("n", "H", api.tree.collapse_all, opts_desc("折叠全部"))
				vim.keymap.set("n", "<C-t>", api.node.open.tab, opts_desc("标签页打开"))
				vim.keymap.set("n", "o", api.node.open.edit, opts_desc("打开"))
				vim.keymap.set("n", "e", api.node.open.edit, opts_desc("打开"))

				-- 文件操作
				vim.keymap.set("n", "a", api.fs.create, opts_desc("创建"))
				vim.keymap.set("n", "d", api.fs.remove, opts_desc("删除"))
				vim.keymap.set("n", "r", api.fs.rename, opts_desc("重命名"))
				vim.keymap.set("n", "c", api.fs.copy.node, opts_desc("复制"))
				vim.keymap.set("n", "x", api.fs.cut, opts_desc("剪切"))
				vim.keymap.set("n", "p", api.fs.paste, opts_desc("粘贴"))
				vim.keymap.set("n", "y", api.fs.copy.filename, opts_desc("复制名称"))

				-- 导航
				vim.keymap.set("n", "J", api.node.navigate.sibling.next, opts_desc("下一个兄弟"))
				vim.keymap.set("n", "K", api.node.navigate.sibling.prev, opts_desc("上一个兄弟"))
				vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts_desc("垂直分割"))
				vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts_desc("水平分割"))

				-- 帮助
				vim.keymap.set("n", "?", api.tree.toggle_help, opts_desc("帮助"))
			end

			opts.on_attach = on_attach
			require("nvim-tree").setup(opts)

			-- 简化的按键映射
			vim.keymap.set("n", "<A-1>", function()
				api.tree.toggle()
			end, { desc = "切换文件树" })

			vim.keymap.set("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>", { desc = "文件树定位当前文件" })
		end,
	},

	-- 模糊查找
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				fzf_opts = {
					["--layout"] = "reverse-list",
					["--height"] = "40%",
					["--border"] = "rounded",
				},
				fzf_actions = {
					["ctrl-s"] = "split",
					["ctrl-v"] = "vsplit",
					["ctrl-t"] = "tabedit",
					["ctrl-q"] = "close",
				},
				winopts = {
					preview = {
						border = "rounded",
						title = "Preview",
						title_pos = "center",
					},
					window = {
						width = 0.85,
						height = 0.85,
						border = "rounded",
					},
				},
				lsp = {
					timeout = 5000,
					code_actions = {
						ui_select_fallback = true,
					},
					symbols = {
						symbol_icons = {
							File = "󰈙",
							Module = "",
							Namespace = "󰦮",
							Package = "",
							Class = "󰆧",
							Method = "󰊕",
							Property = "",
							Field = "",
							Constructor = "",
							Enum = "",
							Interface = "",
							Function = "󰊕",
							Variable = "󰀫",
							Constant = "󰏿",
							String = "",
							Number = "󰎠",
							Boolean = "󰨙",
							Array = "󱡠",
							Object = "",
							Key = "󰌋",
							Null = "󰟢",
							EnumMember = "",
							Struct = "󰆼",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "󰗴",
						},
					},
				},
			})
		end,
		keys = {
			{
				"<leader>pf",
				function()
					require("fzf-lua").files()
				end,
				desc = "查找文件",
			},
			{
				"<leader>pb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "查找缓冲区",
			},
			{
				"<leader>pg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "实时搜索",
			},
			{
				"<leader>ph",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = "帮助标签",
			},
			{
				"<space>d",
				function()
					require("fzf-lua").lsp_workspace_diagnostics()
				end,
				desc = "LSP 诊断",
			},
			{
				"<space>s",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
				desc = "工作区符号",
			},
			{
				"<space>o",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = "文档符号",
			},
			{
				"<space>c",
				function()
					require("fzf-lua").commands()
				end,
				desc = "命令",
			},
			{
				"<space>q",
				function()
					require("fzf-lua").quickfix()
				end,
				desc = "快速修复列表",
			},
			{
				"<space>e",
				function()
					require("fzf-lua").lsp_finder()
				end,
				desc = "LSP 查找器",
			},
		},
	},

	-- 代码大纲
	{
		"stevearc/aerial.nvim",
		opts = {},
		keys = {
			{ "<A-7>", "<cmd>AerialToggle!<CR>", mode = "n", desc = "切换大纲视图" },
			{ "<space>ao", "<cmd>AerialToggle!<CR>", mode = "n", desc = "切换大纲视图" },
		},
	},
}