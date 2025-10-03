return {
  -- Mason 和 LSP 配置 - 立即加载
  {
    "williamboman/mason.nvim",
    lazy = false,  -- 立即加载 LSP 工具管理器
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,  -- 立即加载 LSP 配置桥接
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      -- 仅确保安装，不进行自动设置或启用
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "basedpyright" },
        automatic_installation = false,
        -- 禁用 LSP 服务器自动启用（Neovim 0.11+）
        automatic_enable = false,
        -- 通过提供空的处理器明确防止任何自动设置
        handlers = {},
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,  -- 立即加载 LSP 核心配置
    dependencies = { "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- 统一所有客户端的位置编码以避免混合 UTF-8/UTF-16 警告
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-8" }

      -- 在附加时设置键位映射
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- 保留 Coc.nvim 键位映射以实现无缝迁移
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)          -- 跳转到定义
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)     -- 跳转到类型定义
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)      -- 跳转到实现
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)          -- 查找引用

        -- 悬停文档
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- 诊断导航
        vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, opts)        -- 上一个诊断
        vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, opts)        -- 下一个诊断

        -- 操作
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)       -- 重命名符号
        vim.keymap.set({'n', 'x'}, '<leader>a', vim.lsp.buf.code_action, opts) -- 代码动作
        vim.keymap.set({'n', 'x'}, '<leader>f', function()               -- 格式化代码
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- 在浮动窗口中显示诊断
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

        -- 修复 Neovim 0.11.4+ 中代码动作范围的窗口参数问题
        -- 覆盖 make_range_params 以确保有效的窗口参数
        local orig_make_range_params = vim.lsp.util.make_range_params
        vim.lsp.util.make_range_params = function(opts)
          opts = opts or {}
          -- 使用当前窗口避免"Expected Lua number"错误
          opts.window = vim.api.nvim_get_current_win()
          -- 设置位置编码以避免混合编码警告
          opts.position_encoding = opts.position_encoding or "utf-8"
          return orig_make_range_params(opts)
        end

        -- 为 Neovim 0.11+ 安全启用内联提示，具有强大的错误处理
        if client.server_capabilities.inlayHintProvider then
          vim.schedule(function()
            local ok, err = pcall(function()
              if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                -- 添加自动命令在文本更改期间禁用内联提示以防止列越界
                local group = vim.api.nvim_create_augroup("InlayHintProtection_" .. bufnr, { clear = true })
                vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufDelete", "BufWipeout" }, {
                  group = group,
                  buffer = bufnr,
                  callback = function()
                    pcall(function()
                      if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                        -- 短暂延迟后重新启用
                        vim.defer_fn(function()
                          if vim.api.nvim_buf_is_valid(bufnr) then
                            pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
                          end
                        end, 100)
                      end
                    end)
                  end,
                })
              end
            end)
            if not ok then
              vim.notify("启用内联提示失败: " .. tostring(err), vim.log.levels.WARN)
            end
          end)
        end
      end

      -- 使用新的 vim.lsp.config API（Neovim 0.11+）
      local lsp_configs = {
        -- Python LSP（主要需求）
        basedpyright = {
          cmd = { "basedpyright-langserver", "--stdio" },
          filetypes = { "python" },
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                -- 为类型注解启用内联提示
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  callArgumentNames = "partial",
                },
              },
            },
          },
        },

        -- Lua LSP
        lua_ls = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

      }

      -- 使用新 API 注册 LSP 配置
      for server_name, config in pairs(lsp_configs) do
        vim.lsp.config(server_name, config)
      end

      -- 为适当的文件类型自动启动 LSP 服务器
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local filetype = args.file
          local lsp_map = {
            python = "basedpyright",
            lua = "lua_ls",
          }

          local server = lsp_map[filetype]
          if server then
            vim.lsp.enable(server)
          end
        end,
      })

      -- 注意：LSP 悬停和签名帮助边框现在由 config/options.lua 中的 vim.o.winborder = "rounded" 控制
      -- 这在 Neovim 0.11+ 中全局应用于所有浮动窗口

      -- 诊断配置
      vim.diagnostic.config({
        virtual_text = true,  -- 显示虚拟文本诊断
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",  -- 错误符号
            [vim.diagnostic.severity.WARN]  = " ",  -- 警告符号
            [vim.diagnostic.severity.HINT]  = " ",  -- 提示符号
            [vim.diagnostic.severity.INFO]  = " ",  -- 信息符号
          },
        },
        underline = true,        -- 下划线标记
        update_in_insert = false, -- 插入模式时不更新
        severity_sort = true,     -- 按严重程度排序
        float = {
          border = {
            {"┌", "FloatBorder"},
            {"─", "FloatBorder"},
            {"┐", "FloatBorder"},
            {"│", "FloatBorder"},
            {"┘", "FloatBorder"},
            {"─", "FloatBorder"},
            {"┚", "FloatBorder"},
            {"│", "FloatBorder"},
          },
          source = "always",  -- 始终显示来源
          header = "",        -- 无标题
          prefix = "",        -- 无前缀
        },
      })
    end,
  },
}
