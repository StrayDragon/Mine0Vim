-- NeoVimLua Mason.nvim配置
-- 用于自动安装LSP服务器

local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  vim.notify("mason.nvim not found!")
  return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  vim.notify("mason-lspconfig.nvim not found!")
  return
end

-- Mason 基础设置
mason.setup({
  ui = {
    -- mason窗口边框类型
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  -- 不自动安装包
  max_concurrent_installers = 4,
})

-- 自动安装 LSP 服务器
mason_lspconfig.setup({
  ensure_installed = {
    "gopls",         -- Go
    "basedpyright",  -- Python (基于 pyright 的更快实现)
  },
  automatic_installation = true,
})

-- 为某些服务器设置特殊安装后钩子
local registry = require("mason-registry")
registry:on("package:install:success", function(pkg)
  local pkg_name = pkg.name

  -- 如果安装了emmet-ls，可能需要额外的配置
  if pkg_name == "emmet-ls" then
    vim.notify("Installed " .. pkg_name .. ", setting up additional configurations...")
    -- 这里可以放置额外的设置
  end

  -- 如果安装了就告知用户
  vim.notify("Installed " .. pkg_name .. " successfully!")
end)

-- 配置 LSP 服务器
local lspconfig = require("lspconfig")
local handlers = require("lsp.handlers")

-- 获取 capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 加载各个 LSP 服务器的配置
local servers = {
  "gopls",
  "basedpyright",
}

for _, server in ipairs(servers) do
  local server_config = require("lsp.servers." .. server)
  server_config.setup(handlers.on_attach, capabilities)
end