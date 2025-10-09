-- 智能键位语言扩展系统
-- 为不同编程语言提供特定的智能键位处理器

local M = {}

-- 导入智能键位核心系统
local smart_keys = require('config.smart-keys')

-- 语言特定处理器集合
local language_handlers = {}

-- Rust 语言处理器
M.rust = {
  -- 代码动作处理器
  code_action = {
    name = 'rust_code_action',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'rust' and context.tools.rust_analyzer
    end,
    execute = function()
      vim.cmd.RustLsp('codeAction')
    end,
    description = 'Rust 代码动作',
    modes = { 'n', 'x' },
  },

  -- 格式化处理器
  format = {
    name = 'rust_format',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'rust'
    end,
    execute = function()
      vim.cmd.RustLsp('format')
    end,
    description = 'Rust 格式化',
  },

  -- 测试处理器
  test = {
    name = 'rust_test',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'rust' and context.tools.neotest
    end,
    execute = function()
      require('neotest').run.run()
    end,
    description = 'Rust 测试运行',
  },

  -- Cargo 构建处理器
  cargo_build = {
    name = 'rust_cargo_build',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'rust' and not vim.fn.expand('%:t'):match('Cargo%.toml$')
    end,
    execute = function()
      vim.cmd('!cargo build')
    end,
    description = 'Cargo 构建',
  },

  -- 宏展开处理器
  macro_expand = {
    name = 'rust_macro_expand',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'rust' and context.tools.rust_analyzer
    end,
    execute = function()
      vim.cmd.RustLsp('expandMacro')
    end,
    description = 'Rust 宏展开',
  },

  -- 调试处理器
  debug = {
    name = 'rust_debug',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'rust' and context.tools.dap
    end,
    execute = function()
      vim.cmd.RustLsp('debuggables')
    end,
    description = 'Rust 调试',
  },
}

-- Python 语言处理器
M.python = {
  -- 代码动作处理器
  code_action = {
    name = 'python_code_action',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'python'
    end,
    execute = function()
      vim.lsp.buf.code_action()
    end,
    description = 'Python 代码动作',
    modes = { 'n', 'x' },
  },

  -- 测试处理器
  test = {
    name = 'python_test',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'python'
    end,
    execute = function()
      vim.cmd('!python -m pytest %')
    end,
    description = 'Python 测试运行',
  },

  -- 格式化处理器
  format = {
    name = 'python_format',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'python'
    end,
    execute = function()
      vim.lsp.buf.format()
    end,
    description = 'Python 格式化',
  },

  -- 运行脚本处理器
  run = {
    name = 'python_run',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'python' and context.buffer_state.buftype == ''
    end,
    execute = function()
      vim.cmd('!python %')
    end,
    description = 'Python 运行脚本',
  },
}

-- Lua 语言处理器
M.lua = {
  -- 代码动作处理器
  code_action = {
    name = 'lua_code_action',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'lua'
    end,
    execute = function()
      vim.lsp.buf.code_action()
    end,
    description = 'Lua 代码动作',
    modes = { 'n', 'x' },
  },

  -- 格式化处理器
  format = {
    name = 'lua_format',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'lua'
    end,
    execute = function()
      vim.lsp.buf.format()
    end,
    description = 'Lua 格式化',
  },

  -- 运行脚本处理器
  run = {
    name = 'lua_run',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'lua' and context.buffer_state.buftype == ''
    end,
    execute = function()
      vim.cmd('!lua %')
    end,
    description = 'Lua 运行脚本',
  },
}

-- JavaScript/TypeScript 处理器
M.javascript = {
  -- 代码动作处理器
  code_action = {
    name = 'javascript_code_action',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'javascript' or context.filetype == 'typescript'
    end,
    execute = function()
      vim.lsp.buf.code_action()
    end,
    description = 'JavaScript/TypeScript 代码动作',
    modes = { 'n', 'x' },
  },

  -- 格式化处理器
  format = {
    name = 'javascript_format',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'javascript' or context.filetype == 'typescript'
    end,
    execute = function()
      vim.lsp.buf.format()
    end,
    description = 'JavaScript/TypeScript 格式化',
  },

  -- 测试处理器
  test = {
    name = 'javascript_test',
    priority = 100,
    match_conditions = function(context)
      return context.filetype == 'javascript' or context.filetype == 'typescript'
    end,
    execute = function()
      vim.cmd('!npm test')
    end,
    description = 'JavaScript/TypeScript 测试运行',
  },
}

