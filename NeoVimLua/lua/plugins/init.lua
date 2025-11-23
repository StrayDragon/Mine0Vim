return {
	-- 重构后的插件架构 - 按功能模块组织

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

	-- 标签页管理
	require("plugins.tabby"),

	-- 工作区管理（作为独立插件）
	require("plugins.workspace-manager"),

	-- 编辑增强功能
	require("plugins.editing"),

	-- 工具类插件（通知、终端、AI助手等）
	require("plugins.tools"),

	-- Git 相关功能
	require("plugins.git"),

	-- 重构和代码动作
	require("plugins.refactor"),

	-- 语言专用配置
	require("plugins.rust"),

	-- Which-Key 配置（保持兼容性）
	require("plugins.which-key"),

	-- 杂项工具（已废弃，保留向后兼容）
	require("plugins.misc"),
}
