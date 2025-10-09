-- 智能键位覆盖引擎
-- 实现上下文感知的键位路由系统，相同按键序列在不同场景下调用不同实现

local M = {}

-- 上下文检测器
local context_detectors = {
  -- 文件类型检测
  filetype = function()
    return vim.bo.filetype
  end,

  -- 项目类型检测
  project_type = function()
    local cwd = vim.fn.getcwd()

    -- Python项目
    if vim.fn.glob('*.py') ~= '' or vim.fn.glob('pyproject.toml') ~= '' or vim.fn.glob('requirements*.txt') ~= '' then
      return 'python'
    end

    -- Rust项目
    if vim.fn.glob('Cargo.toml') ~= '' then
      return 'rust'
    end

    -- Node.js项目
    if vim.fn.glob('package.json') ~= '' then
      return 'nodejs'
    end

    -- Lua项目
    if vim.fn.glob('*.lua') ~= '' and vim.fn.glob('init.lua') ~= '' then
      return 'lua'
    end

    return 'generic'
  end,

  -- 检查特定工具是否可用
  tools_available = {
    rust_analyzer = function()
      local clients = vim.lsp.get_clients({ name = 'rust-analyzer' })
      return #clients > 0
    end,
    tiny_code_action = function()
      return pcall(require, 'tiny-code-action')
    end,
    dap = function()
      return pcall(require, 'dap')
    end,
    neotest = function()
      return pcall(require, 'neotest')
    end,
  },

  -- 当前位置检测
  cursor_context = function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = line:sub(1, col)
    local after_cursor = line:sub(col + 1)

    return {
      line = line,
      before_cursor = before_cursor,
      after_cursor = after_cursor,
      is_at_word_end = before_cursor:match('%w$') ~= nil,
      is_at_word_start = after_cursor:match('^%w') ~= nil,
    }
  end,

  -- 缓冲区状态
  buffer_state = function()
    local bufnr = vim.api.nvim_get_current_buf()
    return {
      modified = vim.bo.modified,
      readonly = vim.bo.readonly,
      filetype = vim.bo.filetype,
      buftype = vim.bo.buftype,
      size = vim.api.nvim_buf_line_count(bufnr),
    }
  end,
}

-- 上下文收集器
local function collect_context()
  local context = {
    filetype = context_detectors.filetype(),
    project_type = context_detectors.project_type(),
    cursor_context = context_detectors.cursor_context(),
    buffer_state = context_detectors.buffer_state(),
    tools = {},
  }

  -- 检查可用工具
  for tool_name, detector in pairs(context_detectors.tools_available) do
    context.tools[tool_name] = detector()
  end

  return context
end

-- 处理器优先级定义
local handler_priorities = {
  -- 高优先级：语言特定处理器
  language_specific = 100,
  -- 中优先级：工具特定处理器
  tool_specific = 80,
  -- 低优先级：通用处理器
  generic = 50,
  -- 最低优先级：回退处理器
  fallback = 10,
}

-- 处理器注册表
local handlers = {}

-- 注册处理器
function M.register_handler(config)
  local handler = {
    name = config.name,
    priority = config.priority or handler_priorities.generic,
    match_conditions = config.match_conditions or function() return true end,
    execute = config.execute,
    description = config.description or '',
    modes = config.modes or { 'n' },
  }

  table.insert(handlers, handler)

  -- 按优先级排序
  table.sort(handlers, function(a, b)
    return a.priority > b.priority
  end)
end

-- 查找匹配的处理器
local function find_matching_handler(context, key_sequence, mode)
  for _, handler in ipairs(handlers) do
    -- 检查模式支持
    if not vim.tbl_contains(handler.modes, mode) then
      goto continue
    end

    -- 检查匹配条件
    if handler.match_conditions(context, key_sequence, mode) then
      return handler
    end

    ::continue::
  end

  return nil
end

-- 创建智能键映射
function M.create_smart_keymap(key_sequence, handler_configs, opts)
  opts = opts or {}
  local modes = opts.modes or { 'n' }
  local description = opts.description or '智能键映射'

  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, key_sequence, function()
      local context = collect_context()
      local handler = find_matching_handler(context, key_sequence, mode)

      if handler then
        handler.execute(context, key_sequence, mode)
      else
        -- 如果没有找到处理器，执行回退操作
        if opts.fallback then
          opts.fallback(context, key_sequence, mode)
        else
          require('config.smart-keys-notify').warning("没有找到适合的处理器: " .. key_sequence, '路由')
        end
      end
    end, {
      desc = description .. ' (' .. mode .. '模式)',
      noremap = true,
      silent = true
    })
  end
end

