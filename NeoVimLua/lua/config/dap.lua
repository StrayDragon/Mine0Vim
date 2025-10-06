-- 调试适配器协议 (DAP) 配置，用于增强调试功能
-- 与 rustaceanvim 的 DAP 集成配合工作

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    -- DAP 所需的异步 IO 库
    { 'nvim-neotest/nvim-nio', lazy = true },
    -- 调试用户界面
    { 'rcarriga/nvim-dap-ui', lazy = true },
    -- 调试虚拟文本
    { 'theHamsta/nvim-dap-virtual-text', lazy = true },
    -- Mason 的 DAP 集成
    { 'jay-babu/mason-nvim-dap.nvim', lazy = true },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- 根据可用的调试适配器自动配置
    local function setup_debug_adapters()
      -- 检查可用的调试适配器
      local debug_adapters = {}

      if vim.fn.executable('codelldb') == 1 then
        debug_adapters.codelldb = {
          type = 'server',
          port = '${port}',
          executable = {
            command = 'codelldb',
            args = { '--port', '${port}' },
          },
          name = 'codelldb',
        }
      elseif vim.fn.executable('lldb-vscode') == 1 then
        debug_adapters.lldb = {
          type = 'executable',
          command = 'lldb-vscode',
          name = 'lldb',
        }
      elseif vim.fn.executable('lldb-dap') == 1 then
        debug_adapters.lldb = {
          type = 'executable',
          command = 'lldb-dap',
          name = 'lldb',
        }
      else
        vim.notify(
          '未找到调试适配器。请安装 codelldb 或 lldb-vscode 以支持调试。',
          vim.log.levels.WARN
        )
      end

      return debug_adapters
    end

    -- 配置适配器
    local adapters = setup_debug_adapters()
    for name, config in pairs(adapters) do
      dap.adapters[name] = config
    end

    -- 为 Rust 配置调试配置
    dap.configurations.rust = {
      {
        name = '启动程序',
        type = vim.fn.executable('codelldb') == 1 and 'codelldb' or 'lldb',
        request = 'launch',
        program = function()
          -- 尝试从 Cargo.toml 获取目标可执行文件
          local cargo_toml = vim.fn.findfile('Cargo.toml', '.;')
          if cargo_toml ~= '' then
            -- 使用 cargo 构建并获取目标路径
            return vim.fn.input('可执行文件路径: ', 'target/debug/')
          else
            return vim.fn.input('可执行文件路径: ', vim.fn.getcwd() .. '/')
          end
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        env = {
          RUST_LOG = 'debug',
        },
        console = 'integratedTerminal',
        sourceLanguages = { 'rust' },
      },
      {
        name = '附加到进程',
        type = vim.fn.executable('codelldb') == 1 and 'codelldb' or 'lldb',
        request = 'attach',
        processId = function()
          return require('dap.utils').pick_process()
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        sourceLanguages = { 'rust' },
      },
      {
        name = '运行测试',
        type = vim.fn.executable('codelldb') == 1 and 'codelldb' or 'lldb',
        request = 'launch',
        program = function()
          -- 使用 cargo test 获取测试可执行文件
          return vim.fn.input('测试可执行文件路径: ', 'target/debug/deps/')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          return vim.fn.input('测试参数: ', '')
        end,
        env = {
          RUST_LOG = 'debug',
        },
        console = 'integratedTerminal',
        sourceLanguages = { 'rust' },
      },
    }

    -- 设置 DAP UI
    require('dapui').setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = ""
        }
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" }
        }
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
      },
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25
            },
            {
              id = "breakpoints",
              size = 0.25
            },
            {
              id = "stacks",
              size = 0.25
            },
            {
              id = "watches",
              size = 0.25
            }
          },
          position = "left",
          size = 40
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5
            },
            {
              id = "console",
              size = 0.5
            }
          },
          position = "bottom",
          size = 10
        }
      },
      render = {
        indent = 1,
        max_value_lines = 100
      }
    })

    -- 设置虚拟文本
    require('nvim-dap-virtual-text').setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = '<module',
      virt_text_pos = 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil
    })

    -- 调试开始时自动打开 DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- 调试键位映射
    vim.keymap.set('n', '<leader>db', function()
      require('dap').toggle_breakpoint()
    end, { desc = '切换断点' })

    vim.keymap.set('n', '<leader>dB', function()
      require('dap').set_breakpoint(vim.fn.input('断点条件: '))
    end, { desc = '条件断点' })

    vim.keymap.set('n', '<leader>dc', function()
      require('dap').continue()
    end, { desc = '继续/开始调试' })

    vim.keymap.set('n', '<leader>dC', function()
      require('dap').run_to_cursor()
    end, { desc = '运行到光标处' })

    vim.keymap.set('n', '<leader>do', function()
      require('dap').step_over()
    end, { desc = '跳过' })

    vim.keymap.set('n', '<leader>di', function()
      require('dap').step_into()
    end, { desc = '步入' })

    vim.keymap.set('n', '<leader>dO', function()
      require('dap').step_out()
    end, { desc = '步出' })

    vim.keymap.set('n', '<leader>dq', function()
      require('dap').terminate()
    end, { desc = '终止调试' })

    vim.keymap.set('n', '<leader>dr', function()
      require('dap').restart()
    end, { desc = '重新调试' })

    vim.keymap.set('n', '<leader>du', function()
      require('dapui').toggle()
    end, { desc = '切换调试 UI' })

    vim.keymap.set('n', '<leader>de', function()
      require('dapui').eval()
    end, { desc = '求值表达式' })

    vim.keymap.set('v', '<leader>de', function()
      require('dapui').eval()
    end, { desc = '求值选中内容' })

    -- Rust 专用调试快捷键
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'rust',
      callback = function()
        vim.keymap.set('n', '<leader>dt', function()
          -- 调试当前测试
          local test_name = vim.fn.expand('<cword>')
          if test_name:match('^test_') or test_name:match('#test') then
            require('dap').continue({ args = { test_name } })
          else
            require('dap').continue()
          end
        end, { buffer = true, desc = '调试当前测试' })

        vim.keymap.set('n', '<leader>dm', function()
          -- 调试 main 函数
          require('dap').continue({ args = { 'main' } })
        end, { buffer = true, desc = '调试主函数' })

        vim.keymap.set('n', '<leader>dbp', function()
          -- 切换带日志的断点
          require('dap').set_breakpoint(nil, nil, vim.fn.input('日志消息: '))
        end, { buffer = true, desc = '带日志的断点' })
      end
    })

    -- 设置 Mason DAP 集成
    require('mason-nvim-dap').setup({
      automatic_setup = true,
      handlers = {},
      ensure_installed = {
        'codelldb', -- Rust 调试首选
      }
    })

    -- 增强的调试状态
    vim.keymap.set('n', '<leader>ds', function()
      local session = require('dap').session()
      if session then
        print("调试会话活跃: " .. session.config.name)
      else
        print("没有活跃的调试会话")
      end
    end, { desc = '显示调试状态' })
  end,
}