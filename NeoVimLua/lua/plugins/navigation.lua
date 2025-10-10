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
				ignore_list = {},
			},
			filesystem_watchers = {
				enable = true,
				debounce_delay = 50,
				ignore_dirs = { ".git", "node_modules", "__pycache__", ".venv", "target", "dist", "build" },
			},
			view = {
				width = { min = 30, max = 45 },
				side = "left",
				float = {
					enable = false,
				},
				preserve_window_proportions = true,
				cursorline = true,
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
		},
		config = function(_, opts)
			local function on_attach(bufnr)
				local api = require("nvim-tree.api")
				local function opts_desc(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.set("n", "l", api.node.open.edit, opts_desc("Open"))
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts_desc("Close Directory"))
			end

			opts.on_attach = on_attach
			require("nvim-tree").setup(opts)

			vim.keymap.set("n", "<A-1>", function()
				require("nvim-tree.api").tree.toggle()
			end, { desc = "Nvim-tree file browser" })

			vim.keymap.set("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>", { desc = "Nvim-tree find current file" })
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
				desc = "Find files",
			},
			{
				"<leader>pb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Find buffers",
			},
			{
				"<leader>pg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>ph",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = "Help tags",
			},
			{
				"<space>d",
				function()
					require("fzf-lua").lsp_workspace_diagnostics()
				end,
				desc = "LSP diagnostics",
			},
			{
				"<space>s",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
				desc = "Workspace symbols",
			},
			{
				"<space>o",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = "Document symbols",
			},
			{
				"<space>c",
				function()
					require("fzf-lua").commands()
				end,
				desc = "Commands",
			},
			{
				"<space>q",
				function()
					require("fzf-lua").quickfix()
				end,
				desc = "Quickfix list",
			},
			{
				"<space>e",
				function()
					require("fzf-lua").lsp_finder()
				end,
				desc = "LSP finder",
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

