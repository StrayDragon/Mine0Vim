-- 智能键位扩展框架
-- 为其他语言和工具提供可扩展的键位映射系统

local M = {}

-- 框架版本
M.version = "1.0.0"

-- 扩展注册表
local extensions = {}

-- 工具注册表
local tools = {}

-- 模板系统
local templates = {
  -- 语言扩展模板
  language = {
    name = "language_template",
    description = "语言扩展模板",
    filetypes = {},
    handlers = {},
    tools = {},
    keymaps = {},
    priority = 80,
    init = function() end,
    setup = function() end,
  },

  -- 工具扩展模板
  tool = {
    name = "tool_template",
    description = "工具扩展模板",
    check_availability = function() return false end,
    handlers = {},
    keymaps = {},
    priority = 70,
    init = function() end,
    setup = function() end,
  },
}

-- 验证扩展配置
local function validate_extension(config, type)
  local required_fields = {
    language = { 'name', 'filetypes', 'handlers' },
    tool = { 'name', 'check_availability', 'handlers' },
  }

  local fields = required_fields[type]
  if not fields then
    return false, "未知的扩展类型: " .. type
  end

  for _, field in ipairs(fields) do
    if not config[field] then
      return false, "缺少必需字段: " .. field
    end
  end

  return true, "验证通过"
end

-- 注册语言扩展
function M.register_language_extension(config)
  local valid, message = validate_extension(config, 'language')
  if not valid then
    require('config.smart-keys-notify').notify("语言扩展注册失败: " .. message, vim.log.levels.ERROR)
    return false
  end

  -- 创建扩展对象
  local extension = vim.tbl_deep_extend('force', templates.language, config)

  -- 注册扩展
  extensions[extension.name] = extension

  -- 注册工具
  if extension.tools then
    for tool_name, tool_config in pairs(extension.tools) do
      tools[tool_name] = tool_config
    end
  end

  -- 注册处理器
  if extension.handlers then
    for _, handler in ipairs(extension.handlers) do
      require('config.smart-keys').register_handler(handler)
    end
  end

  -- 运行初始化
  if extension.init then
    extension.init()
  end

  require('config.smart-keys-notify').notify(string.format("语言扩展已注册: %s", extension.name), vim.log.levels.INFO)
  return true
end

-- 注册工具扩展
function M.register_tool_extension(config)
  local valid, message = validate_extension(config, 'tool')
  if not valid then
    require('config.smart-keys-notify').notify("工具扩展注册失败: " .. message, vim.log.levels.ERROR)
    return false
  end

  -- 创建扩展对象
  local extension = vim.tbl_deep_extend('force', templates.tool, config)

  -- 检查工具可用性
  if extension.check_availability and extension.check_availability() then
    tools[extension.name] = extension

    -- 注册处理器
    if extension.handlers then
      for _, handler in ipairs(extension.handlers) do
        require('config.smart-keys').register_handler(handler)
      end
    end

    -- 运行初始化
    if extension.init then
      extension.init()
    end

    require('config.smart-keys-notify').notify(string.format("工具扩展已注册: %s", extension.name), vim.log.levels.INFO)
    return true
  else
    require('config.smart-keys-notify').notify(string.format("工具扩展不可用: %s", extension.name), vim.log.levels.WARN)
    return false
  end
end

