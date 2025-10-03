return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,  -- 立即加载语法高亮
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
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = false },  -- 立即加载文本对象
}
