-- 键位映射配置 - 统一描述系统
local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "" }

-- 取消 s 和 S 映射以避免与 leader+s 和 leader+S 冲突
map({ "n", "x", "o" }, "s", "<nop>", { desc = "禁用以避免冲突" })
map({ "n", "x", "o" }, "S", "<nop>", { desc = "禁用以避免冲突" })

-- === 统一基础LSP键位（跨编辑器通用） ===
-- 这些键位在所有支持LSP的编辑器中保持一致，减少学习成本

-- LSP导航（通用标准）
map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "跳转到定义" }))
map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "查找引用" }))
map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "跳转到实现" }))
map("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "跳转到类型定义" }))

-- LSP帮助和诊断
map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "悬停帮助" }))
map("n", "gq", function()
	-- 快速修复，优先使用quickfix类型的代码动作
	vim.lsp.buf.code_action({
		context = { only = { "quickfix" } },
	})
end, vim.tbl_extend("force", opts, { desc = "快速修复" }))

-- 诊断导航 (标准布局：g[/g])
map("n", "g[", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, vim.tbl_extend("force", opts, { desc = "上一个诊断" }))

map("n", "g]", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, vim.tbl_extend("force", opts, { desc = "下一个诊断" }))

-- 代码动作已移至 lsp.lua 智能路由实现
map("n", "<leader>ra", function()
	-- 对当前行执行代码动作
	vim.lsp.buf.code_action({
		context = {
			diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
			only = { "quickfix", "refactor" },
		},
	})
end, vim.tbl_extend("force", opts, { desc = "代码动作 (当前行)" }))

-- 保留兼容性：现有代码动作键位
map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "代码动作" }))
map("x", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "代码动作" }))

-- 重命名（所有语言统一）
map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "重命名符号" }))

-- 重构菜单（标准布局 - 利用 refactoring.nvim）
map("n", "<leader>rf", function()
	-- 调用 refactoring.nvim 的重构菜单
	require("refactoring").select_refactor()
end, vim.tbl_extend("force", opts, { desc = "重构菜单" }))

-- 格式化（所有语言统一 - 标准布局：格式化并保存）
map("n", "<leader>f", function()
	vim.lsp.buf.format({ async = false })
	vim.cmd("update") -- 保存文件
end, vim.tbl_extend("force", opts, { desc = "格式化并保存" }))
map("x", "<leader>f", function()
	vim.lsp.buf.format({ async = false })
	vim.cmd("update") -- 保存文件
end, vim.tbl_extend("force", opts, { desc = "格式化并保存" }))

-- 工作区符号（所有语言统一 - 基础版本）
map(
	"n",
	"<leader>ws",
	vim.lsp.buf.workspace_symbol,
	vim.tbl_extend("force", opts, { desc = "工作区符号 (基础)" })
)

-- 工作区符号（增强版本 - 使用 fzf-lua）
map("n", "<leader>wsf", function()
	require("fzf-lua").lsp_workspace_symbols()
end, vim.tbl_extend("force", opts, { desc = "工作区符号 (fzf)" }))

-- Terminal模式相关键位
vim.cmd([[
  cnoremap <c-h> <left>
  cnoremap <c-j> <down>
  cnoremap <c-k> <up>
  cnoremap <c-l> <right>
  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-f> <c-d>
  cnoremap <c-b> <left>
  cnoremap <c-d> <del>
  cnoremap <c-_> <c-k>
]])

-- 窗口切换
map("n", "gw", "<C-w>w", vim.tbl_extend("force", opts, { desc = "切换窗口" }))

