local M = {}

function M.setup(on_attach, capabilities)
  require("lspconfig").basedpyright.setup({
    on_attach = function(client, bufnr)
      -- 启用内联提示
      if vim.fn.has("nvim-0.10") == 1 then
        vim.lsp.inlay_hint.enable(bufnr, true)
      end

      -- 调用通用 on_attach
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      basedpyright = {  -- 注意这里改为 basedpyright
        -- 分析设置
        analysis = {
          -- 类型检查设置
          typeCheckingMode = "basic",  -- 可选: "off", "basic", "strict"
          autoImportCompletions = true,
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",

          -- 诊断设置
          diagnosticSeverityOverrides = {
            -- 常见问题的严重程度调整
            reportGeneralTypeIssues = "warning",
            reportOptionalMemberAccess = "warning",
            reportOptionalSubscript = "warning",
            reportPrivateImportUsage = "warning",
            reportUnknownMemberType = "information",
            reportUnknownParameterType = "information",
            reportUnknownVariableType = "information",
            reportUntypedFunctionDecorator = "information",
            reportUnusedImport = "information",
            reportDuplicateImport = "warning",
          },

          -- 性能优化设置
          indexing = true,
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = true,

          -- 代码提示设置
          inlayHints = {
            variableTypes = true,
            functionReturnTypes = true,
            parameterTypes = true,
            pytestParameters = true,  -- pytest 参数提示
          },
        },
      },
    },
    before_init = function(_, config)
      -- 自动检测虚拟环境
      local util = require("lspconfig.util")

      -- 按优先级尝试不同的虚拟环境路径
      local python_path = util.path.join(config.root_dir, '.venv', 'bin', 'python')
      if not util.path.exists(python_path) then
        python_path = util.path.join(config.root_dir, 'venv', 'bin', 'python')
      end
      if not util.path.exists(python_path) then
        python_path = util.find_python_venv_path(config.root_dir)
      end

      -- 如果找到虚拟环境，使用它
      if python_path then
        config.settings.basedpyright = config.settings.basedpyright or {}
        config.settings.basedpyright.pythonPath = python_path
      end

      -- 自动检测 pyrightconfig.json
      local pyrightconfig = util.path.join(config.root_dir, "pyrightconfig.json")
      if util.path.exists(pyrightconfig) then
        config.settings.basedpyright.configurationSources = { "pyrightconfig" }
      end
    end,
    root_dir = require("lspconfig.util").root_pattern(
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
      ".git"
    ),
  })
end

return M