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
					-- 显示所有选项卡（编号+名称）
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						local tab_name = tab.name()
						if tab_name == "" then
							tab_name = "Tab " .. tab.number()
						end

						return {
							line.sep("", hl, theme.fill),
							tab.is_current() and "" or "󰆣",
							" " .. tab.number() .. ": " .. tab_name .. " ",
							tab.close_btn(" "),
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

		-- 工作区导航（兼容 barbar 的按键习惯）
		vim.keymap.set("n", "<Leader>1", "1gt", { silent = true, desc = "跳转到工作区 1" })
		vim.keymap.set("n", "<Leader>2", "2gt", { silent = true, desc = "跳转到工作区 2" })
		vim.keymap.set("n", "<Leader>3", "3gt", { silent = true, desc = "跳转到工作区 3" })
		vim.keymap.set("n", "<Leader>4", "4gt", { silent = true, desc = "跳转到工作区 4" })
		vim.keymap.set("n", "<Leader>5", "5gt", { silent = true, desc = "跳转到工作区 5" })
		vim.keymap.set("n", "<Leader>6", "6gt", { silent = true, desc = "跳转到工作区 6" })
		vim.keymap.set("n", "<Leader>7", "7gt", { silent = true, desc = "跳转到工作区 7" })
		vim.keymap.set("n", "<Leader>8", "8gt", { silent = true, desc = "跳转到工作区 8" })
		vim.keymap.set("n", "<Leader>9", "9gt", { silent = true, desc = "跳转到工作区 9" })
		vim.keymap.set("n", "<Leader>0", ":tablast<CR>", { silent = true, desc = "跳转到最后工作区" })

		-- 工作区管理
		vim.keymap.set("n", "<Leader>tw", function()
			-- 新建工作区时自动打开文件树
			vim.cmd("$tabnew")
			require("nvim-tree.api").tree.open()
		end, { silent = true, desc = "新建工作区（带文件树）" })

		vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>", { silent = true, desc = "关闭当前工作区" })
		vim.keymap.set("n", "<Leader>to", ":tabonly<CR>", { silent = true, desc = "关闭其他工作区" })
		vim.keymap.set("n", "<Leader>tn", ":tabnext<CR>", { silent = true, desc = "下一个工作区" })
		vim.keymap.set("n", "<Leader>tp", ":tabprevious<CR>", { silent = true, desc = "上一个工作区" })

		-- 移动工作区位置
		vim.keymap.set("n", "<Leader>tmp", ":-tabmove<CR>", { silent = true, desc = "工作区左移" })
		vim.keymap.set("n", "<Leader>tmn", ":+tabmove<CR>", { silent = true, desc = "工作区右移" })

		-- 文件操作增强（与文件树配合）
		vim.keymap.set("n", "<Leader>tf", function()
			-- 在当前工作区打开文件树
			require("nvim-tree.api").tree.toggle()
		end, { silent = true, desc = "切换当前工作区文件树" })

		vim.keymap.set("n", "<Leader>tnf", function()
			-- 在新工作区打开文件树
			vim.cmd("$tabnew")
			require("nvim-tree.api").tree.open()
		end, { silent = true, desc = "新工作区打开文件树" })

		-- 文件到工作区操作
		vim.keymap.set("n", "<Leader>tmf", function()
			-- 将当前文件移动到新工作区
			local current_file = vim.api.nvim_buf_get_name(0)
			vim.cmd("$tabnew")
			vim.cmd("edit " .. current_file)
		end, { silent = true, desc = "当前文件移动到新工作区" })

		-- 增强的窗口选择器（使用 fzf）
		vim.keymap.set("n", "<Leader>p", function()
			-- 获取所有标签页和工作区信息
			local tabs = vim.api.nvim_list_tabpages()
			local current_tab = vim.api.nvim_get_current_tabpage()

			local choices = {}
			for i, tab in ipairs(tabs) do
				local tab_number = vim.api.nvim_tabpage_get_number(tab)
				local tab_name = "Tab " .. tab_number .. ": [No Name]"

				-- 获取标签页中的窗口
				local wins = vim.api.nvim_tabpage_list_wins(tab)
				for _, win in ipairs(wins) do
					local buf = vim.api.nvim_win_get_buf(win)
					local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
					local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
					local buf_name = vim.api.nvim_buf_get_name(buf)

					-- 只显示普通文件窗口，过滤特殊窗口
					if buftype == "" and filetype ~= "NvimTree" and filetype ~= "aerial" and buf_name ~= "" then
						local filename = vim.fn.fnamemodify(buf_name, ":t")
						local modified = vim.api.nvim_buf_get_option(buf, "modified") and " ●" or ""
						tab_name = "Tab " .. tab_number .. ": " .. filename .. modified
						break
					end
				end

				local is_current = (tab == current_tab) and " [CURRENT]" or ""
				table.insert(choices, tab_number .. ": " .. tab_name .. is_current)
			end

			require("fzf-lua").fzf_exec(choices, {
				prompt = "Workspace Jump> ",
				actions = {
					["default"] = function(selected)
						if #selected > 0 then
							local tab_num = tonumber(string.match(selected[1], "^(%d+)"))
							if tab_num then
								vim.cmd(tostring(tab_num) .. "gt")
							end
						end
					end,
				},
			})
		end, { silent = true, desc = "FZF 工作区选择器" })

		-- 工作区跳转模式（保留原功能）
		vim.keymap.set("n", "<Leader>j", ":Tabby jump_to_tab<CR>", { silent = true, desc = "工作区跳转模式" })
		vim.keymap.set("n", "<Leader>wt", ":Tabby rename_tab ", { silent = false, desc = "重命名工作区标签" })

		-- 窗口选择器（基于 fzf）
		vim.keymap.set("n", "<Leader>pw", function()
			local all_wins = {}
			local current_win = vim.api.nvim_get_current_win()
			local current_tab = vim.api.nvim_get_current_tabpage()

			-- 获取所有窗口
			for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
				local wins = vim.api.nvim_tabpage_list_wins(tab)
				for _, win in ipairs(wins) do
					local buf = vim.api.nvim_win_get_buf(win)
					local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
					local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
					local buf_name = vim.api.nvim_buf_get_name(buf)

					-- 只显示普通文件窗口
					if buftype == "" and filetype ~= "NvimTree" and filetype ~= "aerial" and buf_name ~= "" then
						local filename = vim.fn.fnamemodify(buf_name, ":t")
						local modified = vim.api.nvim_buf_get_option(buf, "modified") and " ●" or ""
						local tab_num = vim.api.nvim_tabpage_get_number(tab)
						local is_current = (win == current_win and tab == current_tab) and " [CURRENT]" or ""

						table.insert(all_wins, {
							win = win,
							tab = tab,
							text = string.format("Tab %d: %s%s", tab_num, filename, modified .. is_current)
						})
					end
				end
			end

			local choices = vim.tbl_map(function(item) return item.text end, all_wins)

			require("fzf-lua").fzf_exec(choices, {
				prompt = "Window Jump> ",
				actions = {
					["default"] = function(selected)
						if #selected > 0 then
							-- 找到对应的窗口
							for _, item in ipairs(all_wins) do
								if item.text == selected[1] then
									-- 切换到对应的工作区
									vim.api.nvim_set_current_tabpage(item.tab)
									-- 切换到对应窗口
									vim.api.nvim_set_current_win(item.win)
									break
								end
							end
						end
					end,
				},
			})
		end, { silent = true, desc = "FZF 窗口选择器" })

		-- 兼容习惯
		vim.keymap.set("n", "<Leader>ta", "<Leader>tw", { silent = true, desc = "新建工作区（别名）" })
		vim.keymap.set("n", "<Leader>q", ":tabclose<CR>", { silent = true, desc = "关闭当前工作区" })

		-- 窗口操作
		vim.keymap.set("n", "<Leader>w", "<C-w>w", { silent = true, desc = "切换窗口" })

		-- 在工作区标题中显示当前工作区名称
		local function get_workspace_name()
			if _G.WorkspaceManager then
				local workspace = _G.WorkspaceManager.get_current_workspace()
				return workspace and ("[" .. workspace.name .. "]") or ""
			end
			return ""
		end

		-- 动态更新 tabline 以反映工作区状态
		vim.api.nvim_create_autocmd({"TabEnter", "TabLeave", "BufWritePost"}, {
			callback = function()
				-- 触发 tabline 重新渲染
				vim.cmd("redrawtabline")
			end,
		})
	end,
}