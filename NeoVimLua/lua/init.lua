-- 全局入口

-- 设置基础选项
require('core.options')

-- 加载自动命令
require('core.autocmds')

-- 设置按键映射
require('core.keymaps')

-- 设置配色方案
require('core.colorscheme')

-- 加载插件系统
require('plugins')

-- 加载LSP配置
require('lsp')

-- 检查Neovim版本
local neovim_version = vim.fn.has('nvim-0.8')
if neovim_version == 0 then
  vim.notify('需要 Neovim >= 0.8', vim.log.levels.ERROR)
  return
end

-- 设置全局变量
_G.NeoVimLua = {
  -- 全局配置
  config = {
    -- 可以在这里添加全局配置选项
  },

  -- 全局函数
  utils = {
    -- 可以在这里添加全局工具函数
  }
}

-- 加载用户自定义配置（如果存在）
local user_config = vim.fn.stdpath('config') .. '/lua/user_config.lua'
if vim.fn.filereadable(user_config) == 1 then
  require('user_config')
end
