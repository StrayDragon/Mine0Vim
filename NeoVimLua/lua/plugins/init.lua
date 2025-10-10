return {
	-- 简化的插件架构 - 按功能模块组织

	-- 核心基础插件
	require("plugins.core"),

	-- 代码工具（补全、格式化、检查）
	require("plugins.code"),

	-- 导航和搜索工具
	require("plugins.navigation"),

	-- LSP 和语言服务器配置
	require("plugins.lsp"),

	-- 调试工具配置
	require("plugins.debug"),

	-- UI 和界面插件
	require("plugins.ui"),

	-- 缓冲区管理
	require("plugins.buffer"),

	-- 杂项工具
	require("plugins.misc"),

	-- 性能优化
	require("plugins.performance"),

	-- 语言专用配置
	require("plugins.rust"),

	-- Which-Key 配置（保持兼容性）
	require("plugins.which-key"),
}