-- 替换当前单词
map("n", "<Leader>y", [[:%s/<C-r><C-w>/]], vim.tbl_extend("force", opts, { desc = "替换当前单词" }))
-- 复制所有内容到系统剪贴板
map(
	"n",
	"<Leader>Y",
	[[ggVG"+y<CR><C-o><C-o>]],
	vim.tbl_extend("force", opts, { desc = "复制所有内容到系统剪贴板" })
)

-- 窗口分割（<leader>S 分组）
map("n", "<Leader>SL", ":set splitright<CR>:vsplit<CR>", vim.tbl_extend("force", opts, { desc = "右侧垂直分割" }))
map(
	"n",
	"<Leader>SH",
	":set nosplitright<CR>:vsplit<CR>",
	vim.tbl_extend("force", opts, { desc = "左侧垂直分割" })
)
map(
	"n",
	"<Leader>SK",
	":set nosplitbelow<CR>:split<CR>",
	vim.tbl_extend("force", opts, { desc = "上方水平分割" })
)
map("n", "<Leader>SJ", ":set splitbelow<CR>:split<CR>", vim.tbl_extend("force", opts, { desc = "下方水平分割" }))

-- 移动分割布局
map("n", "<Leader>Sr", "<C-w>t<C-w>H<Esc>", vim.tbl_extend("force", opts, { desc = "水平转垂直" }))
map("n", "<Leader>SR", "<C-w>t<C-w>K<Esc>", vim.tbl_extend("force", opts, { desc = "垂直转水平" }))

-- 调整窗口大小
map("n", "<Leader>S<up>", ":resize +4<CR>", vim.tbl_extend("force", opts, { desc = "增加高度" }))
map("n", "<Leader>S<down>", ":resize -4<CR>", vim.tbl_extend("force", opts, { desc = "减少高度" }))
map("n", "<Leader>S<left>", ":vertical resize -4<CR>", vim.tbl_extend("force", opts, { desc = "减少宽度" }))
map("n", "<Leader>S<right>", ":vertical resize +4<CR>", vim.tbl_extend("force", opts, { desc = "增加宽度" }))

-- 标签页操作（<leader>T 分组）
map("n", "<Leader>TE", ":tabedit<CR>", vim.tbl_extend("force", opts, { desc = "新建标签页" }))
map("n", "<Leader>TH", ":tabprevious<CR>", vim.tbl_extend("force", opts, { desc = "上一个标签页" }))
map("n", "<Leader>TL", ":tabnext<CR>", vim.tbl_extend("force", opts, { desc = "下一个标签页" }))

-- 切换内联提示（<leader>u 分组）
vim.keymap.set("n", "<leader>ui", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local enabled = false
	if vim.lsp.inlay_hint then
		if vim.lsp.inlay_hint.is_enabled then
			-- 尝试两种 is_enabled 签名
			local ok, val = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
			if not ok then
				ok, val = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
			end
			if ok then
				enabled = val
			end
		end
		if enabled then
			-- 尝试新API: enable(bufnr, false); 回退到旧API: enable(false, {bufnr=})
			local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, false)
			if not ok then
				pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
			end
		else
			local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, true)
			if not ok then
				pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
			end
		end
	end
end, vim.tbl_extend("force", opts, { desc = "切换内联提示" }))

-- === CocList 系列功能替代 (使用 fzf-lua) ===
-- <space> 前缀系列 - 替代 Coc.nvim 的 CocList 功能

-- 诊断列表 (替代 <space>d)
map("n", "<space>d", function()
	require("fzf-lua").lsp_diagnostics()
end, vim.tbl_extend("force", opts, { desc = "诊断列表" }))

-- 文档大纲 (替代 <space>o) - 注意与 aerial.nvim 冲突，优先使用 fzf-lua
map("n", "<space>o", function()
	require("fzf-lua").lsp_document_symbols()
end, vim.tbl_extend("force", opts, { desc = "文档大纲" }))

-- 工作区符号 (替代 <space>s)
map("n", "<space>s", function()
	require("fzf-lua").lsp_workspace_symbols()
end, vim.tbl_extend("force", opts, { desc = "工作区符号" }))

-- 命令面板 (替代 <space>c)
map("n", "<space>c", function()
	require("fzf-lua").commands()
end, vim.tbl_extend("force", opts, { desc = "命令面板" }))

-- 搜索单词 (替代 <space>q)
map("n", "<space>q", function()
	require("fzf-lua").quickfix()
end, vim.tbl_extend("force", opts, { desc = "快速修复列表" }))

-- 扩展管理 (替代 <space>e)
map("n", "<space>e", function()
	require("fzf-lua").lsp_finder()
end, vim.tbl_extend("force", opts, { desc = "LSP 查找器" }))

-- CodeLens 动作 (标准布局)
map("n", "<leader>rl", function()
	-- 尝试执行 codelens 动作
	local codelens_actions = vim.lsp.codelens.get_actions()
	if #codelens_actions > 0 then
		vim.lsp.codelens.run()
	else
		vim.notify("当前行没有可用的 CodeLens 动作", vim.log.levels.WARN)
	end
end, vim.tbl_extend("force", opts, { desc = "CodeLens 动作" }))

-- 终端导航：使用 Esc 退出终端模式
vim.cmd([[
  " 使用 Esc 退出终端模式（类似 Vim）
  tnoremap <Esc> <C-\><C-N>
]])
