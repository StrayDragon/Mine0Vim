-- 核心插件配置
-- 包含基础设置、treesitter、which-key 等核心功能

return {
	-- Treesitter 语法高亮引擎
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = { "python", "lua", "rust", "go", "vim", "vimdoc", "markdown", "markdown_inline" },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-s>",
					node_incremental = "<C-s>",
					node_decremental = "[[",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects", lazy = false },

	-- Which-Key 键位提示 (已迁移到 plugins/which-key.lua)
	-- 保留空的配置以确保向后兼容
}

