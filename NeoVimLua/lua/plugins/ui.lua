return {
  { "stevearc/aerial.nvim", opts = {}, keys = {
      { "<C-7>", "<cmd>AerialToggle!<CR>", mode = "n", desc = "切换大纲视图" },
      { "<space>o", "<cmd>AerialToggle!<CR>", mode = "n", desc = "切换大纲视图" },
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
      -- 自定义 LSP 状态组件
      local function lsp_status()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = {}

        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = bufnr })
        elseif vim.lsp.get_active_clients then
          clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        end

        if #clients == 0 then
          return ''
        end

        local client_names = {}
        for _, client in ipairs(clients) do
          if client.name ~= 'null-ls' then
            table.insert(client_names, client.name)
          end
        end

        if #client_names > 0 then
          return '🔧 ' .. table.concat(client_names, ', ')
        else
          return ''
        end
      end

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
          theme = 'PaperColor',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {
              'NvimTree', 'neo-tree', 'neo-tree-popup', 'aerial', 'aerial-nav',
              'toggleterm', 'fzf', 'FzfLua', 'TelescopePrompt', 'TelescopeResults',
              'undotree', 'git', 'diff', 'help', 'lazy', 'mason', 'mason.nvim',
              'qf', 'quickfix', 'starter', 'alpha', 'dashboard', 'oil', 'minifiles',
              'netrw', 'Trouble', 'terminal', 'claude', 'claudecode', 'snacks_terminal',
              'ClaudeTerminal', 'claude-terminal', 'Claude', 'claude_code_terminal'
            },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
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
            { lsp_status, color = { fg = '#666666' } },           -- LSP 状态
            { inlay_hints_status, color = { fg = '#888888' } },   -- 内联提示状态
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
    end
  },
  { "doums/darcula" },                    -- Darcula 主题
  { "sainnhe/edge" },                     -- Edge 主题
  { "NLKNguyen/papercolor-theme", config = function()
      -- 尝试默认使用 PaperColor；如果失败则回退到 edge 或 habamax
      local ok = pcall(vim.cmd.colorscheme, "PaperColor")
      if not ok then
        local ok2 = pcall(vim.cmd.colorscheme, "edge")
        if not ok2 then
          pcall(vim.cmd.colorscheme, "habamax")
        end
      end

      -- 确保 LspInlayHint 有适当的高亮以避免错误装饰器
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- 设置微妙的内联提示样式
          vim.api.nvim_set_hl(0, "LspInlayHint", {
            fg = "#6c6c6c",
            bg = "NONE",
            italic = true,
          })

          -- 设置具有更好对比度的 FloatBorder
          vim.api.nvim_set_hl(0, "FloatBorder", {
            fg = "#666666",
            bg = "NONE",
          })
        end,
      })

      -- 立即应用于当前配色方案
      pcall(function()
        vim.api.nvim_set_hl(0, "LspInlayHint", {
          fg = "#6c6c6c",
          bg = "NONE",
          italic = true,
        })

        -- 设置具有更好对比度的 FloatBorder
        vim.api.nvim_set_hl(0, "FloatBorder", {
          fg = "#666666",
          bg = "NONE",
        })
      end)
    end
  },
}
