-- Mine0Vim NeoVimLua Configuration
-- 作者: straydragon

-- 核心配置加载
require("core.options")       -- Vim 基本设置
require("core.keymaps")       -- 按键映射
require("core.autocmds")      -- 自动命令
require("plugins")            -- 插件管理和配置
require("lsp")                -- LSP配置

-- 最后加载颜色主题
require("core.colorscheme")   -- 颜色主题