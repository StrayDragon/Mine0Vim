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

		-- 智能配置：自动同步插件键位，只定义分组和虚拟键位
		config = function(_, opts)
			local wk = require("which-key")

			-- 设置基本配置
			wk.setup(opts)

			-- 核心：只定义分组描述和虚拟键位，实际键位由插件自动注册
			-- 这避免了重复配置，确保 which-key 显示的键位与实际可用键位完全一致
			wk.add({
				-- === 标准布局分组（基于 StdKeymap.md） ===
				-- 优先匹配标准文档，同时保持与现有插件的兼容性

				-- Git 操作分组（gitsigns.nvim 会自动注册键位）
				{ "<leader>h", group = "Git Signs", icon = "🚩 " },
				{ "<leader>hs", desc = "暂存 Hunk" },
				{ "<leader>hr", desc = "重置 Hunk" },
				{ "<leader>hp", desc = "预览 Hunk" },
				{ "<leader>hb", desc = " blame 行" },
				{ "<leader>hd", desc = "diff this" },

				-- g 前缀分组（LSP 导航相关）
				{ "g", group = "LSP 导航", icon = "🔗 " },

				-- === <space> 前缀系列 (CocList 替代) ===
				-- 基于 fzf-lua 的 CocList 功能替代
				{ "<space>", group = "CocList 替代", icon = "📋 " },
				{ "<space>d", desc = "诊断列表 (fzf-lua)" },
				{ "<space>o", desc = "文档大纲 (fzf-lua)" },
				{ "<space>s", desc = "工作区符号 (fzf-lua)" },
				{ "<space>c", desc = "命令面板 (fzf-lua)" },
				{ "<space>q", desc = "快速修复列表 (fzf-lua)" },
				{ "<space>e", desc = "LSP 查找器 (fzf-lua)" },

				-- 文件操作分组（fzf-lua 和 nvim-tree 会自动注册键位）
				{ "<leader>f", group = "文件", icon = "📄 " },

				-- 搜索分组（fzf-lua 会自动注册键位）
				{ "<leader>s", group = "搜索", icon = "🔍 " },

				-- 诊断分组（fzf-lua 会自动注册键位）
				{ "<leader>d", group = "诊断", icon = "🔍 " },
				{ "<leader>de", desc = "显示诊断浮动窗口" },

				-- 工具分组（各种工具会自动注册键位）
				{ "<leader>t", group = "工具", icon = "🛠️ " },

				-- 语言工具分层系统
				{ "<leader>x", group = "语言工具", icon = "🔧 " },

				-- Rust 工具分组（rustaceanvim 和 crates.nvim 会自动注册键位）
				{ "<leader>xr", group = "Rust", icon = "🦀 " },
				-- Cargo 工具子分组（crates.nvim 会自动注册键位）
				{ "<leader>xrc", group = "Cargo 管理", icon = "📦 " },

				-- Python 工具分组
				{ "<leader>xp", group = "Python", icon = "🐍 " },

				-- Lua 工具分组
				{ "<leader>xl", group = "Lua", icon = "🌙 " },

				-- 通用工具分组（refactoring.nvim 会自动注册键位）
				{ "<leader>xa", group = "通用", icon = "🔧 " },

				-- 测试工具分组（neotest 会自动注册键位）
				{ "<leader>t", group = "测试", icon = "🧪 " },

				-- AI/Claude 工具分组（claudecode.nvim 会自动注册键位）
				{ "<leader>i", group = "AI/Claude", icon = "🤖 " },

				-- === 窗口管理分组（由 keymaps.lua 中的键位自动填充） ===
				{ "<leader>S", group = "窗口管理", icon = "🪟 " },

				-- === 标签页分组（由 keymaps.lua 中的键位自动填充） ===
				{ "<leader>T", group = "标签页", icon = "📑 " },

				-- === UI 控制分组 ===
				{ "<leader>u", group = "UI 控制", icon = "🎨 " },

				-- === 标准布局虚拟键位（基于 StdKeymap.md） ===
				-- 这些键位现在在 keymaps.lua 中实际存在，which-key 会自动检测并显示
				{ "<leader>a", desc = "智能代码动作 (路由)" },
				{ "<leader>ra", desc = "代码动作 (当前行)" },
				{ "<leader>ca", desc = "代码动作 (兼容)" },
				{ "<leader>rn", desc = "重命名符号" },
				{ "<leader>rf", desc = "重构菜单" },
				{ "<leader>rl", desc = "CodeLens 动作" },
				{ "<leader>f", desc = "格式化并保存" },
				{ "g[", desc = "上一个诊断" },
				{ "g]", desc = "下一个诊断" },

				-- === 调试分组 (<leader>D) ===
				{ "<leader>D", group = "调试", icon = "🐛 " },
				{ "<leader>Db", desc = "切换断点" },
				{ "<leader>DB", desc = "条件断点" },
				{ "<leader>Dc", desc = "继续/开始调试" },
				{ "<leader>DC", desc = "运行到光标处" },
				{ "<leader>Do", desc = "跳过" },
				{ "<leader>Di", desc = "步入" },
				{ "<leader>DO", desc = "步出" },
				{ "<leader>Dq", desc = "终止调试" },
				{ "<leader>Dr", desc = "重新调试" },
				{ "<leader>Du", desc = "切换调试 UI" },
				{ "<leader>De", desc = "求值表达式" },
				{ "<leader>Ds", desc = "显示调试状态" },

				-- === 插件虚拟键位（现有功能保持） ===
				{ "<leader>ff", desc = "查找文件 (fzf-lua)" },
				{ "<leader>fb", desc = "缓冲区列表 (fzf-lua)" },
				{ "<leader>fg", desc = "全局搜索 (fzf-lua)" },
				{ "<leader>gs", desc = "暂存变更 (gitsigns)" },
				{ "<leader>gr", desc = "重置变更 (gitsigns)" },
				{ "<leader>gp", desc = "预览变更 (gitsigns)" },
				{ "<leader>xra", desc = "Rust 代码动作 (rustaceanvim)" },
				{ "<leader>xrc", desc = "Cargo 管理 (crates.nvim)" },
				{ "<leader>xpa", desc = "Python 代码动作" },
				{ "<leader>xla", desc = "Lua 代码动作" },
				{ "<leader>xar", desc = "重构菜单 (refactoring.nvim)" },
				{ "<leader>ii", desc = "切换 Claude (claudecode.nvim)" },
				{ "<leader>is", desc = "发送到 Claude (claudecode.nvim)" },

				-- === 其他标准布局键位 ===
				{ "gy", desc = "跳转到类型定义" },
				{ "<leader>y", desc = "替换当前单词" },
				{ "gq", desc = "快速修复" },

				-- === g 前缀键位 ===
				{ "gd", desc = "跳转到定义" },
				{ "gr", desc = "查找引用" },
				{ "gi", desc = "跳转到实现" },
				{ "gD", desc = "跳转到声明" },
				{ "gI", desc = "跳转到实现" },
				{ "gK", desc = "Rust 增强悬停" },

				-- === UI 控制键位 ===
				{ "<leader>ui", desc = "切换内联提示" },
				{ "<leader>ud", desc = "切换暗淡模式" },
				{ "<leader>z", desc = "Zen 模式" },

				-- === 其他实用键位 ===
				{ "<leader>nf", desc = "在文件树中查找当前文件" },
			})
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
