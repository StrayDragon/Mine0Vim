return {
	"nanozuki/tabby.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- for file icons
	},
	config = function()
		-- 使用自定义配置，过滤特殊窗口
		local theme = {
			fill = "TabLineFill",
			head = "TabLine",
			current_tab = "TabLineSel",
			tab = "TabLine",
			win = "TabLine",
			tail = "TabLine",
		}

		require("tabby").setup({
			line = function(line)
				return {
					{
						{ "  ", hl = theme.head },
						line.sep("", theme.head, theme.fill),
					},
					line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
						-- 过滤掉特殊窗口类型（NvimTree、Outline 等）
						local buf = win.buf()
						local buf_name = vim.api.nvim_buf_get_name(buf.id)
						local buftype = vim.api.nvim_buf_get_option(buf.id, "buftype")
						local filetype = vim.api.nvim_buf_get_option(buf.id, "filetype")

						-- 只显示普通文件窗口，过滤掉 NvimTree、终端、快速修复等
						if buftype == "" and filetype ~= "NvimTree" and filetype ~= "aerial" and not buf_name:match("NvimTree") then
							-- 根据是否为当前窗口和是否修改来决定高亮
							local win_hl
							local icon
							if win.is_current() then
								win_hl = theme.current_tab  -- 使用当前标签页的高亮
								icon = ""
							else
								win_hl = theme.win
								icon = ""
							end

							-- 如果文件有修改，添加特殊标记
							local modified = ""
							if vim.api.nvim_buf_get_option(buf.id, "modified") then
								modified = " ●"
								-- 修改过的文件使用不同的高亮
								if win.is_current() then
									win_hl = theme.current_tab
								else
									win_hl = "TabLineModified"  -- 自定义修改文件的高亮
								end
							end

							return {
								line.sep("", win_hl, theme.fill),
								icon,
								win.file_icon() and " " or "",
								win.file_icon(),
								" ",
								win.buf_name(),
								modified,
								line.sep("", win_hl, theme.fill),
								hl = win_hl,
								margin = " ",
							}
						end
						return ""
					end),
					{
						line.sep("", theme.tail, theme.fill),
						{ "  ", hl = theme.tail },
					},
					line.spacer(),
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						return {
							line.sep("", hl, theme.fill),
							tab.is_current() and "" or "󰆣",
							tab.number(),
							tab.close_btn(""),
							line.sep("", hl, theme.fill),
							hl = hl,
							margin = " ",
						}
					end),
					hl = theme.fill,
				}
			end,
			option = {
				tab_name = {
					name_fallback = function(tabid)
						-- 获取当前标签页的第一个非特殊窗口
						local wins = vim.api.nvim_tabpage_list_wins(tabid)
						for _, win_id in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win_id)
							local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
							local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
							local name = vim.api.nvim_buf_get_name(buf)

							-- 过滤掉 NvimTree、终端等特殊窗口
							if buftype == "" and filetype ~= "NvimTree" and filetype ~= "aerial" and name ~= "" then
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

		-- 定义自定义高亮组用于修改过的文件
		vim.api.nvim_set_hl(0, "TabLineModified", {
			fg = "#e5c07b",  -- 黄色
			bg = "#3b4252",
			bold = true,
		})

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