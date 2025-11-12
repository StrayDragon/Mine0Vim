-- Which-Key.nvim 统一配置架构
-- 自动同步插件键位映射，避免重复配置

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- 使用现代预设
			preset = "modern",

			-- 延迟配置：插件延迟0，其他映射200ms
			delay = function(ctx)
				return ctx.plugin and 0 or 200
			end,

			-- 智能过滤器：自动检测有描述的映射，排除内部映射
			filter = function(mapping)
				-- 排除 which-key 内部触发器
				if mapping.desc == "which-key-trigger" then
					return false
				end
				-- 只显示有描述的映射
				return mapping.desc and mapping.desc ~= ""
			end,

			-- 使用内置触发器，让 which-key 自动处理
			triggers = {
				{ "<auto>", mode = "nxso" },
			},

			-- 启用内置插件
			plugins = {
				marks = true,
				registers = true,
				spelling = {
					enabled = true,
					suggestions = 20,
				},
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			},

			-- 现代窗口配置
			win = {
				no_overlap = true,
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				zindex = 1000,
				wo = {
					winblend = 10,
				},
			},

			-- 布局配置
			layout = {
				width = { min = 20, max = 50 },
				spacing = 3,
				align = "left",
			},

			-- 排序配置
			sort = { "local", "order", "group", "alphanum", "mod" },

			-- 图标配置（使用内置图标）
			icons = {
				mappings = true,
				colors = true,
				keys = {
					Up = " ",
					Down = " ",
					Left = " ",
					Right = " ",
					C = "󰘴 ",
					M = "󰘵 ",
					D = "󰘳 ",
					S = "󰘶 ",
					CR = "󰌑 ",
					Esc = "󱊷 ",
					Space = "󱁐 ",
					Tab = "󰌒 ",
				},
			},

			-- 显示配置
			show_help = true,
			show_keys = true,
			notify = true,

			-- 禁用某些文件类型
			disable = {
				ft = { "TelescopePrompt", "NvimTree", "neo-tree", "fzf", "FzfLua" },
				bt = { "prompt", "nofile" },
			},
		},

		-- 完全自动发现模式：无任何手动定义
		config = function(_, opts)
			local wk = require("which-key")

			-- 设置基本配置
			wk.setup(opts)

			-- 完全依赖自动发现：所有键位和分组都通过 vim.keymap.set 的 desc 自动识别
			-- 这确保了零重复、零不同步，键位显示与实际功能完全一致
			-- 不需要手动定义任何分组或虚拟键位
		end,

		-- 快捷键绑定 - 只保留最有用的
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({
						global = false,
						-- 自动显示当前缓冲区的所有相关键位
						filter = function(mapping)
							return mapping.desc and mapping.desc ~= "" and mapping.desc ~= "which-key-trigger"
						end,
					})
				end,
				desc = "本地缓冲区键位",
			},
		},
	},
}
