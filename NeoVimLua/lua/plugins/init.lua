-- 使用 lazy.nvim 替代 vim-plug

-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- 最新稳定版
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 配置 lazy.nvim
require("lazy").setup({
  -- 分组: UI增强
  {
    "folke/tokyonight.nvim", -- 现代配色方案
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
        day_brightness = 0.3,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim", -- 状态栏
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.lualine")
    end,
  },

  {
    "akinsho/bufferline.nvim", -- 更好的标签页
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.bufferline")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim", -- 缩进线
    main = "ibl",
    opts = {},
    config = function()
      require("plugins.configs.indent-blankline")
    end,
  },

  {
    "goolord/alpha-nvim", -- 起始页
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.alpha")
    end,
  },

  {
    "nvim-tree/nvim-web-devicons", -- 图标支持
    lazy = true,
  },

  {
    "norcalli/nvim-colorizer.lua", -- 颜色代码可视化
    config = function()
      require("colorizer").setup()
    end,
  },

  -- 分组: 编辑器功能增强
  {
    "nvim-tree/nvim-tree.lua", -- 文件树
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.nvim-tree")
    end,
  },

  {
    "nvim-telescope/telescope.nvim", -- 模糊查找
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      require("plugins.configs.telescope")
    end,
  },

  {
    "stevearc/aerial.nvim", -- 代码结构导航
    config = function()
      require("plugins.configs.aerial")
    end,
  },

  {
    "folke/which-key.nvim", -- 按键提示
    config = function()
      require("plugins.configs.which-key")
    end,
  },

  {
    "numToStr/Comment.nvim", -- 注释插件
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "windwp/nvim-autopairs", -- 自动括号配对
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  {
    "kylechui/nvim-surround", -- 环绕编辑
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  {
    "akinsho/toggleterm.nvim", -- 终端集成
    version = "*",
    config = function()
      require("plugins.configs.toggleterm")
    end,
  },

  -- 分组: 开发工具
  {
    "nvim-treesitter/nvim-treesitter", -- 语法高亮
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- 更好的文本对象
    },
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  {
    "lewis6991/gitsigns.nvim", -- Git集成
    config = function()
      require("plugins.configs.gitsigns")
    end,
  },

  {
    "CRAG666/code_runner.nvim", -- 代码运行
    config = function()
      require("plugins.configs.code-runner")
    end,
  },

  -- 分组: LSP和自动补全
  {
    "neovim/nvim-lspconfig", -- LSP配置
    dependencies = {
      "williamboman/mason.nvim", -- LSP管理器
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim", -- Lua开发工具
      "nvimdev/lspsaga.nvim", -- LSP UI增强
      "jose-elias-alvarez/null-ls.nvim", -- 格式化和诊断
    },
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "hrsh7th/nvim-cmp", -- 自动补全
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP补全源
      "hrsh7th/cmp-buffer", -- Buffer补全源
      "hrsh7th/cmp-path", -- 路径补全源
      "hrsh7th/cmp-cmdline", -- 命令行补全源
      "saadparwaiz1/cmp_luasnip", -- Snippets补全源
      "L3MON4D3/LuaSnip", -- 代码片段
      "rafamadriz/friendly-snippets", -- 预定义代码片段
      "onsails/lspkind.nvim", -- VSCode风格图标
    },
  },

  -- 分组: 其他实用工具
  {
    "folke/todo-comments.nvim", -- TODO注释高亮
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },

  {
    "folke/trouble.nvim", -- 更好的诊断显示
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.trouble")
    end,
  },

  {
    "RRethy/vim-illuminate", -- 相同文本高亮
    config = function()
      require("illuminate").configure({
        delay = 200,
        under_cursor = true,
      })
    end,
  },

  {
    "iamcco/markdown-preview.nvim", -- Markdown预览
    build = "cd app && yarn install",
    cmd = { "MarkdownPreview" },
    ft = { "markdown" },
  },

  {
    "kkoomen/vim-doge", -- 文档生成
    build = ":call doge#install()",
    config = function()
      require("plugins.configs.doge")
    end,
  },

}, {
  -- lazy.nvim 选项
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🔑",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  install = {
    colorscheme = { "tokyonight" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- 加载插件配置
require("plugins.configs")