-- 预定义的智能键映射配置
local smart_keymaps = {
  -- 代码动作
  {
    keys = '<leader>a',
    modes = { 'n', 'x' },
    description = '智能代码动作',
    fallback = function()
      vim.lsp.buf.code_action()
    end,
    handlers = {
      {
        name = 'rust_code_action',
        priority = handler_priorities.language_specific,
        match_conditions = function(context)
          return context.filetype == 'rust' and context.tools.rust_analyzer
        end,
        execute = function()
          vim.cmd.RustLsp('codeAction')
        end,
        description = 'Rust 代码动作',
      },
      {
        name = 'tiny_code_action',
        priority = handler_priorities.tool_specific,
        match_conditions = function(context)
          return context.tools.tiny_code_action
        end,
        execute = function()
          require('tiny-code-action').code_action()
        end,
        description = '增强代码动作 UI',
      },
    }
  },

  -- 测试相关
  {
    keys = '<leader>tt',
    description = '智能测试运行',
    fallback = function()
      require('config.smart-keys-notify').notify('未找到测试运行器', vim.log.levels.WARN)
    end,
    handlers = {
      {
        name = 'rust_test',
        priority = handler_priorities.language_specific,
        match_conditions = function(context)
          return context.filetype == 'rust' and context.tools.neotest
        end,
        execute = function()
          require('neotest').run.run()
        end,
        description = 'Rust Neotest',
      },
      {
        name = 'python_test',
        priority = handler_priorities.language_specific,
        match_conditions = function(context)
          return context.filetype == 'python'
        end,
        execute = function()
          vim.cmd('!python -m pytest %')
        end,
        description = 'Python 测试',
      },
    }
  },

  -- 格式化
  {
    keys = '<leader>f',
    description = '智能格式化',
    fallback = function()
      vim.lsp.buf.format()
    end,
    handlers = {
      {
        name = 'rust_format',
        priority = handler_priorities.language_specific,
        match_conditions = function(context)
          return context.filetype == 'rust'
        end,
        execute = function()
          vim.cmd.RustLsp('format')
        end,
        description = 'Rust 格式化',
      },
    }
  },

  -- 搜索符号
  {
    keys = '<leader>s',
    description = '智能搜索',
    fallback = function()
      require('fzf-lua').live_grep()
    end,
    handlers = {
      {
        name = 'workspace_symbols',
        priority = handler_priorities.tool_specific,
        match_conditions = function(context)
          return context.tools.rust_analyzer
        end,
        execute = function()
          require('fzf-lua').lsp_workspace_symbols()
        end,
        description = '工作区符号',
      },
    }
  },
}

-- 初始化智能键位系统
function M.initialize()
  -- 注册所有处理器
  for _, keymap_config in ipairs(smart_keymaps) do
    for _, handler_config in ipairs(keymap_config.handlers) do
      M.register_handler(handler_config)
    end
  end

  -- 创建智能键映射
  for _, keymap_config in ipairs(smart_keymaps) do
    M.create_smart_keymap(
      keymap_config.keys,
      keymap_config.handlers,
      {
        modes = keymap_config.modes,
        description = keymap_config.description,
        fallback = keymap_config.fallback,
      }
    )
  end

  -- 创建用户命令
  vim.api.nvim_create_user_command('SmartKeyStatus', function()
    local context = collect_context()
    local lines = {
      '=== 智能键位系统状态 ===',
      '',
      string.format('文件类型: %s', context.filetype),
      string.format('项目类型: %s', context.project_type),
      string.format('可用工具: %s', vim.inspect(context.tools)),
      '',
      string.format('已注册处理器: %d 个', #handlers),
      '',
    }

    -- 列出处理器
    for i, handler in ipairs(handlers) do
      table.insert(lines, string.format('%2d. %s (优先级: %d)', i, handler.name, handler.priority))
      table.insert(lines, string.format('    描述: %s', handler.description))
      table.insert(lines, string.format('    模式: %s', table.concat(handler.modes, ', ')))
      table.insert(lines, '')
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
      title = '智能键位系统状态',
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {})
  end, { desc = '显示智能键位系统状态' })

  vim.api.nvim_create_user_command('SmartKeyRefresh', function()
    -- 重新初始化系统
    handlers = {}
    M.initialize()
    require('config.smart-keys-notify').success('智能键位系统已刷新', '系统')
  end, { desc = '刷新智能键位系统' })

  require('config.smart-keys-notify').success('智能键位覆盖引擎已启动', '系统')
end

-- 获取当前上下文信息
function M.get_current_context()
  return collect_context()
end

-- 添加新的智能键映射
function M.add_smart_keymap(config)
  table.insert(smart_keymaps, config)
  M.register_handler(config.handlers)
  M.create_smart_keymap(
    config.keys,
    config.handlers,
    {
      modes = config.modes,
      description = config.description,
      fallback = config.fallback,
    }
  )
end

return M