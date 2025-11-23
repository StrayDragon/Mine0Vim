return {
	"nanozuki/tabby.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- for file icons
	},
	config = function()
		-- 使用预设配置，简单且稳定
		require("tabby").setup({
			preset = "tab_with_top_win",
			option = {
				theme = {
					fill = "TabLineFill",       -- tabline background
					head = "TabLine",           -- head element highlight
					current_tab = "TabLineSel", -- current tab label highlight
					tab = "TabLine",            -- other tab label highlight
					win = "TabLine",            -- window highlight
					tail = "TabLine",           -- tail element highlight
				},
				nerdfont = true,              -- 使用 nerdfont
				lualine_theme = nil,          -- 不使用 lualine 主题
				tab_name = {
					name_fallback = function(tabid)
						-- 获取标签页中的第一个窗口的缓冲区名称
						local wins = vim.api.nvim_tabpage_list_wins(tabid)
						if #wins > 0 then
							local buf = vim.api.nvim_win_get_buf(wins[1])
							local name = vim.api.nvim_buf_get_name(buf)
							if name and name ~= "" then
								return vim.fn.fnamemodify(name, ":t")
							end
						end
						return "Tab " .. tostring(vim.api.nvim_tabpage_get_number(tabid))
					end,
				},
				buf_name = {
					mode = "tail", -- 只显示文件名
					name_fallback = function(bufid)
						return "[No Name]"
					end,
				},
			},
		})

		-- 始终显示 tabline
		vim.o.showtabline = 2

		-- 标签页导航（兼容 barbar 的按键习惯）
		vim.keymap.set("n", "<Leader>1", "1gt", { silent = true, desc = "跳转到标签页 1" })
		vim.keymap.set("n", "<Leader>2", "2gt", { silent = true, desc = "跳转到标签页 2" })
		vim.keymap.set("n", "<Leader>3", "3gt", { silent = true, desc = "跳转到标签页 3" })
		vim.keymap.set("n", "<Leader>4", "4gt", { silent = true, desc = "跳转到标签页 4" })
		vim.keymap.set("n", "<Leader>5", "5gt", { silent = true, desc = "跳转到标签页 5" })
		vim.keymap.set("n", "<Leader>6", "6gt", { silent = true, desc = "跳转到标签页 6" })
		vim.keymap.set("n", "<Leader>7", "7gt", { silent = true, desc = "跳转到标签页 7" })
		vim.keymap.set("n", "<Leader>8", "8gt", { silent = true, desc = "跳转到标签页 8" })
		vim.keymap.set("n", "<Leader>9", "9gt", { silent = true, desc = "跳转到标签页 9" })
		vim.keymap.set("n", "<Leader>0", ":tablast<CR>", { silent = true, desc = "跳转到最后一个标签页" })

		-- 标签页操作
		vim.keymap.set("n", "<Leader>ta", ":$tabnew<CR>", { silent = true, desc = "新建标签页" })
		vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>", { silent = true, desc = "关闭标签页" })
		vim.keymap.set("n", "<Leader>to", ":tabonly<CR>", { silent = true, desc = "关闭其他标签页" })
		vim.keymap.set("n", "<Leader>tn", ":tabnext<CR>", { silent = true, desc = "下一个标签页" })
		vim.keymap.set("n", "<Leader>tp", ":tabprevious<CR>", { silent = true, desc = "上一个标签页" })

		-- 移动标签页位置
		vim.keymap.set("n", "<Leader>tmp", ":-tabmove<CR>", { silent = true, desc = "标签页左移" })
		vim.keymap.set("n", "<Leader>tmn", ":+tabmove<CR>", { silent = true, desc = "标签页右移" })

		-- Tabby 特殊功能
		vim.keymap.set("n", "<Leader>p", ":Tabby pick_window<CR>", { silent = true, desc = "窗口选择器" })
		vim.keymap.set("n", "<Leader>j", ":Tabby jump_to_tab<CR>", { silent = true, desc = "标签页跳转模式" })
		vim.keymap.set("n", "<Leader>rn", ":Tabby rename_tab ", { silent = false, desc = "重命名标签页" })

		-- 兼容 barbar 的 <Leader>q 关闭功能，但针对标签页
		vim.keymap.set("n", "<Leader>q", ":tabclose<CR>", { silent = true, desc = "关闭当前标签页" })

		-- 窗口操作（原来 buffer 概念现在用窗口代替）
		vim.keymap.set("n", "<Leader>w", "<C-w>w", { silent = true, desc = "切换窗口" })
	end,
}