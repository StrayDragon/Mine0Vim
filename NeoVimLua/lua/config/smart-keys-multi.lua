-- 智能键位多模式支持系统
-- 支持不同模式下的智能键位映射

local M = {}

-- 支持的模式
local supported_modes = {
  'n',  -- Normal mode
  'v',  -- Visual mode
  'x',  -- Visual (selection) mode
  's',  -- Select mode
  'o',  -- Operator-pending mode
  'i',  -- Insert mode
  'c',  -- Command-line mode
  't',  -- Terminal mode
}

-- 模式描述
local mode_descriptions = {
  n = '普通模式',
  v = '视觉模式',
  x = '选择模式',
  s = '选择模式',
  o = '操作待定模式',
  i = '插入模式',
  c = '命令行模式',
  t = '终端模式',
}

-- 模式特定的处理器
local mode_specific_handlers = {
  -- 普通模式处理器
  n = {
    -- 导航相关
    {
      name = 'normal_navigation',
      match_conditions = function(context, key_sequence)
        return key_sequence:match('^g') or key_sequence:match('^]')
      end,
      execute = function(context, key_sequence)
        -- 普通模式导航处理
        require('config.smart-keys-notify').notify('普通模式导航: ' .. key_sequence, vim.log.levels.DEBUG)
      end,
      description = '普通模式导航',
    },

    -- 文本编辑相关
    {
      name = 'normal_editing',
      match_conditions = function(context, key_sequence)
        return key_sequence:match('^d') or key_sequence:match('^c') or key_sequence:match('^y')
      end,
      execute = function(context, key_sequence)
        -- 普通模式编辑处理
        require('config.smart-keys-notify').notify('普通模式编辑: ' .. key_sequence, vim.log.levels.DEBUG)
      end,
      description = '普通模式编辑',
    },
  },

  -- 视觉模式处理器
  v = {
    -- 视觉模式选择处理
    {
      name = 'visual_selection',
      match_conditions = function(context, key_sequence)
        return key_sequence:match('^<leader>')
      end,
      execute = function(context, key_sequence)
        -- 视觉模式选择处理
        local selected_text = vim.fn.getreg('"')
        require('config.smart-keys-notify').notify('视觉模式选择: ' .. selected_text, vim.log.levels.DEBUG)
      end,
      description = '视觉模式选择',
    },
  },

  -- 插入模式处理器
  i = {
    -- 插入模式补全处理
    {
      name = 'insert_completion',
      match_conditions = function(context, key_sequence)
        return key_sequence:match('^<Tab>') or key_sequence:match('^<C-.>')
      end,
      execute = function(context, key_sequence)
        -- 插入模式补全处理
        if pcall(require, 'cmp') then
          require('cmp').complete()
        end
      end,
      description = '插入模式补全',
    },
  },

  -- 终端模式处理器
  t = {
    -- 终端模式导航处理
    {
      name = 'terminal_navigation',
      match_conditions = function(context, key_sequence)
        return key_sequence:match('^<C-.>')
      end,
      execute = function(context, key_sequence)
        -- 终端模式导航处理
        require('config.smart-keys-notify').notify('终端模式导航: ' .. key_sequence, vim.log.levels.DEBUG)
      end,
      description = '终端模式导航',
    },
  },
}

