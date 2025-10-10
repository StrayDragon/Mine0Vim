-- 核心插件配置
-- 包含基础设置、treesitter、which-key 等核心功能

return {
  -- Treesitter 语法高亮引擎
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = { "python", "lua", "rust", "go", "vim", "vimdoc", "markdown", "markdown_inline" },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-s>",
          node_incremental = "<C-s>",
          node_decremental = "[[",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = false },

  -- Which-Key 键位提示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,
      filter = function(mapping)
        if mapping.desc == "which-key-trigger" then
          return false
        end
        return mapping.desc and mapping.desc ~= ""
      end,
      triggers = {
        { "<auto>", mode = "nxso" },
      },
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        no_overlap = true,
        padding = { 1, 2 },
        title = true,
        title_pos = "center",
        zindex = 1000,
        wo = {
          winblend = 10,
        },
      },
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      sort = { "local", "order", "group", "alphanum", "mod" },
      icons = {
        mappings = true,
        colors = true,
        keys = {
          Up = " ",
          Down = " ",
          Left = " ",
          Right = " ",
          C = "󰘴 ",
          M = "󰘵 ",
          D = "󰘳 ",
          S = "󰘶 ",
          CR = "󰌑 ",
          Esc = "󱊷 ",
          Space = "󱁐 ",
          Tab = "󰌒 ",
        },
      },
      show_help = true,
      show_keys = true,
      notify = true,
      disable = {
        ft = { "TelescopePrompt", "NvimTree", "neo-tree", "fzf", "FzfLua" },
        bt = { "prompt", "nofile" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        { "<leader>h", group = "Git Signs", icon = "🚩 " },
        { "<leader>hs", desc = "暂存 Hunk" },
        { "<leader>hr", desc = "重置 Hunk" },
        { "<leader>hp", desc = "预览 Hunk" },
        { "<leader>hb", desc = " blame 行" },
        { "<leader>hd", desc = "diff this" },
        { "g", group = "LSP 导航", icon = "🔗 " },
        { "<space>", group = "CocList 替代", icon = "📋 " },
        { "<space>d", desc = "诊断列表" },
        { "<space>o", desc = "文档大纲" },
        { "<space>s", desc = "工作区符号" },
        { "<space>c", desc = "命令面板" },
        { "<space>q", desc = "快速修复列表" },
        { "<space>e", desc = "LSP 查找器" },
        { "<leader>f", group = "文件", icon = "📄 " },
        { "<leader>s", group = "搜索", icon = "🔍 " },
        { "<leader>d", group = "诊断", icon = "🔍 " },
        { "<leader>de", desc = "显示诊断浮动窗口" },
        { "<leader>t", group = "工具", icon = "🛠️ " },
        { "<leader>x", group = "语言工具", icon = "🔧 " },
        { "<leader>xr", group = "Rust", icon = "🦀 " },
        { "<leader>xrc", group = "Cargo 管理", icon = "📦 " },
        { "<leader>xp", group = "Python", icon = "🐍 " },
        { "<leader>xl", group = "Lua", icon = "🌙 " },
        { "<leader>xa", group = "通用", icon = "🔧 " },
        { "<leader>t", group = "测试", icon = "🧪 " },
        { "<leader>i", group = "AI/Claude", icon = "🤖 " },
        { "<leader>S", group = "窗口管理", icon = "🪟 " },
        { "<leader>T", group = "标签页", icon = "📑 " },
        { "<leader>u", group = "UI 控制", icon = "🎨 " },
        { "<leader>a", desc = "智能代码动作" },
        { "<leader>ca", desc = "代码动作" },
        { "<leader>rn", desc = "重命名符号" },
        { "<leader>f", desc = "格式化并保存" },
        { "g[", desc = "上一个诊断" },
        { "g]", desc = "下一个诊断" },
        { "<leader>D", group = "调试", icon = "🐛 " },
        { "<leader>Db", desc = "切换断点" },
        { "<leader>DB", desc = "条件断点" },
        { "<leader>Dc", desc = "继续/开始调试" },
        { "<leader>Do", desc = "跳过" },
        { "<leader>Di", desc = "步入" },
        { "<leader>DO", desc = "步出" },
        { "<leader>Dq", desc = "终止调试" },
        { "<leader>Du", desc = "切换调试 UI" },
        { "<leader>De", desc = "求值表达式" },
        { "<leader>Ds", desc = "显示调试状态" },
        { "<leader>ff", desc = "查找文件" },
        { "<leader>fb", desc = "缓冲区列表" },
        { "<leader>fg", desc = "全局搜索" },
        { "<leader>gs", desc = "暂存变更" },
        { "<leader>gr", desc = "重置变更" },
        { "<leader>gp", desc = "预览变更" },
        { "<leader>xra", desc = "Rust 代码动作" },
        { "<leader>xrc", desc = "Cargo 管理" },
        { "<leader>xpa", desc = "Python 代码动作" },
        { "<leader>xla", desc = "Lua 代码动作" },
        { "<leader>xar", desc = "重构菜单" },
        { "<leader>ii", desc = "切换 Claude" },
        { "<leader>is", desc = "发送到 Claude" },
        { "gy", desc = "跳转到类型定义" },
        { "<leader>y", desc = "替换当前单词" },
        { "gq", desc = "快速修复" },
        { "gd", desc = "跳转到定义" },
        { "gr", desc = "查找引用" },
        { "gi", desc = "跳转到实现" },
        { "gD", desc = "跳转到声明" },
        { "gI", desc = "跳转到实现" },
        { "gK", desc = "Rust 增强悬停" },
        { "<leader>ui", desc = "切换内联提示" },
        { "<leader>ud", desc = "切换暗淡模式" },
        { "<leader>z", desc = "Zen 模式" },
        { "<leader>nf", desc = "在文件树中查找当前文件" },
      })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({
            global = false,
            filter = function(mapping)
              return mapping.desc and mapping.desc ~= "" and mapping.desc ~= "which-key-trigger"
            end
          })
        end,
        desc = "本地缓冲区键位"
      },
    },
  },
}