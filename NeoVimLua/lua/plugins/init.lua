return {
	-- 按域分离插件规范；保持根最小化

	-- 加载专用 Rust 配置
	require("plugins.rust"),

	-- 加载调试配置
	require("plugins.dap"),

	-- 加载 Which-Key 快捷键提示配置
	require("plugins.which-key"),
}

