return {
  -- quickui for context menu and misc
  { 'tpope/vim-fugitive', config = function()
      vim.keymap.set('n', '<C-g>', ':Git ', { noremap = true, desc = 'Git command' })
    end
  },
  { 'mbbill/undotree', config = function()
      vim.keymap.set('n', '<C-3>', ':UndotreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle UndoTree' })
    end
  },
  { 'skywind3000/vim-quickui', config = function()
      vim.keymap.set('n', '<C-Enter>', function()
        vim.fn['quickui#context#open']()
      end, { noremap = true, silent = true, desc = 'QuickUI Context Menu' })
      
      -- Ctrl-based Quick Fix / Intention Actions (compatible with macOS)
      vim.keymap.set('n', '<C-CR>', function()
        -- Get LSP code actions at cursor
        local bufnr = vim.api.nvim_get_current_buf()
        -- Determine proper position encoding from the first attached client (fallback utf-16)
        local clients = {}
        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = bufnr })
        elseif vim.lsp.get_active_clients then
          clients = vim.lsp.get_active_clients()
        end
        local first = clients and clients[1] or nil
        local enc = (first and first.offset_encoding) or 'utf-16'

        -- Build range params with explicit encoding, with compatibility fallbacks
        local ok, params = pcall(function()
          return vim.lsp.util.make_range_params(nil, enc)
        end)
        if not ok then
          ok, params = pcall(function()
            return vim.lsp.util.make_range_params({ position_encoding = enc })
          end)
        end
        if not ok then
          params = vim.lsp.util.make_range_params()
          params.position_encoding = enc
        end

        params.context = { diagnostics = vim.diagnostic.get(bufnr, { lnum = vim.fn.line('.') - 1 }) }
        
        vim.lsp.buf_request(bufnr, 'textDocument/codeAction', params, function(err, result, ctx)
          if err or not result or vim.tbl_isempty(result) then
            vim.notify("No code actions available", vim.log.levels.INFO)
            return
          end
          
          -- Build titles list for QuickUI (JetBrains style)
          local titles = {}
          for i, action in ipairs(result) do
            local title = action.title or ("Intention Action " .. i)
            if action.kind then
              if action.kind:match("quickfix") then
                title = "💡 " .. title  -- Light bulb like IntelliJ
              elseif action.kind:match("refactor") then
                title = "🔧 " .. title
              elseif action.kind:match("source") then
                title = "📦 " .. title
              end
            end
            table.insert(titles, title)
          end

          local idx = vim.fn['quickui#listbox#inputlist'](titles, {
            title = 'Show Intention Actions',
            border = 1,
            index = 1,
            syntax = 'cpp',
          })
          if idx == nil or idx < 1 then return end

          local chosen = result[idx]
          local client = ctx and vim.lsp.get_client_by_id(ctx.client_id)
          local apply_enc = (client and client.offset_encoding) or enc or 'utf-16'

          -- Apply edits first if present
          if chosen.edit then
            vim.lsp.util.apply_workspace_edit(chosen.edit, apply_enc)
          end
          -- Then run command if present
          if chosen.command then
            vim.lsp.buf.execute_command(chosen.command)
          end
        end)
      end, { noremap = true, silent = true, desc = 'Show Intention Actions (Ctrl+Enter)' })
    end
  },

  -- Enhanced refactoring support (replaces many coc.nvim refactoring features)
  { 'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('refactoring').setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
      
      -- Refactoring keymaps (similar to coc.nvim refactoring)
      vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract function" })
      vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" })
      vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract variable" })
      vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Inline variable" })
      vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline function" })
      vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract block" })
      vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", { desc = "Extract block to file" })
      
      -- QuickUI integration for refactoring menu
      vim.keymap.set({'n', 'x'}, '<leader>rr', function()
        local items = {
          '🔄 Extract Function',
          '🔄 Extract Variable',
          '🔄 Extract to File',
          '🔄 Inline Variable',
          '🔄 Inline Function',
          '🔄 Extract Block',
          '🔄 Extract Block to File',
        }
        local cmds = {
          'Refactor extract',
          'Refactor extract_var',
          'Refactor extract_to_file',
          'Refactor inline_var',
          'Refactor inline_func',
          'Refactor extract_block',
          'Refactor extract_block_to_file',
        }

        local idx = vim.fn['quickui#listbox#inputlist'](items, {
          title = 'Refactoring Menu',
          border = 1,
          index = 1,
          syntax = 'cpp',
        })
        if idx and idx > 0 and cmds[idx] then
          vim.cmd(cmds[idx])
        end
      end, { desc = 'Refactoring menu' })

      -- JetBrains style "Refactor This" menu (Ctrl+T on macOS, following IntelliJ standards)
      vim.keymap.set({'n', 'x'}, '<C-t>', function()
        local items = {
          '🔧 Extract Function',
          '🔧 Extract Variable', 
          '🔧 Extract to File',
          '🔧 Inline Variable',
          '🔧 Inline Function',
          '🔧 Extract Block',
          '🔧 Extract Block to File',
          '🔧 Rename Symbol',
        }
        local cmds = {
          'Refactor extract',
          'Refactor extract_var',
          'Refactor extract_to_file',
          'Refactor inline_var',
          'Refactor inline_func',
          'Refactor extract_block',
          'Refactor extract_block_to_file',
          function() vim.lsp.buf.rename() end,
        }

        local idx = vim.fn['quickui#listbox#inputlist'](items, {
          title = 'Refactor This',
          border = 1,
          index = 1,
          syntax = 'cpp',
        })
        if idx and idx > 0 and cmds[idx] then
          if type(cmds[idx]) == 'function' then
            cmds[idx]()
          else
            vim.cmd(cmds[idx])
          end
        end
      end, { desc = 'Refactor This (JetBrains Ctrl+T)' })
    end
  },

  -- Comments (gc/gcc)
  { 'tpope/vim-commentary' },

  -- Cycle through predefined substitutions (gs to cycle)
  { 'bootleq/vim-cycle', config = function() 
      vim.cmd([[ 
        nmap <silent> gs <Plug>CycleNext 
        vmap <silent> gs <Plug>CycleNext 
      ]]) 
    end 
  },

  -- Surround text objects (modern Lua replacement for vim-surround)
  { 'kylechui/nvim-surround',
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- Exchange text regions
  { 'tommcdo/vim-exchange' },

  -- Terminal help for better terminal experience
  { 'skywind3000/vim-terminal-help' },

  -- Async run & tasks
  { 'skywind3000/asyncrun.vim' },
  { 'skywind3000/asynctasks.vim' },

  -- File explorer replacement for coc-explorer
  { 'nvim-neo-tree/neo-tree.nvim',
    branch = "v3.x",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = {
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
          },
        },
        window = {
          position = "left",
          width = 30,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
      })
      vim.keymap.set('n', '<C-1>', ':Neotree toggle<CR>', 
        { noremap = true, silent = true, desc = 'Toggle File Explorer' })
    end
  },

  -- Telescope: diagnostics list, command list, symbol search
  { 'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<space>d', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, desc = 'Diagnostics (buffer)' },
      { '<space>c', function() require('telescope.builtin').commands() end, desc = 'Commands' },
      { '<space>s', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Document Symbols' },
      { '<space>S', function() require('telescope.builtin').lsp_workspace_symbols() end, desc = 'Workspace Symbols' },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          mappings = {
            i = { ['<C-c>'] = require('telescope.actions').close },
            n = { ['<C-c>'] = require('telescope.actions').close },
          }
        }
      })
    end
  },

  -- Multi-cursor support (vim-visual-multi)
  { 'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Map <C-d> to add next occurrence, <C-c> to skip current region
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
        ['Skip Region'] = '<C-c>',
      }
    end,
  },

  -- Drag visuals (Damian Conway) - visual mode only
  { 'jondkinney/dragvisuals.vim',
    init = function()
      -- Trim trailing whitespace introduced by dragging
      vim.g.DVB_TrimWS = 1
      -- Only in Visual mode to avoid conflicts with normal-mode quickfix maps
      vim.keymap.set('x', '<LEFT>',  "DVB_Drag('left')",  { expr = true, silent = true, desc = 'Drag selection left' })
      vim.keymap.set('x', '<RIGHT>', "DVB_Drag('right')", { expr = true, silent = true, desc = 'Drag selection right' })
      vim.keymap.set('x', '<DOWN>',  "DVB_Drag('down')",  { expr = true, silent = true, desc = 'Drag selection down' })
      vim.keymap.set('x', '<UP>',    "DVB_Drag('up')",    { expr = true, silent = true, desc = 'Drag selection up' })
      vim.keymap.set('x', 'D',       "DVB_Duplicate()",   { expr = true, silent = true, desc = 'Duplicate selection' })
    end,
  },


}