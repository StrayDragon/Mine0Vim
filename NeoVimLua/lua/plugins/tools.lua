-- 工具类插件配置
-- 包含终端、通知、AI助手、撤销树等功能

return {
	-- Enhanced notification system
	{
		"rcarriga/nvim-notify",
		lazy = false,
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

	-- 撤销树
	{
		"mbbill/undotree",
		lazy = false,
		config = function()
			vim.keymap.set(
				"n",
				"<A-3>",
				":UndotreeToggle<CR>",
				{ noremap = true, silent = true, desc = "切换撤销树" }
			)
		end,
	},

	-- Terminal and zen mode with snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			return {
				-- Terminal configuration - useful floating terminal
				terminal = {
					enabled = true,
					win = {
						position = "float",
						border = "rounded",
						style = "minimal",
						width = 0.8,
						height = 0.8,
					},
				},

				-- Quick file navigation
				quickfile = {
					enabled = true,
					exclude = { "NvimTree", "neo-tree", "dashboard" },
				},

				-- Zen mode for focused work
				zen = {
					enabled = true,
					enter = false,
					fixbuf = false,
					minimal = false,
					width = 120,
					height = 0,
					backdrop = {
						transparent = true,
						blend = 40,
					},
					keys = { q = false },
					zindex = 40,
					wo = {
						winhighlight = "NormalFloat:Normal",
					},
				},

				-- Styles configuration
				styles = {
					notification = {
						wo = { wrap = true },
					},
				},
			}
		end,
		config = function(_, opts)
			require("snacks").setup(opts)

			local snacks = require("snacks")
			local map = vim.keymap.set

			-- Key mappings for useful features
			map("n", "<leader>z", function()
				snacks.zen.toggle()
			end, { noremap = true, silent = true, desc = "Toggle zen mode" })

			map("n", "<leader>tt", function()
				snacks.terminal.toggle()
			end, { noremap = true, silent = true, desc = "Toggle terminal" })

			map("n", "<leader>bd", function()
				snacks.bufdelete()
			end, { noremap = true, silent = true, desc = "Delete buffer" })

			-- Create user commands
			vim.api.nvim_create_user_command("ZenMode", function()
				snacks.zen.toggle()
			end, { desc = "Toggle zen mode" })
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
			log_level = "info",
			-- terminal_cmd = nil, -- Custom terminal command (default: "claude")

			-- Send/Focus Behavior
			focus_after_send = false,

			-- Selection Tracking
			track_selection = true,
			visual_demotion_delay_ms = 50,

			-- Terminal Configuration
			terminal = {
				split_side = "right",
				split_width_percentage = 0.30,
				provider = "auto",
				auto_close = true,
				snacks_win_opts = {},

				-- Provider-specific options
				provider_opts = {
					external_terminal_cmd = nil,
				},
			},

			-- Diff Integration
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
				open_in_current_tab = true,
				keep_terminal_focus = false,
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

