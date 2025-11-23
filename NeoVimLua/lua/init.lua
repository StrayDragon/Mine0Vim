require("config.lazy")
require("config.options")
require("config.keymaps")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "onenord", "edge", "habamax" } },
	checker = { enabled = true },
	-- 配置本地开发插件
	dev = {
		path = "~/.config/nvim/plugins",
		patterns = { "workspace-manager" },
		fallback = false,
	},
})

-- 设置 OneNord 主题
vim.cmd.colorscheme("onenord")
