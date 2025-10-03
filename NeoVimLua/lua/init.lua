require("config.lazy")
require("config.options")
require("config.keymaps")

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "edge", "habamax" } },
  checker = { enabled = true },
})

