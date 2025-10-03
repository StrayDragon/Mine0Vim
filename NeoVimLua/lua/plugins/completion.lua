return {
  {
    "saghen/blink.cmp",
    lazy = false,  -- 立即加载补全引擎
    version = "v0.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "rustaceanvim", -- Rust 语言补全支持
    },
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active({ direction = 1 }) then
              return cmp.snippet_forward()   -- 代码片段向前跳转
            elseif cmp.is_visible() then
              return cmp.accept()            -- 接受补全项
            else
              -- 模拟 coc 的 super-tab 行为：光标前有单词时触发补全
              local col = vim.api.nvim_win_get_cursor(0)[2]
              if col > 0 then
                local line = vim.api.nvim_get_current_line()
                local prev = line:sub(col, col)
                if prev:match("%s") == nil then
                  return cmp.show()          -- 显示补全菜单
                end
              end
              return cmp.fallback()          -- 回退到默认行为
            end
          end
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active({ direction = -1 }) then
              return cmp.snippet_backward()  -- 代码片段向后跳转
            elseif cmp.is_visible() then
              return cmp.select_prev()       -- 选择上一项
            else
              return cmp.fallback()          -- 回退到默认行为
            end
          end
        },
        ["<C-Space>"] = { "show" },                    -- 显示补全
        ["<C-e>"] = { "hide" },                        -- 隐藏补全
        ["<CR>"] = { "accept", "fallback" },           -- 确认选择
        ["<Up>"] = { "select_prev", "fallback" },      -- 向上选择
        ["<Down>"] = { "select_next", "fallback" },    -- 向下选择
        ["<C-p>"] = { "select_prev", "fallback" },     -- Ctrl+P 向上选择
        ["<C-n>"] = { "select_next", "fallback" },     -- Ctrl+N 向下选择
        ["<C-d>"] = { "scroll_documentation_down", "fallback" }, -- 向下滚动文档
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },   -- 向上滚动文档
      },
      completion = {
        menu = {
          border = "rounded",
          auto_show = false,  -- 禁用自动显示以匹配 coc.nvim 触发行为
        },
        documentation = {
          window = { border = "rounded" },
          auto_show = false,  -- 不自动显示以减少重复
        },
        -- 移除无效的 list.selection 配置以避免类型错误；使用默认值
      },
      signature = { enabled = true },  -- 启用签名帮助
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },  -- 默认补全源
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            -- 根据 insertText 去重补全项
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
      },
    },
  },
}