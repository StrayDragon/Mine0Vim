return {
  {
    "saghen/blink.cmp",
    version = "v0.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active({ direction = 1 }) then
              return cmp.snippet_forward()
            elseif cmp.is_visible() then
              return cmp.accept()
            else
              -- mimic coc super-tab: trigger completion when there's a word before cursor
              local col = vim.api.nvim_win_get_cursor(0)[2]
              if col > 0 then
                local line = vim.api.nvim_get_current_line()
                local prev = line:sub(col, col)
                if prev:match("%s") == nil then
                  return cmp.show()
                end
              end
              return cmp.fallback()
            end
          end
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active({ direction = -1 }) then
              return cmp.snippet_backward()
            elseif cmp.is_visible() then
              return cmp.select_prev()
            else
              return cmp.fallback()
            end
          end
        },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },
      completion = {
        menu = {
          border = "rounded",
          auto_show = false,  -- Disable auto-show to match coc.nvim trigger behavior
        },
        documentation = {
          window = { border = "rounded" },
          auto_show = false,  -- Don't auto-show to reduce duplicates
        },
        -- Removed invalid list.selection to avoid type error; using defaults
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            -- Deduplicate completion items by insertText
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