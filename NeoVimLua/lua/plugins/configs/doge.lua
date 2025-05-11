-- NeoVimLua vim-doge 文档生成配置
local M = {}

function M.setup()
  -- 确保插件已加载
  local status_ok, _ = pcall(require, "doge")
  if not status_ok then
    return
  end

  -- 基础配置
  vim.g.doge_enable_mappings = 1
  vim.g.doge_mapping = '<Leader>d'
  vim.g.doge_doc_standard_python = 'reST_custom'

  -- 设置Python的自定义文档标准
  local python_config = {
    patterns = {
      reST_custom = {
        {
          match = [=[^def\s+([^(]+)\s*\((.*?)\)(?:\s*->\s*(.*?))?\s*:]=],
          tokens = {'parameters', 'returnType'},
          parameters = {
            match = [=[([[:alnum:]_]+)(?:\s*:\s*([[:alnum:]_.]+(?:\[[[:alnum:]_[\],\s]*\])?))?(?:\s*=\s*([^,]+))?]=],
            tokens = {'name', 'type', 'default'},
            format = ':param {name} {type|!type}: !description',
          },
          insert = 'below',
          template = {
            '"""',
            '!description',
            '',
            '%(parameters|{parameters})%',
            '%(returnType|:rtype {returnType}: !description)%',
            '"""',
          },
        },
      },
    },
  }

  -- 创建自动命令组来设置Python配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      -- 设置缓冲区变量
      vim.b[buf].doge_patterns = python_config.patterns
      vim.b[buf].doge_supported_doc_standards = {'reST_custom'}
      vim.b[buf].doge_doc_standard = 'reST_custom'
    end,
  })
end

return M