-- 创建语言扩展生成器
function M.create_language_generator(config)
  return {
    generate = function()
      local code = {
        string.format("-- %s 语言扩展", config.name),
        string.format("-- 由智能键位框架自动生成"),
        "",
        "local extension = {",
        string.format("  name = '%s',", config.name),
        string.format("  description = '%s 语言扩展',", config.name),
        string.format("  filetypes = { %s },", table.concat(config.filetypes, ', ')),
        string.format("  priority = %d,", config.priority or 80),
        "",
        "  handlers = {",
      }

      -- 生成处理器
      for _, handler_config in ipairs(config.handlers or {}) do
        table.insert(code, string.format("    {"))
        table.insert(code, string.format("      name = '%s',", handler_config.name))
        table.insert(code, string.format("      priority = %d,", handler_config.priority or 80))
        table.insert(code, string.format("      description = '%s',", handler_config.description or ''))
        table.insert(code, string.format("      modes = { %s },", table.concat(handler_config.modes or {'n'}, ', ')))
        table.insert(code, string.format("      match_conditions = function(context)"))
        table.insert(code, string.format("        return vim.tbl_contains(context.filetypes, '%s')", config.filetypes[1]))
        if handler_config.extra_conditions then
          table.insert(code, string.format("           and %s", handler_config.extra_conditions))
        end
        table.insert(code, string.format("      end,"))
        table.insert(code, string.format("      execute = function()"))
        table.insert(code, string.format("        %s", handler_config.execute))
        table.insert(code, string.format("      end,"))
        table.insert(code, string.format("    },"))
      end

      table.insert(code, "  },")
      table.insert(code, "")
      table.insert(code, "  keymaps = {")

      -- 生成键位映射
      for _, keymap_config in ipairs(config.keymaps or {}) do
        table.insert(code, string.format("    {"))
        table.insert(code, string.format("      keys = '%s',", keymap_config.keys))
        table.insert(code, string.format("      description = '%s',", keymap_config.description or ''))
        table.insert(code, string.format("      modes = { %s },", table.concat(keymap_config.modes or {'n'}, ', ')))
        table.insert(code, string.format("    },"))
      end

      table.insert(code, "  },")
      table.insert(code, "")
      table.insert(code, "  init = function()")
      table.insert(code, string.format("    require('config.smart-keys-notify').notify('%s 语言扩展已初始化', vim.log.levels.INFO)", config.name))
      table.insert(code, string.format("  end,"))
      table.insert(code, "")
      table.insert(code, string.format("  setup = function()"))
      table.insert(code, string.format("    -- %s 特定的设置", config.name))
      table.insert(code, string.format("  end,"))
      table.insert(code, "}")
      table.insert(code, "")
      table.insert(code, "return extension")

      return table.concat(code, '\n')
    end,
  }
end

-- 预定义的语言扩展
local predefined_extensions = {
  -- Go 语言扩展
  go = {
    name = 'go',
    description = 'Go 语言扩展',
    filetypes = { 'go' },
    priority = 90,
    handlers = {
      {
        name = 'go_test',
        priority = 90,
        description = 'Go 测试运行',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'go'
        end,
        execute = function()
          vim.cmd('!go test %')
        end,
      },
      {
        name = 'go_run',
        priority = 90,
        description = 'Go 运行',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'go'
        end,
        execute = function()
          vim.cmd('!go run %')
        end,
      },
      {
        name = 'go_build',
        priority = 90,
        description = 'Go 构建',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'go'
        end,
        execute = function()
          vim.cmd('!go build %')
        end,
      },
    },
    keymaps = {
      {
        keys = '<leader>tt',
        description = 'Go 测试',
        modes = { 'n' },
      },
      {
        keys = '<leader>rr',
        description = 'Go 运行',
        modes = { 'n' },
      },
      {
        keys = '<leader>cb',
        description = 'Go 构建',
        modes = { 'n' },
      },
    },
    init = function()
      require('config.smart-keys-notify').notify('Go 语言扩展已初始化', vim.log.levels.INFO)
    end,
  },

  -- C/C++ 语言扩展
  cpp = {
    name = 'cpp',
    description = 'C/C++ 语言扩展',
    filetypes = { 'c', 'cpp', 'h', 'hpp' },
    priority = 90,
    handlers = {
      {
        name = 'cpp_compile',
        priority = 90,
        description = 'C/C++ 编译',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'c' or context.filetype == 'cpp'
        end,
        execute = function()
          if context.filetype == 'c' then
            vim.cmd('!gcc % -o %<')
          else
            vim.cmd('!g++ % -o %<')
          end
        end,
      },
      {
        name = 'cpp_run',
        priority = 90,
        description = 'C/C++ 运行',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'c' or context.filetype == 'cpp'
        end,
        execute = function()
          vim.cmd('!./%<')
        end,
      },
    },
    keymaps = {
      {
        keys = '<leader>cb',
        description = 'C/C++ 编译',
        modes = { 'n' },
      },
      {
        keys = '<leader>rr',
        description = 'C/C++ 运行',
        modes = { 'n' },
      },
    },
    init = function()
      require('config.smart-keys-notify').notify('C/C++ 语言扩展已初始化', vim.log.levels.INFO)
    end,
  },

  -- Java 语言扩展
  java = {
    name = 'java',
    description = 'Java 语言扩展',
    filetypes = { 'java' },
    priority = 90,
    handlers = {
      {
        name = 'java_compile',
        priority = 90,
        description = 'Java 编译',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'java'
        end,
        execute = function()
          vim.cmd('!javac %')
        end,
      },
      {
        name = 'java_run',
        priority = 90,
        description = 'Java 运行',
        modes = { 'n' },
        match_conditions = function(context)
          return context.filetype == 'java'
        end,
        execute = function()
          local filename = vim.fn.expand('%:r')
          vim.cmd('!java ' .. filename)
        end,
      },
    },
    keymaps = {
      {
        keys = '<leader>cb',
        description = 'Java 编译',
        modes = { 'n' },
      },
      {
        keys = '<leader>rr',
        description = 'Java 运行',
        modes = { 'n' },
      },
    },
    init = function()
      require('config.smart-keys-notify').notify('Java 语言扩展已初始化', vim.log.levels.INFO)
    end,
  },
}

