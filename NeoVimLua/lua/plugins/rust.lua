-- 专用 Rust 插件配置
-- 此文件包含所有 Rust 专用插件及其配置

return {
  -- 主要 Rust 开发环境
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = { 'rust' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      -- 增强的 rustaceanvim 配置及优化
      local function get_debug_adapter()
        if vim.fn.executable('codelldb') == 1 then
          return 'codelldb'
        elseif vim.fn.executable('lldb-vscode') == 1 then
          return 'lldb-vscode'
        elseif vim.fn.executable('lldb-dap') == 1 then
          return 'lldb-dap'
        else
          return 'lldb-dap' -- 回退选项
        end
      end

      vim.g.rustaceanvim = {
        -- 增强的工具配置
        tools = {
          -- 更好的悬停操作用户体验
          hover_actions = {
            border = {
              {"╭", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╮", "FloatBorder"},
              {"│", "FloatBorder"},
              {"╯", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╰", "FloatBorder"},
              {"│", "FloatBorder"},
            },
            auto_focus = false,
            max_width = 80,
            max_height = 20,
          },

          -- 增强的测试执行器
          test_executor = 'background', -- 使用后台执行以获得更好的用户体验
          test_status = {
            virtual_text = true,
            signs = true,
          },

          -- 增强的 Crate 图
          crate_graph = {
            backend = 'dot',
            output = 'svg',
            enabled_graphviz_backends = { 'dot', 'neato', 'fdp', 'sfdp', 'twopi' },
            graphviz_bin = nil, -- 使用系统默认
          },

          -- 增强的代码操作
          code_actions = {
            ui_select_fallback = true,
            group_icon = " ",
          },

          -- 增强的工作区符号搜索
          workspace_symbol = {
            search_kind = 'all_symbols',
            search_scope = 'workspace_and_dependencies',
          },
        },

        -- 增强的服务器配置
        server = {
          cmd = { 'rust-analyzer' },
          standalone = false,
          ra_multiplex = {
            enable = vim.fn.executable('ra-multiplex') == 1,
          },

          -- 增强的 on_attach，提供更多功能
          on_attach = function(client, bufnr)
            -- 通用 LSP 键位映射（最小集合以避免与 ftplugin 冲突）
            local opts = { buffer = bufnr, noremap = true, silent = true, desc = '' }

            -- 仅基本 LSP 映射（其他在 ftplugin/rust.lua 中）
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = '跳转到声明' }))
            vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = '跳转到实现' }))
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = '跳转到类型定义' }))

            -- 增强的悬停操作
            vim.keymap.set('n', 'K', function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end, vim.tbl_extend('force', opts, { desc = '悬停并显示操作' }))

            -- 增强的代码操作
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', function()
              vim.cmd.RustLsp('codeAction')
            end, vim.tbl_extend('force', opts, { desc = 'Rust 代码操作' }))

            -- 增强的重命名
            vim.keymap.set('n', '<leader>rn', function()
              return ':IncRename ' .. vim.fn.expand('<cword>')
            end, vim.tbl_extend('force', opts, { desc = '重命名', expr = true }))

            -- 保存时格式化（仅对 Rust）
            if client.supports_method('textDocument/formatting') then
              vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, {}),
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr })
                end,
              })
            end

            -- 增强的防抖内联提示
            if client.server_capabilities.inlayHintProvider then
              local inlay_enabled = false
              local debounce_timer = nil

              local function toggle_inlay_hints(enable)
                if enable ~= inlay_enabled then
                  vim.lsp.inlay_hint.enable(enable, { bufnr = bufnr })
                  inlay_enabled = enable
                end
              end

              -- 防抖启用内联提示
              local function debounced_enable_inlay_hints()
                if debounce_timer then
                  debounce_timer:stop()
                end
                debounce_timer = vim.defer_fn(function()
                  toggle_inlay_hints(true)
                end, 300)
              end

              -- 空闲时启用内联提示
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = bufnr,
                callback = debounced_enable_inlay_hints,
              })

              -- 输入时禁用内联提示
              vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved', 'TextChanged', 'TextChangedI' }, {
                buffer = bufnr,
                callback = function()
                  if debounce_timer then
                    debounce_timer:stop()
                  end
                  toggle_inlay_hints(false)
                end,
              })
            end
          end,

          -- 增强的 rust-analyzer 设置
          default_settings = {
            ['rust-analyzer'] = {
              -- Cargo 配置
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                targetDir = true,
              },

              -- 增强的检查配置
              check = {
                command = "clippy",
                extraArgs = { "--all", "--all-features", "--", "-D", "warnings", "-W", "clippy::all" },
                features = "all",
                onSave = "file", -- 更快的反馈
              },

              -- 增强的过程宏
              procMacro = {
                enable = true,
              },

              -- 增强的内联提示
              inlayHints = {
                enable = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
                parameterHints = {
                  enable = true,
                },
                chainingHints = {
                  enable = true,
                },
                maxLength = 25,
                lifetimeElisionHints = {
                  enable = "skip_trivial",
                  useParameterNames = true,
                },
                closureReturnTypeHints = {
                  enable = "always",
                },
                reborrowHints = {
                  enable = "mutable",
                },
                bindingModeHints = {
                  enable = true,
                },
              },

              -- 增强的补全
              completion = {
                addCallParentheses = true,
                addCallArgumentSnippets = true,
                postfix = {
                  enable = true,
                  private = {
                    enable = true,
                  },
                },
                autoimport = {
                  enable = true,
                },
                autoself = {
                  enable = true,
                },
              },

              -- 增强的诊断
              diagnostics = {
                enable = true,
                experimental = {
                  enable = false,
                },
                disabled = {
                  "unresolved-proc-macro", -- 经常是误报
                },
                enableRustcLint = true,
              },

              -- 增强的导入
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "crate",
                prefer = {
                  "std::option::Option",
                  "std::result::Result",
                  "std::vec::Vec",
                  "std::collections::HashMap",
                },
                merge = {
                  behave = "block",
                },
              },

              -- 增强的文件监视
              files = {
                watcher = "server",
                excludeDirs = {
                  "target",
                  ".git",
                  "node_modules",
                  ".vscode",
                  ".idea",
                },
              },

              -- 增强的透镜功能
              lens = {
                enable = true,
                run = {
                  enable = true,
                },
                debug = {
                  enable = true,
                },
                implementations = {
                  enable = true,
                },
                methodReferences = {
                  enable = true,
                },
                references = {
                  enable = true,
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                  traitImpl = { enable = true },
                },
              },

              -- 增强的悬停
              hover = {
                actions = {
                  enable = true,
                  implementations = {
                    enable = true,
                  },
                  references = {
                    enable = true,
                  },
                  run = {
                    enable = true,
                  },
                  debug = {
                    enable = true,
                  },
                  gotoTypeDef = {
                    enable = true,
                  },
                },
                memoryLayout = {
                  enable = true,
                  size = "both",
                  offset = "both",
                  alignment = "both",
                  niches = true,
                },
                documentation = {
                  enable = true,
                },
                linksInHover = true,
              },

              -- 性能优化
              semanticHighlighting = {
                strings = {
                  enable = true,
                },
                punctuation = {
                  enable = true,
                  special = {
                    enable = true,
                  },
                },
                syntax = {
                  enable = true,
                },
              },

              -- 增强的工作区符号配置
              workspace = {
                symbol = {
                  search = {
                    kind = "all_symbols",
                    scope = "workspace_and_dependencies",
                    limit = 128,
                  },
                },
              },
            },
          },
        },

        -- 增强的 DAP 配置
        dap = {
          autoload_configurations = true,
          adapter = require('dap').adapters.codelldb or {
            type = 'executable',
            command = get_debug_adapter(),
            name = 'rt_lldb',
          },
        },
      }
    end,
  },

  -- 增强的 Cargo.toml 管理
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('crates').setup({
        smart_insert = true,
        insert_closing_quote = true,
        avoid_prerelease = true,
        autoload = true,
        autoupdate = true,
        loading_indicator = true,
        date_format = "%Y-%m-%d",
        thousands_separator = ",",
        notification_title = "Crates",
        text = {
          loading = "  加载中...",
          version = "  %s",
          prerelease = "  %s (预发布)",
          yanked = "  %s (已撤销)",
          nomatch = "  无匹配",
          upgrade = "  %s → %s",
          error = "  获取 Crate 错误",
        },
        highlight = {
          loading = "CratesNvimLoading",
          version = "CratesNvimVersion",
          prerelease = "CratesNvimPreRelease",
          yanked = "CratesNvimYanked",
          nomatch = "CratesNvimNoMatch",
          upgrade = "CratesNvimUpgrade",
          error = "CratesNvimError",
        },
        popup = {
          autofocus = true,
          copy_version = false,
          hide_releases = false,
          hide_prereleases = false,
          hide_yanked = false,
        },
        src = {
          cmp = {
            enabled = true,
            use_custom_kind = true,
            kind_text = {
              version = "版本",
              feature = "特性",
            },
            kind_highlight = {
              version = "CmpItemKindVersion",
              feature = "CmpItemKindFeature",
            },
          },
        },
      })

      -- Cargo 操作的增强键位映射
      vim.keymap.set('n', '<leader>ct', function()
        require('crates').toggle()
      end, { desc = '切换 Crate 版本', buffer = true })

      vim.keymap.set('n', '<leader>cu', function()
        require('crates').upgrade_crate()
      end, { desc = '升级 Crate', buffer = true })

      vim.keymap.set('n', '<leader>cU', function()
        require('crates').upgrade_all_crates()
      end, { desc = '升级所有 Crate', buffer = true })

      vim.keymap.set('n', '<leader>ca', function()
        require('crates').update_crate()
      end, { desc = '更新 Crate', buffer = true })

      vim.keymap.set('n', '<leader>cA', function()
        require('crates').update_all_crates()
      end, { desc = '更新所有 Crate', buffer = true })

      vim.keymap.set('n', '<leader>ch', function()
        require('crates').show_homepage()
      end, { desc = '显示 Crate 主页', buffer = true })

      vim.keymap.set('n', '<leader>cd', function()
        require('crates').show_documentation()
      end, { desc = '显示 Crate 文档', buffer = true })

      vim.keymap.set('n', '<leader>cr', function()
        require('crates').reload()
      end, { desc = '重新加载 Crate', buffer = true })

      vim.keymap.set('n', '<leader>cc', function()
        require('crates').open_category()
      end, { desc = '打开 Crate 类别', buffer = true })
    end,
  },

  -- 增强的 Rust 测试集成
  {
    'nvim-neotest/neotest',
    ft = { 'rust' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('rustaceanvim.neotest'),
        },
        discovery = {
          enabled = true,
        },
        running = {
          concurrent = true,
        },
        status = {
          enabled = true,
          virtual_text = true,
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        summary = {
          enabled = true,
          follow = true,
          expand_errors = true,
        },
        strategies = {
          integrated = {
            width = 100,
            height = 30,
          },
        },
      })

      -- 增强的测试键位映射
      vim.keymap.set('n', '<leader>tt', function()
        require('neotest').run.run()
      end, { desc = '运行最近测试' })

      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand('%'))
      end, { desc = '运行文件测试' })

      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').run.run({ suite = true })
      end, { desc = '运行测试套件' })

      vim.keymap.set('n', '<leader>tl', function()
        require('neotest').run.run_last()
      end, { desc = '运行上次测试' })

      vim.keymap.set('n', '<leader>td', function()
        require('neotest').run.run({ strategy = 'dap' })
      end, { desc = '调试测试' })

      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open({ enter = true })
      end, { desc = '显示测试输出' })

      vim.keymap.set('n', '<leader>tO', function()
        require('neotest').output_panel.toggle()
      end, { desc = '切换测试输出面板' })

      vim.keymap.set('n', '<leader>tS', function()
        require('neotest').summary.toggle()
      end, { desc = '切换测试摘要' })
    end,
  },
}