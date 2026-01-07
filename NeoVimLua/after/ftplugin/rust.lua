-- Rust 文件类型插件 - 遵循公共优先原则
-- 基础 LSP 键位在 keymaps.lua 中定义，这里只添加 Rust 特定增强功能

local bufnr = vim.api.nvim_get_current_buf()

-- 覆盖 K 键：使用 rustaceanvim 的增强 hover，避免双窗口问题
vim.keymap.set("n", "K", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = bufnr, desc = "Rust Hover Actions" })

