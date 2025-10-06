return {
  {
    "saghen/blink.cmp",
    lazy = false,  -- 立即加载补全引擎
    version = "v0.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "echasnovski/mini.snippets",  -- 现代化 snippet 引擎
      "rustaceanvim",  -- Rust 语言补全支持
    },
    opts = {
      -- 启用/禁用配置
      enabled = function()
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
      end,

      -- 高性能键位映射配置
      keymap = {
        preset = "default",  -- 使用现代默认预设
        ["<Tab>"] = {
          "select_and_accept",
          "snippet_forward",
          "fallback"
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation" },
        ["<C-e>"] = { "hide", "cancel" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-k>"] = { "show_signature" },
        ["<C-j>"] = { "hide_signature" },
      },

      -- 智能补全触发配置
      completion = {
        trigger = {
          -- 减少不必要的触发以提升性能
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },

        -- 补全菜单配置
        menu = {
          enabled = true,
          min_width = 15,
          max_height = 10,
          border = "rounded",
          winblend = 0,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          scrolloff = 2,
          scrollbar = true,
          direction_priority = { "s", "n" },
          auto_show = true,  -- 改为自动显示以提升体验
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },

        -- 文档预览配置
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 80,
            max_height = 20,
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            scrollbar = true,
            direction_priority = {
              menu_north = { "e", "w", "n", "s" },
              menu_south = { "e", "w", "s", "n" },
            },
          },
        },

        -- 幽灵文本预览
        ghost_text = {
          enabled = true,
        },

        -- 列表选择配置
        list = {
          max_items = 200,
          selection = {
            preselect = true,  -- 自动预选第一项
            auto_insert = true,  -- 自动插入选中项
          },
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },

        -- 关键词匹配范围
        keyword = {
          range = "full",  -- 在光标前后都进行匹配
        },

        -- 接受配置
        accept = {
          auto_brackets = {
            enabled = false,  -- 禁用自动括号以避免与 mini.pairs 冲突
          },
        },
      },

      -- 签名帮助配置
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
        },
      },

      -- 高性能源配置
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },

        providers = {
          -- LSP 源配置（性能优化）
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            min_keyword_length = 1,
            async = true,
            score_offset = -2,
            override = {
              -- 自定义去重逻辑
              transform_items = function(_, items)
                local seen = {}
                local unique_items = {}
                for _, item in ipairs(items) do
                  local key = item.insertText or item.label
                  if not seen[key] then
                    seen[key] = true
                    table.insert(unique_items, item)
                  end
                end
                return unique_items
              end,
            },
          },

          -- 路径补全配置
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            min_keyword_length = 1,
            score_offset = -3,
            opts = {
              get_cwd = function()
                return vim.fn.getcwd()
              end,
              show_hidden_files_by_default = false,
            },
          },

          -- Snippet 配置
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            min_keyword_length = 2,
            score_offset = -1,
          },

          -- 缓冲区补全配置（性能优化）
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = -3,
            opts = {
              -- 获取可见缓冲区
              get_bufnrs = function()
                return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                  :filter(function(buf) return vim.bo[buf].buftype ~= "nofile" end)
                  :totable()
              end,
              -- 搜索时的缓冲区
              get_search_bufnrs = function() return { vim.api.nvim_get_current_buf() } end,
              -- 性能优化：限制缓冲区大小
              max_sync_buffer_size = 10000,
              max_async_buffer_size = 100000,
            },
          },

          -- 命令行补全
          cmdline = {
            module = "blink.cmp.sources.cmdline",
          },
        },
      },

      -- Snippet 配置
      snippets = {
        preset = "mini_snippets",  -- 使用 mini.snippets
      },

      -- 命令行模式配置
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = { "buffer", "cmdline" },
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
          },
          list = {
            selection = {
              preselect = true,
              auto_insert = true,
            },
          },
          menu = { auto_show = false },
          ghost_text = { enabled = true },
        },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- 性能优化配置
      vim.schedule(function()
        -- 设置全局补全选项
        vim.opt.completeopt = "menu,menuone,noinsert,noselect"

        -- 添加补全用户命令
        vim.api.nvim_create_user_command("BlinkInfo", function()
          print("Blink.cmp is active and configured")
        end, { desc = "Show blink.cmp information" })

        -- 添加性能监控
        local blink_stats = {
          completion_count = 0,
          completion_times = {},
        }

        local original_show = require("blink.cmp").show
        require("blink.cmp").show = function(...)
          local start_time = vim.loop.hrtime()
          blink_stats.completion_count = blink_stats.completion_count + 1

          local result = original_show(...)

          local end_time = vim.loop.hrtime()
          local duration = (end_time - start_time) / 1e6
          table.insert(blink_stats.completion_times, duration)

          -- 保持最近 100 次记录
          if #blink_stats.completion_times > 100 then
            table.remove(blink_stats.completion_times, 1)
          end

          return result
        end

        -- 添加性能统计命令
        vim.api.nvim_create_user_command("BlinkStats", function()
          if #blink_stats.completion_times > 0 then
            local total = 0
            for _, time in ipairs(blink_stats.completion_times) do
              total = total + time
            end
            local avg = total / #blink_stats.completion_times
            print(string.format(
              "Blink.cmp Stats:\n  Total completions: %d\n  Average time: %.2f ms\n  Recent samples: %d",
              blink_stats.completion_count,
              avg,
              #blink_stats.completion_times
            ))
          else
            print("No completion statistics available yet")
          end
        end, { desc = "Show blink.cmp performance statistics" })
      end)
    end,
  },
}