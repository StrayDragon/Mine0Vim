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
					quit_on_focus_loss = true,
					open_win_config = {
						relative = "editor",
						border = "rounded",
						width = 50,
						height = 0.8,
						row = "center",
						col = "center",
					},
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
			actions = {
				open_file = {
					quit_on_open = false,
				},
			},
		},
		config = function(_, opts)
			local api = require("nvim-tree.api")

			-- Preset configurations similar to coc-explorer
			local presets = {
				left = {
					view = {
						side = "left",
						float = { enable = false },
					},
					actions = {
						open_file = { quit_on_open = false },
					},
				},
				right = {
					view = {
						side = "right",
						float = { enable = false },
					},
					actions = {
						open_file = { quit_on_open = false },
					},
				},
				tab = {
					view = {
						tab = {
							sync = {
								open = true,
								close = true,
							},
						},
						float = { enable = false },
					},
					actions = {
						open_file = { quit_on_open = true },
					},
				},
				floating = {
					view = {
						float = {
							enable = true,
							quit_on_focus_loss = true,
							open_win_config = {
								relative = "editor",
								border = "rounded",
								width = 80,
								height = 0.8,
								row = "center",
								col = "center",
							},
						},
					},
					actions = {
						open_file = { quit_on_open = true },
					},
				},
				floating_top = {
					view = {
						float = {
							enable = true,
							quit_on_focus_loss = true,
							open_win_config = {
								relative = "editor",
								border = "rounded",
								width = 80,
								height = 0.6,
								row = 0,
								col = "center",
							},
						},
					},
					actions = {
						open_file = { quit_on_open = true },
					},
				},
				floating_left = {
					view = {
						float = {
							enable = true,
							quit_on_focus_loss = true,
							open_win_config = {
								relative = "editor",
								border = "rounded",
								width = 50,
								height = 0.8,
								row = "center",
								col = 0,
							},
						},
					},
					actions = {
						open_file = { quit_on_open = true },
					},
				},
				floating_right = {
					view = {
						float = {
							enable = true,
							quit_on_focus_loss = true,
							open_win_config = {
								relative = "editor",
								border = "rounded",
								width = 50,
								height = 0.8,
								row = "center",
								col = "right",
							},
						},
					},
					actions = {
						open_file = { quit_on_open = true },
					},
				},
				buffer = {
					filters = {
						git_ignored = false,
						dotfiles = true,
						custom = {},
					},
					renderer = {
						group_empty = false,
					},
				},
			}

			-- Function to apply preset
			local function apply_preset(preset_name)
				local preset = presets[preset_name]
				if not preset then
					vim.notify("Preset not found: " .. preset_name, vim.log.levels.ERROR)
					return
				end

				-- Merge preset with default options
				local merged_opts = vim.tbl_deep_extend("force", opts, preset)

				-- Close existing tree if open
				api.tree.close()

				-- Apply new configuration
				require("nvim-tree").setup(merged_opts)

				-- Open tree with new configuration
				api.tree.open()
			end

			local function on_attach(bufnr)
				local function opts_desc(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)

				-- Enhanced navigation similar to coc-explorer
				vim.keymap.set("n", "l", api.node.open.edit, opts_desc("Open"))
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts_desc("Close Directory"))
				vim.keymap.set("n", "L", api.node.open.vertical, opts_desc("Vsplit Open"))
				vim.keymap.set("n", "H", api.tree.collapse_all, opts_desc("Collapse All"))
				vim.keymap.set("n", "<C-t>", api.node.open.tab, opts_desc("Tab Open"))
				vim.keymap.set("n", "o", api.node.open.edit, opts_desc("Open"))
				vim.keymap.set("n", "e", api.node.open.edit, opts_desc("Open"))

				-- File operations similar to coc-explorer
				vim.keymap.set("n", "a", api.fs.create, opts_desc("Create"))
				vim.keymap.set("n", "d", api.fs.remove, opts_desc("Delete"))
				vim.keymap.set("n", "r", api.fs.rename, opts_desc("Rename"))
				vim.keymap.set("n", "c", api.fs.copy.node, opts_desc("Copy"))
				vim.keymap.set("n", "x", api.fs.cut, opts_desc("Cut"))
				vim.keymap.set("n", "p", api.fs.paste, opts_desc("Paste"))
				vim.keymap.set("n", "y", api.fs.copy.filename, opts_desc("Copy Name"))

				-- Navigation
				vim.keymap.set("n", "J", api.node.navigate.sibling.next, opts_desc("Next Sibling"))
				vim.keymap.set("n", "K", api.node.navigate.sibling.prev, opts_desc("Prev Sibling"))
				vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts_desc("Vsplit"))
				vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts_desc("Split"))

				-- Toggle help
				vim.keymap.set("n", "?", api.tree.toggle_help, opts_desc("Help"))
			end

			opts.on_attach = on_attach
			require("nvim-tree").setup(opts)

			-- Key mappings for different presets (similar to coc-explorer)
			vim.keymap.set("n", "<space>ed", function() apply_preset("left") end, { desc = "Nvim-tree: Left preset" })
			vim.keymap.set("n", "<space>ef", function() apply_preset("floating") end, { desc = "Nvim-tree: Floating preset" })
			vim.keymap.set("n", "<space>et", function() apply_preset("tab") end, { desc = "Nvim-tree: Tab preset" })
			vim.keymap.set("n", "<space>eb", function() apply_preset("buffer") end, { desc = "Nvim-tree: Buffer preset" })
			vim.keymap.set("n", "<space>er", function() apply_preset("right") end, { desc = "Nvim-tree: Right preset" })
			vim.keymap.set("n", "<space>eT", function() apply_preset("floating_top") end, { desc = "Nvim-tree: Floating Top preset" })
			vim.keymap.set("n", "<space>eL", function() apply_preset("floating_left") end, { desc = "Nvim-tree: Floating Left preset" })
			vim.keymap.set("n", "<space>eR", function() apply_preset("floating_right") end, { desc = "Nvim-tree: Floating Right preset" })

			-- Default mappings
			vim.keymap.set("n", "<A-1>", function()
				api.tree.toggle()
			end, { desc = "Nvim-tree file browser" })

			vim.keymap.set("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>", { desc = "Nvim-tree find current file" })
			vim.keymap.set("n", "<leader>ee", function() apply_preset("left") end, { desc = "Nvim-tree: Default left view" })
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

