-- 核心插件配置
-- 包含基础设置、treesitter、which-key 等核心功能

return {
	-- Treesitter 语法高亮引擎
	-- NOTE: nvim-treesitter `main` 分支是全新重写，需要 Neovim 0.12+。
	-- 旧的 `master` 分支与 0.12 不兼容（高亮时报
	--   languagetree.lua:215 ... treesitter.lua:197: attempt to call method 'range' (a nil value)）
	-- 新版 API：require("nvim-treesitter").setup/install；高亮由 Neovim 内置
	-- vim.treesitter.start() 提供，不再有 configs.setup/ensure_installed/incremental_selection。
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({})
			-- 异步安装解析器（已安装则 no-op）；依赖 tree-sitter-cli (>=0.26.1)
			require("nvim-treesitter").install({
				"bash", "c", "cpp", "json", "lua", "luadoc", "markdown", "markdown_inline",
				"python", "rust", "toml", "vim", "vimdoc", "yaml",
			})
			-- 为已安装解析器的 filetype 启用内置高亮与 foldexpr
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ts-start", { clear = true }),
				callback = function(args)
					-- start 失败说明该 filetype 无已安装解析器，保持全局 indent 折叠
					if pcall(vim.treesitter.start, args.buf) then
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
						vim.wo.foldmethod = "expr"
					end
				end,
			})
		end,
	},
	-- 文本对象（main 分支版，需要手动定义映射）
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = false,
		branch = "main",
		config = function()
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local function sel(mode, lhs, obj)
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(obj, mode)
				end)
			end
			sel("textobjects", "af", "@function.outer")
			sel("textobjects", "if", "@function.inner")
			sel("textobjects", "ac", "@class.outer")
			sel("textobjects", "ic", "@class.inner")
			local function nav(lhs, fn, obj, desc)
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					fn(obj, "textobjects")
				end, { desc = desc })
			end
			nav("]m", move.goto_next_start, "@function.outer", "下一个函数")
			nav("[m", move.goto_previous_start, "@function.outer", "上一个函数")
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Which-Key 键位提示 (已迁移到 plugins/which-key.lua)
	-- 保留空的配置以确保向后兼容
}

