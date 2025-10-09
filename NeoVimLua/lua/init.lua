require("config.lazy")
require("config.options")
require("config.keymaps")

-- 初始化智能键位通知系统
require("config.smart-keys-notify").initialize()

-- 初始化智能键位系统
require("config.smart-keys").initialize()
require("config.smart-keys-languages").initialize()
require("config.smart-keys-conflict").initialize()
require("config.smart-keys-multi").initialize()
require("config.smart-keys-framework").initialize()

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "edge", "habamax" } },
  checker = { enabled = true },
})