-- 初始化框架
function M.initialize()
  -- 注册预定义扩展
  for _, extension_config in pairs(predefined_extensions) do
    M.register_language_extension(extension_config)
  end

  -- 创建用户命令
  vim.api.nvim_create_user_command('SmartKeyExtensions', function()
    local lines = {
      '=== 智能键位扩展框架 ===',
      string.format('版本: %s', M.version),
      '',
      string.format('已注册扩展: %d 个', vim.tbl_count(extensions)),
      string.format('已注册工具: %d 个', vim.tbl_count(tools)),
      '',
    }

    -- 列出语言扩展
    table.insert(lines, '语言扩展:')
    for name, extension in pairs(extensions) do
      if extension.filetypes then
        table.insert(lines, string.format('  - %s: %s', name, table.concat(extension.filetypes, ', ')))
      end
    end
    table.insert(lines, '')

    -- 列出工具扩展
    table.insert(lines, '工具扩展:')
    for name, tool in pairs(tools) do
      table.insert(lines, string.format('  - %s: %s', name, tool.description or ''))
    end
    table.insert(lines, '')

    -- 显示在浮动窗口
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = math.min(60, vim.o.columns - 4),
      height = math.min(20, #lines + 2),
      col = math.floor((vim.o.columns - math.min(60, vim.o.columns - 4)) / 2),
      row = math.floor((vim.o.lines - math.min(20, #lines + 2)) / 2),
      style = 'minimal',
      border = 'rounded',
      title = '智能键位扩展框架',
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {})
  end, { desc = '显示智能键位扩展框架' })

  vim.api.nvim_create_user_command('SmartKeyGenerateExtension', function(opts)
    local args = opts.args
    if not args or args == '' then
      require('config.smart-keys-notify').notify('请提供扩展名称', vim.log.levels.ERROR)
      return
    end

    local generator = M.create_language_generator({
      name = args,
      filetypes = { args },
      priority = 80,
      handlers = {},
      keymaps = {},
    })

    local code = generator.generate()

    -- 显示生成的代码
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(code, '\n'))

    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = math.min(80, vim.o.columns - 4),
      height = math.min(30, 40),
      col = math.floor((vim.o.columns - math.min(80, vim.o.columns - 4)) / 2),
      row = math.floor((vim.o.lines - math.min(30, 40)) / 2),
      style = 'minimal',
      border = 'rounded',
      title = '生成的扩展代码',
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {})
  end, { nargs = 1, desc = '生成语言扩展代码' })

  require('config.smart-keys-notify').notify('智能键位扩展框架已启动', vim.log.levels.INFO)
end

-- 获取扩展信息
function M.get_extensions()
  return extensions
end

-- 获取工具信息
function M.get_tools()
  return tools
end

-- 手动加载扩展
function M.load_extension(config)
  if config.filetypes then
    return M.register_language_extension(config)
  elseif config.check_availability then
    return M.register_tool_extension(config)
  else
    require('config.smart-keys-notify').notify('未知的扩展类型', vim.log.levels.ERROR)
    return false
  end
end

return M