-- 多模式智能键映射创建器
function M.create_multi_mode_keymap(key_sequence, config)
  config = config or {}
  local modes = config.modes or supported_modes
  local mode_handlers = config.mode_handlers or {}
  local fallback = config.fallback

  for _, mode in ipairs(modes) do
    local mode_config = mode_handlers[mode] or {}
    local description = mode_config.description or config.description or '多模式键映射'

    vim.keymap.set(mode, key_sequence, function()
      local context = require('config.smart-keys').get_current_context()

      -- 检查模式特定处理器
      if mode_specific_handlers[mode] then
        for _, handler in ipairs(mode_specific_handlers[mode]) do
          if handler.match_conditions(context, key_sequence) then
            handler.execute(context, key_sequence)
            return
          end
        end
      end

      -- 检查通用处理器
      if mode_config.execute then
        mode_config.execute(context, key_sequence, mode)
        return
      end

      -- 回退处理
      if fallback then
        fallback(context, key_sequence, mode)
      else
        require('config.smart-keys-notify').notify("未找到适合的处理器: " .. key_sequence .. " (" .. mode .. "模式)", vim.log.levels.WARN)
      end
    end, {
      desc = description .. ' (' .. mode_descriptions[mode] .. ')',
      noremap = true,
      silent = true,
    })
  end
end

-- 多模式上下文检测器
local multi_mode_context_detectors = {
  -- 检测当前模式
  current_mode = function()
    return vim.api.nvim_get_mode().mode
  end,

  -- 检测可视模式选择
  visual_selection = function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' or mode == 'V' or mode == '^V' then
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      if start_pos[2] and end_pos[2] then
        local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
        local selected_text = table.concat(lines, '\n')
        return {
          mode = mode,
          start_line = start_pos[2],
          end_line = end_pos[2],
          text = selected_text,
        }
      end
    end
    return nil
  end,

  -- 检测插入模式状态
  insert_context = function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' then
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      return {
        line = line,
        col = col,
        before_cursor = line:sub(1, col),
        after_cursor = line:sub(col + 1),
      }
    end
    return nil
  end,

  -- 检测终端模式状态
  terminal_context = function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 't' then
      return {
        buffer_type = vim.bo.buftype,
        filetype = vim.bo.filetype,
      }
    end
    return nil
  end,
}

-- 增强上下文收集器
local function collect_multi_mode_context()
  -- 导入原始的上下文收集器以避免递归
  local smart_keys = require('config.smart-keys')

  -- 保存原始函数并临时恢复
  local original_get_context = smart_keys.get_current_context
  smart_keys.get_current_context = smart_keys._original_get_context or original_get_context

  -- 获取基础上下文
  local base_context = smart_keys.get_current_context()

  -- 恢复增强版本
  smart_keys.get_current_context = collect_multi_mode_context

  -- 添加多模式特定信息
  base_context.mode = multi_mode_context_detectors.current_mode()
  base_context.visual_selection = multi_mode_context_detectors.visual_selection()
  base_context.insert_context = multi_mode_context_detectors.insert_context()
  base_context.terminal_context = multi_mode_context_detectors.terminal_context()

  return base_context
end

