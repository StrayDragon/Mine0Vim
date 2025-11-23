-- Workspace Manager Plugin Configuration
-- 标准的 lazy.nvim 插件规格，深度集成现有体系

return {
	"workspace-manager.nvim",
	dev = true,
	dependencies = {
		"ibhagwan/fzf-lua", -- 依赖 fzf-lua 进行模糊搜索
	},
	opts = {
		-- 可配置选项
		auto_save = true,
		session_restore = true,
		show_in_statusline = true,
	},
	keys = {
		-- 工作区切换
		{
			"<leader>wj",
			function()
				local workspace_manager = require("workspace-manager")
				local choices = workspace_manager.list_workspaces()
				require("fzf-lua").fzf_exec(choices, {
					prompt = "Workspace Switch> ",
					actions = {
						["default"] = function(selected)
							if #selected > 0 then
								local name = string.match(selected[1], "^(.-)%s*[●]?")
								-- 通过名称查找工作区
								for id, ws in pairs(workspace_manager.get_all_workspaces()) do
									if ws.name == name then
										workspace_manager.switch_workspace(id)
										break
									end
								end
							end
						end,
					},
				})
			end,
			desc = "Switch workspace",
		},
		-- 新建工作区
		{
			"<leader>wn",
			function()
				local workspace_manager = require("workspace-manager")
				vim.ui.input({ prompt = "Workspace name: " }, function(name)
					if name and name ~= "" then
						local path = vim.fn.input("Workspace path: ", vim.fn.getcwd())
						if path and path ~= "" then
							local workspace = workspace_manager.create_workspace(name, path)
							workspace_manager.switch_workspace(workspace.id)
							workspace_manager.save_workspaces()
						end
					end
				end)
			end,
			desc = "New workspace",
		},
		-- 从当前目录创建工作区
		{
			"<leader>ww",
			function()
				local workspace_manager = require("workspace-manager")
				local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				local workspace = workspace_manager.create_workspace(name, vim.fn.getcwd())
				workspace_manager.switch_workspace(workspace.id)
				workspace_manager.save_workspaces()
				vim.notify("Created workspace: " .. name, vim.log.levels.INFO)
			end,
			desc = "Workspace from current dir",
		},
		-- 删除工作区
		{
			"<leader>wd",
			function()
				local workspace_manager = require("workspace-manager")
				local choices = workspace_manager.list_workspaces()
				require("fzf-lua").fzf_exec(choices, {
					prompt = "Delete Workspace> ",
					actions = {
						["default"] = function(selected)
							if #selected > 0 then
								local name = string.match(selected[1], "^(.-)%s*[●]?")
								-- 通过名称查找并删除工作区
								for id, ws in pairs(workspace_manager.get_all_workspaces()) do
									if ws.name == name then
										workspace_manager.delete_workspace(id)
										break
									end
								end
							end
						end,
					},
				})
			end,
			desc = "Delete workspace",
		},
	},
	enabled = true,
	event = "VeryLazy", -- 延迟加载以确保依赖已加载
}