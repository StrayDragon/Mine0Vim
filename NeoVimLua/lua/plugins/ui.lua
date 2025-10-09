return {
  -- OneNord 主题 - 结合 Nord 和 Atom One Dark 调色板
  {
    "rmehri01/onenord.nvim",
    lazy = false, -- 立即加载主题
    priority = 1000, -- 高优先级确保主题在其他插件之前加载
    config = function()
      require('onenord').setup({
        theme = "dark", -- 或 "light"，也可以通过 vim.o.background 设置
        borders = true, -- 分割窗口边框
        fade_nc = false, -- 淡化非当前窗口
        styles = {
          comments = "NONE",
          strings = "NONE",
          keywords = "NONE",
          functions = "NONE",
          variables = "NONE",
          diagnostics = "underline",
        },
        disable = {
          background = false, -- 不禁用背景色
          float_background = false, -- 不禁用浮动窗口背景色
          cursorline = false, -- 不禁用光标行
          eob_lines = true, -- 隐藏 end-of-buffer 行
        },
        inverse = {
          match_paren = false,
        },
        custom_highlights = {}, -- 自定义高亮组
        custom_colors = {}, -- 自定义颜色
      })
    end,
  },

  -- 图标插件（解决 which-key 警告）
  {
    "echasnovski/mini.icons",
    lazy = true,
    config = function()
      require('mini.icons').setup()
    end,
  },

  { "stevearc/aerial.nvim", opts = {}, keys = {
      { "<A-7>", "<cmd>AerialToggle!<CR>", mode = "n", desc = "切换大纲视图" },
      { "<space>ao", "<cmd>AerialToggle!<CR>", mode = "n", desc = "切换大纲视图" },
    }
  },
  { "ingur/floatty.nvim", config = function()
      local term = require("floatty").setup({})
      -- 终端切换（Ctrl+F12，macOS 兼容）
      vim.keymap.set('n', '<C-F12>', function() term.toggle() end, { desc = '切换终端 (Ctrl+F12)' })
      vim.keymap.set('t', '<C-F12>', function() term.toggle() end, { desc = '切换终端 (Ctrl+F12)' })
    end
  },
  { "nvim-lualine/lualine.nvim",
    lazy = false,  -- 立即加载状态栏
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- 自定义内联提示状态组件
      local function inlay_hints_status()
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.lsp.inlay_hint then
          return ''
        end

        local enabled = false
        if vim.lsp.inlay_hint.is_enabled then
          local ok, val = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
          if not ok then
            ok, val = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
          end
          if ok then enabled = val end
        end

        return enabled and '💡 提示' or ''
      end

  
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'onenord',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {
              'NvimTree', 'neo-tree', 'neo-tree-popup', 'aerial', 'aerial-nav',
              'toggleterm', 'fzf', 'FzfLua', 'TelescopePrompt', 'TelescopeResults',
              'undotree', 'git', 'diff', 'help', 'lazy', 'mason', 'mason.nvim',
              'qf', 'quickfix', 'starter', 'alpha', 'dashboard', 'oil', 'minifiles',
              'netrw', 'Trouble', 'terminal', 'claude', 'claudecode', 'snacks_terminal',
              'ClaudeTerminal', 'claude-terminal', 'Claude', 'claude_code_terminal',
              -- DAP调试UI窗口
              'dap-repl', 'dap-ui_scopes', 'dap-ui_watches', 'dap-ui_stacks',
              'dap-ui_breakpoints', 'dap-ui_console', 'dap-float', 'dap-terminal'
            },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 200,    -- 更频繁的刷新以显示LSP状态变化
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16,  -- ~60fps刷新率
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'LspAttach',
              'LspDetach',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          }
        },
        sections = {
          lualine_a = {'mode'},  -- 模式
          lualine_b = {'branch', 'diff',  -- 分支和差异
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              sections = { 'error', 'warn', 'info', 'hint' },
              diagnostics_color = {
                error = 'DiagnosticError',
                warn  = 'DiagnosticWarn',
                info  = 'DiagnosticInfo',
                hint  = 'DiagnosticHint',
              },
              symbols = {error = '🔴', warn = '🟡', info = '🔵', hint = '⚪'},
              colored = true,
              always_visible = false,
            }
          },
          lualine_c = {
            {
              'filename',
              file_status = true,      -- 显示文件状态（只读、修改状态）
              newfile_status = false,  -- 显示新文件状态
              path = 0,                -- 0: 仅文件名
              shorting_target = 40,    -- 缩短路径以保留 40 个空格
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[无名称]',
                newfile = '[新]'
              }
            },
          },
          lualine_x = {
            { 'lsp_status',
              icon = '🔧',
              symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                done = '✓',
                separator = ' ',
              },
              ignore_lsp = { 'null-ls', 'copilot' },
              color = { fg = '#999999' }
            },
            { inlay_hints_status, color = { fg = '#aaaaaa' } },   -- 内联提示状态
            'encoding',           -- 编码
            'fileformat',         -- 文件格式
            'filetype'            -- 文件类型
          },
          lualine_y = {'progress'},  -- 进度
          lualine_z = {'location'}   -- 位置
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end
  },
  { "Yggdroot/indentLine", config = function()
      -- 按照旧配置仅为 Python 文件配置缩进线
      vim.g.indentLine_fileType = { "python" }

      -- 设置缩进线颜色
      vim.g.indentLine_color_term = 239      -- 终端下的颜色
      vim.g.indentLine_color_gui = '#3a3a3a' -- GUI下的颜色

      -- 禁用某些字符的缩进线显示
      vim.g.indentLine_concealcursor = 'nc'   -- 在普通和可视模式下隐藏
      vim.g.indentLine_conceallevel = 2       -- 隐藏级别
      vim.g.indentLine_char = '│'              -- 使用 │ 字符
    end
  },
}