-- 智能键位通知系统 - 使用 nvim-notify
-- 为智能键位系统提供通知功能

local M = {}

-- 配置选项
M.config = {
  -- 是否启用
  enabled = true,
  -- 日志级别
  log_level = vim.log.levels.INFO,
}

-- 显示通知
function M.notify(message, level, title)
  if not M.config.enabled then
    -- 如果禁用，使用标准 vim.notify
    vim.notify(message, level, { title = title })
    return
  end

  -- 检查日志级别
  if level and level < M.config.log_level then
    return
  end

  -- 使用 nvim-notify 显示通知
  local notify_level = "info"
  if level == vim.log.levels.ERROR then
    notify_level = "error"
  elseif level == vim.log.levels.WARN then
    notify_level = "warn"
  elseif level == vim.log.levels.DEBUG then
    notify_level = "debug"
  elseif level == vim.log.levels.TRACE then
    notify_level = "trace"
  end

  vim.notify(message, notify_level, { title = title })
end

-- 便捷方法
function M.info(message, title)
  return M.notify(message, vim.log.levels.INFO, title)
end

function M.success(message, title)
  return M.notify(message, vim.log.levels.INFO, title)
end

function M.warning(message, title)
  return M.notify(message, vim.log.levels.WARN, title)
end

function M.error(message, title)
  return M.notify(message, vim.log.levels.ERROR, title)
end

function M.debug(message, title)
  return M.notify(message, vim.log.levels.DEBUG, title)
end

-- 显示智能键位特定通知
function M.smart_key_notification(message, context)
  local title = "智能键位"
  local level = vim.log.levels.INFO

  if context and context.filetype then
    title = string.format("智能键位 (%s)", context.filetype)
  end

  return M.notify(message, level, title)
end

-- 显示处理器选择通知
function M.handler_notification(handler_name, context)
  local message = string.format("使用处理器: %s", handler_name)
  local title = "智能路由"

  if context and context.filetype then
    title = string.format("智能路由 (%s)", context.filetype)
  end

  return M.notify(message, vim.log.levels.DEBUG, title)
end

-- 清理所有通知 (nvim-notify 内置了历史管理)
function M.clear_all()
  -- nvim-notify 有自己的历史管理，这里调用其清除函数
  if package.loaded["notify"] then
    require("notify").clear_history()
  end
end

-- 更新配置
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- 初始化
function M.initialize()
  -- 创建用户命令
  vim.api.nvim_create_user_command("SmartKeysNotifyToggle", function()
    M.config.enabled = not M.config.enabled
    M.notify(
      string.format("智能键位通知已%s", M.config.enabled and "启用" or "禁用"),
      vim.log.levels.INFO,
      "通知系统"
    )
  end, { desc = "切换智能键位通知显示" })

  vim.api.nvim_create_user_command("SmartKeysNotifyClear", function()
    M.clear_all()
    M.notify("已清除所有通知", vim.log.levels.INFO, "通知系统")
  end, { desc = "清除所有智能键位通知" })

  vim.api.nvim_create_user_command("SmartKeysNotifyTest", function()
    M.info("这是一条信息通知", "测试")
    M.success("这是一条成功通知", "测试")
    M.warning("这是一条警告通知", "测试")
    M.error("这是一条错误通知", "测试")
    M.debug("这是一条调试通知", "测试")
  end, { desc = "测试智能键位通知" })

  -- 创建通知历史查看命令
  vim.api.nvim_create_user_command("SmartKeysNotifyHistory", function()
    if package.loaded["notify"] then
      vim.cmd("Notifications")
    else
      vim.notify("nvim-notify 未加载", vim.log.levels.ERROR)
    end
  end, { desc = "查看智能键位通知历史" })

  M.notify("智能键位通知系统已启动 (nvim-notify)", vim.log.levels.INFO, "系统通知")
end

return M