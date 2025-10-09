-- 智能键位冲突解决机制
-- 处理键位冲突并提供智能解决方案

local M = {}

-- 冲突检测器
local conflict_detector = {
  -- 检查键位是否已存在
  key_exists = function(key_sequence, mode)
    local mappings = vim.api.nvim_get_keymap(mode)
    for _, mapping in ipairs(mappings) do
      if mapping.lhs == key_sequence then
        return true, mapping
      end
    end
    return false, nil
  end,

  -- 检查缓冲区本地键位
  buffer_key_exists = function(key_sequence, mode, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local mappings = vim.api.nvim_buf_get_keymap(bufnr, mode)
    for _, mapping in ipairs(mappings) do
      if mapping.lhs == key_sequence then
        return true, mapping
      end
    end
    return false, nil
  end,

  -- 检查 Which-Key 组冲突
  which_key_group_exists = function(key_sequence)
    if pcall(require, 'which-key') then
      local wk = require('which-key')
      -- 这里可以添加更复杂的 Which-Key 冲突检测逻辑
      return false
    end
    return false
  end,
}

-- 冲突解决策略
local resolution_strategies = {
  -- 智能替换：优先级更高的处理器替换现有映射
  smart_replace = function(key_sequence, mode, new_handler, existing_handler)
    if new_handler.priority > (existing_handler.priority or 50) then
      -- 新处理器优先级更高，允许替换
      return true, "智能替换：更高优先级的处理器"
    else
      -- 新处理器优先级较低，拒绝替换
      return false, "优先级冲突：新处理器优先级较低"
    end
  end,

  -- 条件替换：根据上下文条件决定是否替换
  conditional_replace = function(key_sequence, mode, new_handler, existing_handler, context)
    -- 检查现有映射是否为通用映射，新映射是否为特定语言映射
    if existing_handler and existing_handler.generic and new_handler.language_specific then
      return true, "条件替换：语言特定映射替换通用映射"
    end

    -- 检查文件类型匹配
    if new_handler.filetype and context.filetype == new_handler.filetype then
      return true, "条件替换：文件类型匹配"
    end

    return false, "条件不满足：保留现有映射"
  end,

  -- 多模式共存：在不同模式下使用不同的处理器
  multi_mode_coexist = function(key_sequence, new_handler, existing_handler)
    -- 检查模式是否冲突
    local new_modes = new_handler.modes or { 'n' }
    local existing_modes = existing_handler.modes or { 'n' }

    -- 如果模式不完全重叠，可以共存
    for _, mode in ipairs(new_modes) do
      if not vim.tbl_contains(existing_modes, mode) then
        return true, "多模式共存：模式不冲突"
      end
    end

    return false, "模式冲突：无法共存"
  end,

  -- 上下文感知：基于上下文动态选择处理器
  context_aware = function(key_sequence, mode, new_handler, existing_handler, context)
    -- 创建动态选择函数
    local dynamic_handler = function()
      local current_context = require('config.smart-keys').get_current_context()

      -- 根据上下文选择处理器
      if new_handler.match_conditions(current_context) then
        new_handler.execute()
      elseif existing_handler and existing_handler.execute then
        existing_handler.execute()
      else
        require('config.smart-keys-notify').notify("没有找到适合的处理器: " .. key_sequence, vim.log.levels.WARN)
      end
    end

    -- 注册动态处理器
    vim.keymap.set(mode, key_sequence, dynamic_handler, {
      desc = "动态处理器: " .. (new_handler.description or ""),
      noremap = true,
      silent = true,
    })

    return true, "上下文感知：动态选择处理器"
  end,
}

-- 冲突分析器
local function analyze_conflict(key_sequence, mode, new_handler, context)
  local conflicts = {}

  -- 检查全局映射冲突
  local global_exists, global_mapping = conflict_detector.key_exists(key_sequence, mode)
  if global_exists then
    table.insert(conflicts, {
      type = 'global',
      mapping = global_mapping,
      severity = 'high',
    })
  end

  -- 检查缓冲区映射冲突
  local buffer_exists, buffer_mapping = conflict_detector.buffer_key_exists(key_sequence, mode)
  if buffer_exists then
    table.insert(conflicts, {
      type = 'buffer',
      mapping = buffer_mapping,
      severity = 'medium',
    })
  end

  -- 检查 Which-Key 组冲突
  local which_key_conflict = conflict_detector.which_key_group_exists(key_sequence)
  if which_key_conflict then
    table.insert(conflicts, {
      type = 'which_key',
      severity = 'low',
    })
  end

  return conflicts
end

-- 智能冲突解决器
function M.resolve_conflict(key_sequence, mode, new_handler, strategy)
  strategy = strategy or 'smart_replace'
  local context = require('config.smart-keys').get_current_context()

  -- 分析冲突
  local conflicts = analyze_conflict(key_sequence, mode, new_handler, context)

  if #conflicts == 0 then
    -- 没有冲突，直接注册
    return true, "无冲突"
  end

  -- 获取最严重的冲突
  local main_conflict = conflicts[1]
  local existing_handler = main_conflict.mapping

  -- 应用解决策略
  local resolver = resolution_strategies[strategy]
  if resolver then
    local success, message = resolver(key_sequence, mode, new_handler, existing_handler, context)
    return success, message
  end

  return false, "未找到解决策略"
end

-- 批量冲突解决
function M.batch_resolve_conflicts(handlers, strategy)
  local results = {
    resolved = 0,
    conflicts = 0,
    errors = 0,
  }

  for _, handler in ipairs(handlers) do
    local modes = handler.modes or { 'n' }
    for _, mode in ipairs(modes) do
      -- 这里需要从 handler 中提取键序列
      -- 由于设计问题，这里需要调整
      results.errors = results.errors + 1
    end
  end

  return results
end

-- 冲突预防系统
local conflict_prevention = {
  -- 建议安全的键位映射
  suggest_safe_key = function(base_key, suggestions)
    suggestions = suggestions or {}

    -- 生成建议的变体
    local variants = {
      base_key,
      base_key .. '<leader>',
      '<leader>' .. base_key,
      '<leader>' .. base_key:sub(1, 1),
      '<leader>' .. base_key:sub(1, 2),
      base_key:upper(),
      base_key:lower(),
    }

    -- 检查每个变体的安全性
    for _, variant in ipairs(variants) do
      local is_safe = true
      for mode, mode_mappings in pairs(conflict_prevention.get_all_mappings()) do
        if mode_mappings[variant] then
          is_safe = false
          break
        end
      end

      if is_safe then
        table.insert(suggestions, variant)
      end
    end

    return suggestions
  end,

  -- 获取所有现有映射
  get_all_mappings = function()
    local all_mappings = {}
    local modes = { 'n', 'v', 'x', 's', 'o', 'i', 'c', 't' }

    for _, mode in ipairs(modes) do
      all_mappings[mode] = {}
      local mappings = vim.api.nvim_get_keymap(mode)
      for _, mapping in ipairs(mappings) do
        all_mappings[mode][mapping.lhs] = mapping
      end
    end

    return all_mappings
  end,
}

-- 冲突报告生成器
function M.generate_conflict_report()
  local all_mappings = conflict_prevention.get_all_mappings()
  local key_usage = {}

  -- 统计键位使用情况
  for mode, mappings in pairs(all_mappings) do
    for key_sequence, mapping in pairs(mappings) do
      if not key_usage[key_sequence] then
        key_usage[key_sequence] = {}
      end
      table.insert(key_usage[key_sequence], {
        mode = mode,
        desc = mapping.desc or '无描述',
        rhs = mapping.rhs or '无映射',
      })
    end
  end

  -- 查找冲突
  local conflicts = {}
  for key_sequence, usages in pairs(key_usage) do
    if #usages > 1 then
      table.insert(conflicts, {
        key = key_sequence,
        usages = usages,
        severity = #usages > 2 and 'high' or 'medium',
      })
    end
  end

  return {
    key_usage = key_usage,
    conflicts = conflicts,
    total_mappings = vim.tbl_count(key_usage),
    total_conflicts = #conflicts,
  }
end

-- 显示冲突报告
function M.show_conflict_report()
  local report = M.generate_conflict_report()
  local lines = {
    '=== 键位冲突报告 ===',
    '',
    string.format('总映射数: %d', report.total_mappings),
    string.format('冲突数: %d', report.total_conflicts),
    '',
  }

  if #report.conflicts > 0 then
    table.insert(lines, '冲突详情:')
    table.insert(lines, '')

    for _, conflict in ipairs(report.conflicts) do
      table.insert(lines, string.format('键位: %s (严重程度: %s)', conflict.key, conflict.severity))
      for _, usage in ipairs(conflict.usages) do
        table.insert(lines, string.format('  [%s] %s -> %s', usage.mode, usage.desc, usage.rhs))
      end
      table.insert(lines, '')
    end
  else
    table.insert(lines, '✓ 未发现键位冲突')
  end

  -- 显示在浮动窗口
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.min(80, vim.o.columns - 4),
    height = math.min(20, #lines + 2),
    col = math.floor((vim.o.columns - math.min(80, vim.o.columns - 4)) / 2),
    row = math.floor((vim.o.lines - math.min(20, #lines + 2)) / 2),
    style = 'minimal',
    border = 'rounded',
    title = '键位冲突报告',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {})
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {})
end

-- 安全键位映射器
function M.safe_keymap_set(mode, key_sequence, handler, opts)
  opts = opts or {}
  local strategy = opts.strategy or 'smart_replace'

  -- 尝试解决冲突
  local success, message = M.resolve_conflict(key_sequence, mode, handler, strategy)

  if success then
    -- 注册键位映射
    vim.keymap.set(mode, key_sequence, handler.execute, {
      desc = handler.description,
      noremap = true,
      silent = true,
    })

    if opts.verbose ~= false then
      require('config.smart-keys-notify').notify(string.format("✓ 键位映射已注册: %s (%s)", key_sequence, message), vim.log.levels.INFO)
    end
  else
    -- 冲突未解决
    if opts.fallback then
      opts.fallback(key_sequence, mode, handler)
    else
      require('config.smart-keys-notify').notify(string.format("✗ 键位映射冲突: %s (%s)", key_sequence, message), vim.log.levels.WARN)
    end
  end

  return success, message
end

-- 获取安全的键位建议
function M.get_safe_key_suggestions(base_key)
  return conflict_prevention.suggest_safe_key(base_key)
end

-- 初始化冲突解决系统
function M.initialize()
  -- 创建用户命令
  vim.api.nvim_create_user_command('SmartKeyConflictReport', function()
    M.show_conflict_report()
  end, { desc = '显示键位冲突报告' })

  vim.api.nvim_create_user_command('SmartKeySafeSuggest', function(opts)
    local base_key = opts.args or ''
    if base_key == '' then
      require('config.smart-keys-notify').notify('请提供基础键位', vim.log.levels.ERROR)
      return
    end

    local suggestions = M.get_safe_key_suggestions(base_key)
    if #suggestions > 0 then
      require('config.smart-keys-notify').notify('安全键位建议: ' .. table.concat(suggestions, ', '), vim.log.levels.INFO)
    else
      require('config.smart-keys-notify').notify('未找到安全键位建议', vim.log.levels.WARN)
    end
  end, { nargs = 1, desc = '获取安全键位建议' })

  require('config.smart-keys-notify').notify('智能键位冲突解决系统已启动', vim.log.levels.INFO)
end

return M