-- 多模式智能键映射配置
local multi_mode_keymaps = {
  -- 代码动作（多模式支持）
  {
    keys = '<leader>a',
    modes = { 'n', 'x' },
    description = '多模式代码动作',
    mode_handlers = {
      n = {
        description = '普通模式代码动作',
        execute = function(context)
          local filetype = context.filetype
          if filetype == 'rust' and context.tools.rust_analyzer then
            vim.cmd.RustLsp('codeAction')
          elseif context.tools.tiny_code_action then
            require('tiny-code-action').code_action()
          else
            vim.lsp.buf.code_action()
          end
        end,
      },
      x = {
        description = '视觉模式代码动作',
        execute = function(context)
          local filetype = context.filetype
          if filetype == 'rust' and context.tools.rust_analyzer then
            vim.cmd.RustLsp('codeAction')
          else
            vim.lsp.buf.code_action()
          end
        end,
      },
    },
    fallback = function()
      vim.lsp.buf.code_action()
    end,
  },

  -- 搜索功能（多模式支持）
  {
    keys = '<leader>s',
    modes = { 'n', 'v', 'x' },
    description = '多模式搜索',
    mode_handlers = {
      n = {
        description = '普通模式搜索',
        execute = function(context)
          require('fzf-lua').live_grep()
        end,
      },
      v = {
        description = '视觉模式搜索',
        execute = function(context)
          -- 获取选中的文本进行搜索
          local selected_text = vim.fn.getreg('"')
          if selected_text and selected_text ~= '' then
            require('fzf-lua').live_grep({ search = selected_text })
          else
            require('fzf-lua').live_grep()
          end
        end,
      },
      x = {
        description = '选择模式搜索',
        execute = function(context)
          local selected_text = vim.fn.getreg('"')
          if selected_text and selected_text ~= '' then
            require('fzf-lua').live_grep({ search = selected_text })
          else
            require('fzf-lua').live_grep()
          end
        end,
      },
    },
    fallback = function()
      require('fzf-lua').live_grep()
    end,
  },

  -- 格式化（多模式支持）
  {
    keys = '<leader>f',
    modes = { 'n', 'v', 'x' },
    description = '多模式格式化',
    mode_handlers = {
      n = {
        description = '普通模式格式化',
        execute = function(context)
          local filetype = context.filetype
          if filetype == 'rust' then
            vim.cmd.RustLsp('format')
          else
            vim.lsp.buf.format()
          end
        end,
      },
      v = {
        description = '视觉模式格式化',
        execute = function(context)
          vim.lsp.buf.format({ range = {
            start = { vim.fn.line("'<"), 0 },
            ["end"] = { vim.fn.line("'>"), 0 },
          }})
        end,
      },
      x = {
        description = '选择模式格式化',
        execute = function(context)
          vim.lsp.buf.format({ range = {
            start = { vim.fn.line("'<"), 0 },
            ["end"] = { vim.fn.line("'>"), 0 },
          }})
        end,
      },
    },
    fallback = function()
      vim.lsp.buf.format()
    end,
  },

  -- 终端模式特定映射
  {
    keys = '<C-\\>',
    modes = { 't' },
    description = '终端模式退出',
    mode_handlers = {
      t = {
        description = '退出终端模式',
        execute = function(context)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 'n', false)
        end,
      },
    },
  },
}

-- 初始化多模式系统
function M.initialize()
  -- 注册所有多模式键映射
  for _, keymap_config in ipairs(multi_mode_keymaps) do
    M.create_multi_mode_keymap(keymap_config.keys, keymap_config)
  end

  -- 保存原始函数并重写上下文收集器
  local smart_keys = require('config.smart-keys')
  smart_keys._original_get_context = smart_keys.get_current_context
  smart_keys.get_current_context = collect_multi_mode_context

  -- 创建用户命令
  vim.api.nvim_create_user_command('SmartKeyMultiMode', function()
    local lines = {
      '=== 多模式键位系统状态 ===',
      '',
    }

    for mode, desc in pairs(mode_descriptions) do
      table.insert(lines, string.format('%s (%s):', desc, mode))
      if mode_specific_handlers[mode] then
        for _, handler in ipairs(mode_specific_handlers[mode]) do
          table.insert(lines, string.format('  - %s', handler.description))
        end
      end
      table.insert(lines, '')
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
      title = '多模式键位系统',
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {})
  end, { desc = '显示多模式键位系统状态' })

  require('config.smart-keys-notify').notify('智能键位多模式支持系统已启动', vim.log.levels.INFO)
end

-- 注册新的多模式处理器
function M.register_mode_handler(mode, handler)
  if not mode_specific_handlers[mode] then
    mode_specific_handlers[mode] = {}
  end
  table.insert(mode_specific_handlers[mode], handler)
  require('config.smart-keys-notify').notify(string.format('已注册 %s 模式处理器: %s', mode_descriptions[mode] or mode, handler.name), vim.log.levels.INFO)
end

-- 添加新的多模式键映射
function M.add_multi_mode_keymap(config)
  table.insert(multi_mode_keymaps, config)
  M.create_multi_mode_keymap(config.keys, config)
  require('config.smart-keys-notify').notify(string.format('已添加多模式键映射: %s', config.keys), vim.log.levels.INFO)
end

return M