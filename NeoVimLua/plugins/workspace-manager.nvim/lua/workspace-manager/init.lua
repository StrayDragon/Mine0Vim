-- Workspace Manager Plugin
-- 深度集成 lualine 和 which-key 的工作区管理方案

local M = {}

-- 默认配置
local default_config = {
	auto_save = true,
	session_restore = true,
	show_in_statusline = true,
	workspace_file = vim.fn.stdpath("data") .. "/workspaces.json",
}

-- 内部状态
local config = default_config
local workspaces = {}
local current_workspace = nil

-- 获取当前工作区信息
function M.get_current_workspace()
	return current_workspace
end

-- 获取工作区名称（用于状态栏显示）
function M.get_workspace_name()
	return current_workspace and current_workspace.name or "No Workspace"
end

-- 获取所有工作区数据（用于查找）
function M.get_all_workspaces()
	return workspaces
end

-- 获取工作区列表
function M.list_workspaces()
	local choices = {}
-- 按最后访问时间排序
	local sorted_workspaces = {}
	for _, workspace in pairs(workspaces) do
		table.insert(sorted_workspaces, workspace)
	end
	table.sort(sorted_workspaces, function(a, b)
		return (a.last_visited or 0) > (b.last_visited or 0)
	end)

	for _, workspace in ipairs(sorted_workspaces) do
		local is_current = (current_workspace and current_workspace.id == workspace.id) and " ●" or ""
		local time_str = os.date("%m/%d %H:%M", workspace.last_visited)
		table.insert(choices, string.format("%s%s %s", workspace.name, is_current, time_str))
	end
	return choices
end

-- 初始化默认工作区
local function init_default_workspaces()
	if #workspaces == 0 then
		local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		M.create_workspace(cwd, vim.fn.getcwd())
	end
end

-- 创建新工作区
function M.create_workspace(name, path)
	local workspace_id = #workspaces + 1
	local workspace = {
		id = workspace_id,
		name = name,
		path = path,
		tabs = {},
		created_at = os.time(),
		last_visited = os.time()
	}
	workspaces[workspace_id] = workspace
	return workspace
end

-- 切换到指定工作区
function M.switch_workspace(workspace_id)
	local workspace = workspaces[workspace_id]
	if not workspace then
		vim.notify("工作区不存在", vim.log.levels.ERROR)
		return
	end

	-- 保存当前工作区的状态
	if current_workspace then
		M.save_workspace_state(current_workspace)
	end

	-- 切换到新工作区
	current_workspace = workspace
	workspace.last_visited = os.time()
	vim.fn.chdir(workspace.path)

	-- 触发状态栏更新
	vim.api.nvim_exec_autocmds("User", { pattern = "WorkspaceChanged" })
	vim.notify("切换到工作区: " .. workspace.name, vim.log.levels.INFO)

	-- 恢复工作区的 tab 状态
	if #workspace.tabs > 0 then
		M.restore_workspace_state(workspace)
	else
		-- 如果工作区没有保存的 tab，打开文件树
		if pcall(require, "nvim-tree.api") then
			require("nvim-tree.api").tree.open()
		end
	end

	vim.notify("切换到工作区: " .. workspace.name, vim.log.levels.INFO)
end

-- 保存工作区状态
function M.save_workspace_state(workspace)
	workspace.tabs = {}
	local current_tabs = vim.api.nvim_list_tabpages()

	for _, tab in ipairs(current_tabs) do
		local tab_info = {
			windows = {}
		}

		local wins = vim.api.nvim_tabpage_list_wins(tab)
		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name = vim.api.nvim_buf_get_name(buf)
			-- 只保存普通文件缓冲区
			if buf_name ~= "" and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
				table.insert(tab_info.windows, buf_name)
			end
		end

		if #tab_info.windows > 0 then
			table.insert(workspace.tabs, tab_info)
		end
	end
end

