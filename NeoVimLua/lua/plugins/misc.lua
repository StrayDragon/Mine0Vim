return {
	-- 快速 UI 和其他杂项功能
	-- { 'tpope/vim-fugitive', lazy = false, config = function()  -- 立即加载 Git 功能
	--     vim.keymap.set('n', '<C-g>', ':Git ', { noremap = true, desc = 'Git command' })
	--   end
	-- },

	-- Git 变更显示 - 高性能浅色边栏标记
	{
		"lewis6991/gitsigns.nvim",
		lazy = false, -- 立即加载，确保Git标记始终显示
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
					change = {
						hl = "GitSignsChange",
						text = "+",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
					delete = {
						hl = "GitSignsDelete",
						text = "-",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					topdelete = {
						hl = "GitSignsDelete",
						text = "‾",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					changedelete = {
						hl = "GitSignsChange",
						text = "~",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
				},
				signcolumn = true, -- 在左侧显示标记
				numhl = false, -- 不在行号上显示标记
				linehl = false, -- 不在整行显示高亮
				word_diff = false, -- 不启用单词级别的diff
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = false, -- 不显示当前行blame信息
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 1000,
				},
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- 使用默认状态格式
				max_file_length = 40000, -- 大文件性能优化
				preview_config = {
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})

			-- Git 操作快捷键
			vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
			vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
			vim.keymap.set("v", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk (visual)" })
			vim.keymap.set("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk (visual)" })
			vim.keymap.set("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage buffer" })
			vim.keymap.set("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
			vim.keymap.set("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset buffer" })
			vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
			vim.keymap.set("n", "<leader>hb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
			vim.keymap.set("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>", { desc = "Diff this" })
			vim.keymap.set("n", "<leader>hD", "<cmd>Gitsigns diffthis ~<CR>", { desc = "Diff this ~" })
			vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Toggle deleted" })

			-- 文本对象支持
			vim.keymap.set({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
		end,
	},
	{
		"mbbill/undotree",
		lazy = false,
		config = function() -- 立即加载撤销树
			vim.keymap.set(
				"n",
				"<A-3>",
				":UndotreeToggle<CR>",
				{ noremap = true, silent = true, desc = "切换撤销树" }
			)
		end,
	},
	-- 代码动作插件 - 替代 vim-quickui
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "ibhagwan/fzf-lua" }, -- 使用 fzf-lua 作为选择器
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
		end,
		keys = {
			{
				"<A-Enter>",
				function()
					require("tiny-code-action").code_action()
				end,
				desc = "LSP Code Actions (Alt+Enter)",
			},
			-- <leader>a 现在由 lsp.lua 中的智能路由系统处理
		},
	},

	-- 增强重构支持（替代 coc.nvim 的许多重构功能）
	{
		"ThePrimeagen/refactoring.nvim",
		lazy = false, -- 立即加载重构工具
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({
				prompt_func_return_type = {
					go = false,
					java = false,
					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				prompt_func_param_type = {
					go = false,
					java = false,
					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				printf_statements = {},
				print_var_statements = {},
			})

			-- Refactoring keymaps (similar to coc.nvim refactoring)
			vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract function" })
			vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" })
			vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable" })
			vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Inline variable" })
			vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline function" })
			vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract block" })
			vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", { desc = "Extract block to file" })

			-- QuickUI integration for refactoring menu
			vim.keymap.set({ "n", "x" }, "<leader>xar", function()
				local items = {
					"🔄 Extract Function",
					"🔄 Extract Variable",
					"🔄 Extract to File",
					"🔄 Inline Variable",
					"🔄 Inline Function",
					"🔄 Extract Block",
					"🔄 Extract Block to File",
				}
				local cmds = {
					"Refactor extract",
					"Refactor extract_var",
					"Refactor extract_to_file",
					"Refactor inline_var",
					"Refactor inline_func",
					"Refactor extract_block",
					"Refactor extract_block_to_file",
				}

				local idx = vim.fn["quickui#listbox#inputlist"](items, {
					title = "Refactoring Menu",
					border = 1,
					index = 1,
					syntax = "cpp",
				})
				if idx and idx > 0 and cmds[idx] then
					vim.cmd(cmds[idx])
				end
			end, { desc = "Refactoring menu" })
		end,
	},

	-- Comments (gc/gcc)
	{ "tpope/vim-commentary", lazy = false }, -- 立即加载注释功能

	-- Cycle through predefined substitutions (gs to cycle)
	{
		"bootleq/vim-cycle",
		lazy = false,
		config = function() -- 立即加载循环替换
			vim.cmd([[
        nmap <silent> gs <Plug>CycleNext
        vmap <silent> gs <Plug>CycleNext
      ]])
		end,
	},

	-- Surround text objects (modern Lua replacement for vim-surround)
	{
		"kylechui/nvim-surround",
		lazy = false, -- 立即加载文本包围功能
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},

	-- Exchange text regions
	-- { 'tommcdo/vim-exchange' },

	-- Async run & tasks (replaced by Neovim built-in functionality)
	-- Removed: asyncrun.vim and asynctasks.vim
	-- Use vim.fn.jobstart() or vim.system() for async tasks

	-- Enhanced fuzzy finder with fzf-lua - immediate load for responsiveness
	{
		"ibhagwan/fzf-lua",
		lazy = false, -- 立即加载，避免首次使用时的延迟
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling setup is optional
			require("fzf-lua").setup({
				-- fzf binary name/path (fzf by default)
				fzf_bin = "fzf",
				-- fzf command line options - ensure floating window
				fzf_opts = {
					["--layout"] = "reverse-list",
					["--height"] = "40%",
					["--border"] = "rounded",
				},
				-- fzf action to open selected item
				fzf_actions = {
					["ctrl-s"] = "split",
					["ctrl-v"] = "vsplit",
					["ctrl-t"] = "tabedit",
					["ctrl-q"] = "close",
				},
				-- winopts = { ... } - see fzf-lua docs for more info
				winopts = {
					preview = {
						-- columns = 120,   -- preview width
						-- rows = 25,       -- preview height
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
				-- keymaps
				keymap = {
					builtin = {
						["<F1>"] = "help",
						["<F2>"] = "toggle-fullscreen",
						-- Only valid with the 'builtin' previewer
						["<F3>"] = "toggle-preview-wrap",
						["<F4>"] = "toggle-preview",
						["<F5>"] = "toggle-preview-ccw",
						["<F6>"] = "toggle-preview-cw",
						["<S-down>"] = "preview-page-down",
						["<S-up>"] = "preview-page-up",
						["<S-left>"] = "preview-page-reset",
					},
					fzf = {
						["ctrl-z"] = "abort",
						["ctrl-u"] = "unix-line-discard",
						["ctrl-f"] = "half-page-down",
						["ctrl-b"] = "half-page-up",
						["ctrl-a"] = "beginning-of-line",
						["ctrl-e"] = "end-of-line",
						["alt-a"] = "toggle-all",
						-- Only valid with fzf previewers (bat/cat/git/etc)
						["f3"] = "toggle-preview-wrap",
						["f4"] = "toggle-preview",
						["shift-down"] = "preview-page-down",
						["shift-up"] = "preview-page-up",
					},
				},
				-- LSP settings
				lsp = {
					timeout = 5000, -- timeout in ms
					async_or_timeout = true, -- asynchronously make LSP requests
					-- use 'ui.select' for code actions when available, fallback to fzf-lua
					code_actions = {
						ui_select_fallback = true,
					},
					-- 符号显示设置
					symbols = {
						async_or_timeout = true,
						symbol_style = 1, -- 1: icon only, 2: symbol name only, 3: both
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
			-- fzf-lua 增强版LSP导航键位（不覆盖基础LSP键位）
			{
				"gD",
				function()
					require("fzf-lua").lsp_declarations()
				end,
				desc = "FZF: Go to Declarations",
			},
			{
				"gR",
				function()
					require("fzf-lua").lsp_references()
				end,
				desc = "FZF: Go to References",
			},
			{
				"gI",
				function()
					require("fzf-lua").lsp_implementations()
				end,
				desc = "FZF: Go to Implementation",
			},
			{
				"gY",
				function()
					require("fzf-lua").lsp_typedefs()
				end,
				desc = "FZF: Go to Type Definition",
			},
			{
				"<leader>w",
				function()
					require("fzf-lua").lsp_workspace_symbols()
				end,
				desc = "Workspace Symbols",
			},
		},
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

	-- Drag visuals replaced by Neovim built-in functionality
	-- Removed: jondkinney/dragvisuals.vim
	-- Use visual block mode (Ctrl+v) and movement commands instead

	-- Rust specific plugins moved to dedicated rust.lua plugin file
	-- This maintains backward compatibility while providing better organization

	-- Enhanced notification system for smart keys
	{
		"rcarriga/nvim-notify",
		lazy = false, -- 立即加载，确保通知系统始终可用
		config = function()
			require("notify").setup({
				-- 动画样式
				stages = "fade_in_slide_out",
				-- 超时时间
				timeout = 3000,
				-- 最大宽度
				max_width = 50,
				-- 最大高度
				max_height = 10,
				-- 渲染样式
				render = "default",
				-- 背景色
				background_colour = "#282828",
				-- 最小级别
				minimum_width = 10,
				-- 图标
				icons = {
					ERROR = "",
					WARN = "",
					INFO = "",
					DEBUG = "",
					TRACE = "✎",
				},
				-- 时间格式
				time_formats = {
					notifier = "%H:%M:%S",
					notification = "%H:%M:%S",
				},
			})

			-- 设置为默认通知函数
			vim.notify = require("notify")
		end,
	},

	-- Claude Code integration
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		version = "^0.3",
		config = true,
		opts = {
			-- Server Configuration
			port_range = { min = 54590, max = 54666 },
			auto_start = true,
			log_level = "info", -- "trace", "debug", "info", "warn", "error"
			-- terminal_cmd = nil, -- Custom terminal command (default: "claude")
			--                     -- For local installations: "~/.claude/local/claude"
			--                     -- For native binary: use output from 'which claude'

			-- Send/Focus Behavior
			-- When true, successful sends will focus the Claude terminal if already connected
			focus_after_send = false,

			-- Selection Tracking
			track_selection = true,
			visual_demotion_delay_ms = 50,

			-- Terminal Configuration
			terminal = {
				split_side = "right", -- "left" or "right"
				split_width_percentage = 0.30,
				provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
				auto_close = true,
				snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below

				-- Provider-specific options
				provider_opts = {
					-- Command for external terminal provider. Can be:
					-- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
					-- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
					-- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
					external_terminal_cmd = nil,
				},
			},

			-- Diff Integration
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
				open_in_current_tab = true,
				keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
			},
		},
		keys = {
			{ "<leader>i", nil, desc = "AI/Claude Code" },
			{ "<leader>ii", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>it",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>ia", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
