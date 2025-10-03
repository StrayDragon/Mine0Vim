return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,  -- 立即加载语法高亮引擎
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },  -- 启用语法高亮
      indent = { enable = true },     -- 启用智能缩进
      ensure_installed = { "python", "lua", "rust", "go", "vim", "vimdoc", "markdown", "markdown_inline" },
      incremental_selection = {
        enable = true,  -- 启用增量选择
        keymaps = {
          init_selection = "<C-s>",    -- 开始选择
          node_incremental = "<C-s>",  -- 扩展选择到父节点
          node_decremental = "[[",     -- 缩小选择到子节点
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = false },  -- 立即加载文本对象插件
}
