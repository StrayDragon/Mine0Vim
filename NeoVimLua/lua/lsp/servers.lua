-- NeoVimLua LSP服务器配置

local M = {}

-- 设置服务器配置
function M.setup(on_attach, capabilities)
  -- 导入lspconfig
  local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_status_ok then
    vim.notify("lspconfig not found!")
    return
  end

  -- 导入mason-lspconfig
  local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_lspconfig_status_ok then
    vim.notify("mason-lspconfig not found!")
    return
  end

  -- 服务器配置表
  local servers = {
    -- Lua
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    },
    -- Python
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    -- JSON
    jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    },
    -- TypeScript/JavaScript
    tsserver = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    },
    -- 其他服务器使用默认配置
    clangd = {},
    bashls = {},
    html = {},
    cssls = {},
    vimls = {},
  }

  -- 设置lsp服务器
  mason_lspconfig.setup_handlers({
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = servers[server_name] and servers[server_name].settings or {},
      })
    end,

    -- 特殊处理某些服务器
    ["lua_ls"] = function()
      -- 加载neodev (如果安装了)
      pcall(function()
        require("neodev").setup({
          library = { plugins = { "nvim-dap-ui" }, types = true },
        })
      end)

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = servers.lua_ls.settings,
      })
    end,
  })
end

return M