-- 通用处理器（回退）
M.generic = {
  -- 通用代码动作
  code_action = {
    name = 'generic_code_action',
    priority = 50,
    match_conditions = function(context)
      return true -- 适用于所有文件类型
    end,
    execute = function()
      vim.lsp.buf.code_action()
    end,
    description = '通用代码动作',
    modes = { 'n', 'x' },
  },

  -- 通用格式化
  format = {
    name = 'generic_format',
    priority = 50,
    match_conditions = function(context)
      return true
    end,
    execute = function()
      vim.lsp.buf.format()
    end,
    description = '通用格式化',
  },

  -- 通用测试
  test = {
    name = 'generic_test',
    priority = 50,
    match_conditions = function(context)
      return true
    end,
    execute = function()
      require('config.smart-keys-notify').warning('未找到适合的测试运行器', '测试')
    end,
    description = '通用测试处理器',
  },
}

-- 注册语言处理器
function M.register_language_handlers()
  -- 注册 Rust 处理器
  for _, handler in pairs(M.rust) do
    smart_keys.register_handler(handler)
  end

  -- 注册 Python 处理器
  for _, handler in pairs(M.python) do
    smart_keys.register_handler(handler)
  end

  -- 注册 Lua 处理器
  for _, handler in pairs(M.lua) do
    smart_keys.register_handler(handler)
  end

  -- 注册 JavaScript 处理器
  for _, handler in pairs(M.javascript) do
    smart_keys.register_handler(handler)
  end

  -- 注册通用处理器
  for _, handler in pairs(M.generic) do
    smart_keys.register_handler(handler)
  end

  require('config.smart-keys-notify').success('语言特定处理器已注册', '系统')
end

-- 创建语言特定的智能键映射
function M.create_language_smart_keymaps()
  -- 代码动作映射
  smart_keys.create_smart_keymap('<leader>a', {
    M.rust.code_action,
    M.python.code_action,
    M.lua.code_action,
    M.javascript.code_action,
    M.generic.code_action,
  }, {
    modes = { 'n', 'x' },
    description = '语言感知代码动作',
    fallback = function()
      vim.lsp.buf.code_action()
    end,
  })

  -- 格式化映射
  smart_keys.create_smart_keymap('<leader>f', {
    M.rust.format,
    M.python.format,
    M.lua.format,
    M.javascript.format,
    M.generic.format,
  }, {
    description = '语言感知格式化',
    fallback = function()
      vim.lsp.buf.format()
    end,
  })

  -- 测试映射
  smart_keys.create_smart_keymap('<leader>tt', {
    M.rust.test,
    M.python.test,
    M.javascript.test,
    M.generic.test,
  }, {
    description = '语言感知测试运行',
    fallback = function()
      require('config.smart-keys-notify').warning('未找到适合的测试运行器', '测试')
    end,
  })

  -- 运行映射
  smart_keys.create_smart_keymap('<leader>rr', {
    M.rust.cargo_build,
    M.python.run,
    M.lua.run,
  }, {
    description = '语言感知运行',
    fallback = function()
      require('config.smart-keys-notify').warning('未找到适合的运行器', '运行')
    end,
  })

  -- 调试映射
  smart_keys.create_smart_keymap('<leader>dt', {
    M.rust.debug,
  }, {
    description = '语言感知调试',
    fallback = function()
      require('dap').continue()
    end,
  })
end

-- 获取语言特定处理器
function M.get_language_handlers(language)
  return M[language] or M.generic
end

-- 添加新的语言处理器
function M.add_language(language, handlers)
  M[language] = handlers
  -- 注册新的处理器
  for _, handler in pairs(handlers) do
    smart_keys.register_handler(handler)
  end
  require('config.smart-keys-notify').info(string.format('已添加 %s 语言处理器', language), '扩展')
end

-- 初始化语言扩展系统
function M.initialize()
  M.register_language_handlers()
  M.create_language_smart_keymaps()

  -- 创建用户命令
  vim.api.nvim_create_user_command('SmartKeyLanguages', function()
    local lines = {
      '=== 智能键位语言支持 ===',
      '',
    }

    for language, handlers in pairs(M) do
      if type(handlers) == 'table' and language ~= 'add_language' and language ~= 'get_language_handlers' and language ~= 'register_language_handlers' and language ~= 'create_language_smart_keymaps' and language ~= 'initialize' then
        table.insert(lines, string.format('%s 语言:', language:sub(1, 1):upper() .. language:sub(2)))
        for handler_name, handler in pairs(handlers) do
          if type(handler) == 'table' and handler.name then
            table.insert(lines, string.format('  - %s: %s', handler_name, handler.description))
          end
        end
        table.insert(lines, '')
      end
    end

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
      title = '智能键位语言支持',
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {})
  end, { desc = '显示智能键位语言支持' })

  require('config.smart-keys-notify').success('智能键位语言扩展系统已启动', '系统')
end

return M