-- 恢复工作区状态
function M.restore_workspace_state(workspace)
	-- 关闭所有现有 tab，只保留第一个
	local current_tabs = vim.api.nvim_list_tabpages()
	while #current_tabs > 1 do
		vim.cmd("tabclose")
		current_tabs = vim.api.nvim_list_tabpages()
	end

	-- 关闭第一个 tab 中的所有窗口
	vim.cmd("only")

	-- 恢复工作区的 tab
	for _, tab_info in ipairs(workspace.tabs) do
		if #tab_info.windows > 0 then
			-- 新建 tab
			if tab_info == workspace.tabs[1] then
				-- 第一个 tab 直接在当前 tab 编辑
				vim.cmd("edit " .. tab_info.windows[1])
				for i = 2, #tab_info.windows do
					vim.cmd("split")
					vim.cmd("edit " .. tab_info.windows[i])
				end
			else
				-- 其他 tab 新建后编辑
				vim.cmd("tabnew")
				vim.cmd("edit " .. tab_info.windows[1])
				for i = 2, #tab_info.windows do
					vim.cmd("split")
					vim.cmd("edit " .. tab_info.windows[i])
				end
			end
		end
	end
end

-- 列出所有工作区
function M.list_workspaces()
	local choices = {}
-- 按最后访问时间排序
	local sorted_workspaces = {}
	for _, workspace in pairs(workspaces) do
		table.insert(sorted_workspaces, workspace)
	end
	table.sort(sorted_workspaces, function(a, b)
		return (a.last_visited or 0) > (b.last_visited or 0)
	end)

	for _, workspace in ipairs(sorted_workspaces) do
		local is_current = (current_workspace and current_workspace.id == workspace.id) and " [CURRENT]" or ""
		local time_str = os.date("%m/%d %H:%M", workspace.last_visited)
		table.insert(choices, string.format("%d: %s %s%s", workspace.id, workspace.name, time_str, is_current))
	end
	return choices
end

-- 删除工作区
function M.delete_workspace(workspace_id)
	if workspaces[workspace_id] then
		local name = workspaces[workspace_id].name
		workspaces[workspace_id] = nil
		M.save_workspaces()
		vim.notify("删除工作区: " .. name, vim.log.levels.INFO)
	end
end

-- 获取当前工作区
function M.get_current_workspace()
	return current_workspace
end

-- 保存工作区配置到文件
function M.save_workspaces()
	local config_data = {
		workspaces = workspaces,
		current_workspace = current_workspace and current_workspace.id or nil
	}
	local file = io.open(config.workspace_file, "w")
	if file then
		file:write(vim.json.encode(config_data))
		file:close()
	end
end

-- 从文件加载工作区配置
function M.load_workspaces()
	local file = io.open(config.workspace_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		local ok, config_data = pcall(vim.json.decode, content)
		if ok then
			workspaces = config_data.workspaces or {}
			if config_data.current_workspace and workspaces[config_data.current_workspace] then
				current_workspace = workspaces[config_data.current_workspace]
			end
		end
	end
	init_default_workspaces()
end

-- 插件主设置函数
function M.setup(opts)
	-- 合并用户选项
	config = vim.tbl_deep_extend("force", default_config, opts or {})

	-- 初始化插件
	M.load_workspaces()

	-- 自动保存
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			if current_workspace then
				M.save_workspace_state(current_workspace)
			end
			M.save_workspaces()
		end,
	})

	-- 定期自动保存
	vim.api.nvim_create_autocmd({"BufWritePost", "TabClosed", "TabNew"}, {
		callback = function()
			if current_workspace then
				M.save_workspace_state(current_workspace)
				M.save_workspaces()
			end
		end,
	})

	-- 设置工作区变更自动命令
	if config.show_in_statusline then
		vim.api.nvim_create_autocmd("User", {
			pattern = "WorkspaceChanged",
			callback = function()
				-- 触发状态栏刷新
				vim.cmd("redrawstatus")
			end,
		})
	end

	vim.notify("Workspace Manager loaded", vim.log.levels.INFO)
end

return M