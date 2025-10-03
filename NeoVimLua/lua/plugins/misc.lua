return {
  -- 快速 UI 和其他杂项功能
  -- { 'tpope/vim-fugitive', lazy = false, config = function()  -- 立即加载 Git 功能
  --     vim.keymap.set('n', '<C-g>', ':Git ', { noremap = true, desc = 'Git command' })
  --   end
  -- },
  { 'mbbill/undotree', lazy = false, config = function()  -- 立即加载撤销树
      vim.keymap.set('n', '<C-3>', ':UndotreeToggle<CR>', { noremap = true, silent = true, desc = '切换撤销树' })
    end
  },
  { 'skywind3000/vim-quickui', lazy = false, config = function()  -- 立即加载快速 UI
      -- 在 quickui 菜单中保护 hjkl 键用于导航
      vim.g.quickui_protect_hjkl = 1

      vim.keymap.set('n', '<C-Enter>', function()
        -- Get current file information for context-sensitive menu
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo.filetype
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local has_lsp = #clients > 0

        -- Build context menu based on file type and available features
        local content = {}

        -- LSP Navigation section (if LSP is available)
        if has_lsp then
          table.insert(content, {"📍 Go to &Definition\t\\gd", 'lua vim.lsp.buf.definition()'})
          table.insert(content, {"🔗 Go to &Type Definition\t\\gy", 'lua vim.lsp.buf.type_definition()'})
          table.insert(content, {"⚙️ Go to &Implementation\t\\gi", 'lua vim.lsp.buf.implementation()'})
          table.insert(content, {"🔍 Find &References\t\\gr", 'lua vim.lsp.buf.references()'})
          table.insert(content, {"-"})
        end

        -- File Operations
        table.insert(content, {"📁 File &Explorer\t\\c1", 'lua vim.cmd("Neotree toggle")'})
        table.insert(content, {"🔍 &Find Files\t\\cf", 'lua require("fzf-lua").files()'})
        table.insert(content, {"🔎 Live &Grep\t\\cg", 'lua require("fzf-lua").live_grep()'})
        table.insert(content, {"📋 Document &Symbols\t\\cs", 'lua require("fzf-lua").lsp_document_symbols()'})
        table.insert(content, {"-"})

        -- Code Actions (if LSP is available)
        if has_lsp then
          table.insert(content, {"💡 Code &Actions\t\\ca", 'lua vim.lsp.buf.code_action()'})
          table.insert(content, {"✏️ &Rename Symbol\t\\cr", 'lua vim.lsp.buf.rename()'})
          table.insert(content, {"🎯 &Format Code\t\\cf", 'lua vim.lsp.buf.format({async = true})'})
          table.insert(content, {"-"})
        end

        -- Language-specific features
        if filetype == "rust" then
          table.insert(content, {"🦀 Rust &Runnables\t\\rr", 'lua vim.cmd("RustLsp runnables")'})
          table.insert(content, {"🧪 Rust &Testables\t\\rt", 'lua vim.cmd("RustLsp testables")'})
          table.insert(content, {"🔧 Rust &Debuggables\t\\rd", 'lua vim.cmd("RustLsp debuggables")'})
          table.insert(content, {"📦 Open &Cargo.toml\t\\ro", 'lua vim.cmd("RustLsp openCargo")'})
          table.insert(content, {"-"})
        elseif filetype == "python" then
          table.insert(content, {"🐍 Python &Run\t\\pr", 'lua vim.cmd("!python %")'})
          table.insert(content, {"🧪 Python &Test\t\\pt", 'lua vim.cmd("TestFile")'})
          table.insert(content, {"📦 &Pip Install\t\\pi", 'lua vim.cmd("!pip install -r requirements.txt")'})
          table.insert(content, {"-"})
        elseif filetype == "lua" then
          table.insert(content, {"🌙 Lua &Run\t\\lr", 'lua vim.cmd("!lua %")'})
          table.insert(content, {"🔧 Lua &Config Check\t\\lc", 'lua vim.cmd("luafile %")'})
          table.insert(content, {"-"})
        end

        -- Diagnostics
        table.insert(content, {"⚠️ Show &Diagnostics\t\\ce", 'lua vim.diagnostic.open_float()'})
        table.insert(content, {"⬅️ Previous &Diagnostic\t\\g[", 'lua vim.diagnostic.goto_prev()'})
        table.insert(content, {"➡️ Next &Diagnostic\t\\g]", 'lua vim.diagnostic.goto_next()'})
        table.insert(content, {"🔧 Workspace &Diagnostics\t\\cD", 'lua require("fzf-lua").diagnostics_workspace()'})
        table.insert(content, {"-"})

        -- Git Operations
        table.insert(content, {"🔀 Git &Status\t\\gs", 'lua vim.cmd("Git status")'})
        table.insert(content, {"📝 Git &Commit\t\\gc", 'lua vim.cmd("Git commit")'})
        table.insert(content, {"📤 Git &Push\t\\gp", 'lua vim.cmd("Git push")'})
        table.insert(content, {"📥 Git &Pull\t\\gP", 'lua vim.cmd("Git pull")'})
        table.insert(content, {"-"})

        -- Utility Tools
        table.insert(content, {"🔄 &Undo Tree\t\\c3", 'lua vim.cmd("UndotreeToggle")'})
        table.insert(content, {"🔧 &Refactoring Menu\t\\rr", 'lua vim.cmd([[lua require("refactoring").refactor()]])'})
        table.insert(content, {"💬 &Comment\t\\cc", 'lua vim.cmd("Commentary")'})
        table.insert(content, {"🔄 &Cycle\t\\cyc", 'lua vim.cmd("CycleNext")'})
        table.insert(content, {"-"})

        -- Help and Info
        table.insert(content, {"❓ &Help\t\\ch", 'lua vim.cmd("help")'})
        table.insert(content, {"📖 LSP &Info\t\\cl", 'lua vim.cmd("LspInfo")'})
        table.insert(content, {"⌨️ Key&maps\t\\cm", 'lua vim.cmd("verbose map")'})
        table.insert(content, {"📋 Show &Messages\t\\cM", 'lua vim.cmd("messages")'})

        -- Position menu near cursor
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local opts = {
          index = 1,
          line = cursor_pos[1] + 1,  -- Position below current line
          col = cursor_pos[2] + 1   -- Position at cursor column
        }

        vim.fn['quickui#context#open'](content, opts)
      end, { noremap = true, silent = true, desc = 'QuickUI Context Menu' })

      -- Use Alt+Enter for LSP code actions to avoid conflict with vim-quickui
      vim.keymap.set('n', '<A-Enter>', function()
        -- Get LSP code actions at cursor
        local bufnr = vim.api.nvim_get_current_buf()
        -- Determine proper position encoding from the first attached client (fallback utf-8)
        local clients = {}
        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = bufnr })
        elseif vim.lsp.get_active_clients then
          clients = vim.lsp.get_active_clients()
        end
        local first = clients and clients[1] or nil
        local enc = (first and first.offset_encoding) or 'utf-8'

        -- Build range params with explicit encoding for Neovim 0.11+
        local params
        local ok, err = pcall(function()
          if vim.fn.has('nvim-0.11') == 1 then
            -- Neovim 0.11+ requires position_encoding
            params = vim.lsp.util.make_range_params({ position_encoding = enc })
          else
            -- Older Neovim versions
            params = vim.lsp.util.make_range_params()
            params.position_encoding = enc
          end
        end)

        if not ok or not params then
          vim.notify("Failed to create range params: " .. (err or "unknown error"), vim.log.levels.ERROR)
          return
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
      end, { noremap = true, silent = true, desc = 'Show Intention Actions (Alt+Enter)' })
    end
  },

  -- 增强重构支持（替代 coc.nvim 的许多重构功能）
  { 'ThePrimeagen/refactoring.nvim',
    lazy = false,  -- 立即加载重构工具
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
    end
  },

  -- Comments (gc/gcc)
  { 'tpope/vim-commentary', lazy = false },  -- 立即加载注释功能

  -- Cycle through predefined substitutions (gs to cycle)
  { 'bootleq/vim-cycle', lazy = false, config = function()  -- 立即加载循环替换
      vim.cmd([[
        nmap <silent> gs <Plug>CycleNext
        vmap <silent> gs <Plug>CycleNext
      ]])
    end
  },

  -- Surround text objects (modern Lua replacement for vim-surround)
  { 'kylechui/nvim-surround',
    lazy = false,  -- 立即加载文本包围功能
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- Exchange text regions
  -- { 'tommcdo/vim-exchange' },

  -- Async run & tasks (replaced by Neovim built-in functionality)
  -- Removed: asyncrun.vim and asynctasks.vim
  -- Use vim.fn.jobstart() or vim.system() for async tasks

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

  -- Enhanced fuzzy finder with fzf-lua - immediate load for responsiveness
  { 'ibhagwan/fzf-lua',
    lazy = false,  -- 立即加载，避免首次使用时的延迟
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- calling setup is optional
      require('fzf-lua').setup({
        -- fzf binary name/path (fzf by default)
        fzf_bin = "fzf",
        -- fzf command line options - ensure floating window
        fzf_opts = {
          ["--layout"] = "reverse-list",
          ["--height"] = "40%",
          ["--border"] = "rounded"
        },
        -- fzf action to open selected item
        fzf_actions = {
          ['ctrl-s'] = 'split',
          ['ctrl-v'] = 'vsplit',
          ['ctrl-t'] = 'tabedit',
          ['ctrl-q'] = 'close',
        },
        -- winopts = { ... } - see fzf-lua docs for more info
        winopts = {
          preview = {
            -- columns = 120,   -- preview width
            -- rows = 25,       -- preview height
            border = 'rounded',
            title = 'Preview',
            title_pos = 'center',
          },
          window = {
            width = 0.85,
            height = 0.85,
            border = 'rounded',
          },
        },
        -- keymaps
        keymap = {
          builtin = {
            ["<F1>"]     = "help",
            ["<F2>"]     = "toggle-fullscreen",
            -- Only valid with the 'builtin' previewer
            ["<F3>"]     = "toggle-preview-wrap",
            ["<F4>"]     = "toggle-preview",
            ["<F5>"]     = "toggle-preview-ccw",
            ["<F6>"]     = "toggle-preview-cw",
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"]   = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
          },
          fzf = {
            ["ctrl-z"]      = "abort",
            ["ctrl-u"]      = "unix-line-discard",
            ["ctrl-f"]      = "half-page-down",
            ["ctrl-b"]      = "half-page-up",
            ["ctrl-a"]      = "beginning-of-line",
            ["ctrl-e"]      = "end-of-line",
            ["alt-a"]       = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"]          = "toggle-preview-wrap",
            ["f4"]          = "toggle-preview",
            ["shift-down"]  = "preview-page-down",
            ["shift-up"]    = "preview-page-up",
          },
        },
        -- LSP settings
        lsp = {
          timeout = 5000, -- timeout in ms
          async_or_timeout = true, -- asynchronously make LSP requests
          -- use 'ui.select' for code actions when available, fallback to fzf-lua
          code_actions = {
            ui_select_fallback = true,
          },
          -- 符号显示设置
          symbols = {
            async_or_timeout = true,
            symbol_style = 1, -- 1: icon only, 2: symbol name only, 3: both
            symbol_icons = {
              File          = "󰈙",
              Module        = "",
              Namespace     = "󰦮",
              Package       = "",
              Class         = "󰆧",
              Method        = "󰊕",
              Property      = "",
              Field         = "",
              Constructor   = "",
              Enum          = "",
              Interface     = "",
              Function      = "󰊕",
              Variable      = "󰀫",
              Constant      = "󰏿",
              String        = "",
              Number        = "󰎠",
              Boolean       = "󰨙",
              Array         = "󱡠",
              Object        = "",
              Key           = "󰌋",
              Null          = "󰟢",
              EnumMember    = "",
              Struct        = "󰆼",
              Event         = "",
              Operator      = "󰆕",
              TypeParameter = "󰗴",
            },
          },
        },
      })
    end,
    keys = {
      { '<leader>s', function()
        require('fzf-lua').lsp_document_symbols({
          winopts = { preview = { enabled = true } },
          file_icons = true,
          color_icons = true,
        })
      end, desc = 'Document Symbols (FZF)' },
      { '<leader>S', function()
        require('fzf-lua').lsp_workspace_symbols({
          winopts = { preview = { enabled = true } },
          file_icons = true,
          color_icons = true,
        })
      end, desc = 'Workspace Symbols (FZF)' },
      { '<leader>d', function() require('fzf-lua').diagnostics_document() end, desc = 'Diagnostics (buffer)' },
      { '<leader>D', function() require('fzf-lua').diagnostics_workspace() end, desc = 'Workspace Diagnostics' },
      { '<leader>c', function() require('fzf-lua').commands() end, desc = 'Commands' },
      { '<leader>g', function() require('fzf-lua').live_grep() end, desc = 'Live Grep' },
      { '<leader>f', function() require('fzf-lua').files() end, desc = 'Find Files' },
      { '<leader>b', function() require('fzf-lua').buffers() end, desc = 'Buffers' },
      { 'gd', function() require('fzf-lua').lsp_definitions() end, desc = 'Go to Definition' },
      { 'gr', function() require('fzf-lua').lsp_references() end, desc = 'Go to References' },
      { 'gi', function() require('fzf-lua').lsp_implementations() end, desc = 'Go to Implementation' },
      { 'gy', function() require('fzf-lua').lsp_typedefs() end, desc = 'Go to Type Definition' },
    }
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

  -- Drag visuals replaced by Neovim built-in functionality
  -- Removed: jondkinney/dragvisuals.vim
  -- Use visual block mode (Ctrl+v) and movement commands instead

  -- Rust specific plugins
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = { 'rust' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'mfussenegger/nvim-dap', -- Optional, for debugging
    },
    config = function()
      -- Determine available debug adapter at config time
      local debug_adapter = 'lldb-dap'  -- fallback
      if vim.fn.executable('codelldb') == 1 then
        debug_adapter = 'codelldb'
      elseif vim.fn.executable('lldb-vscode') == 1 then
        debug_adapter = 'lldb-vscode'
      end

      vim.g.rustaceanvim = {
        -- Plugin configuration following official guidelines
        tools = {
          -- Enable hover actions with floating window
          hover_actions = {
            border = {
              {"┌", "FloatBorder"},
              {"─", "FloatBorder"},
              {"┐", "FloatBorder"},
              {"│", "FloatBorder"},
              {"┘", "FloatBorder"},
              {"─", "FloatBorder"},
              {"┚", "FloatBorder"},
              {"│", "FloatBorder"},
            },
            auto_focus = false, -- Don't auto-focus hover actions window
          },

          -- Test executor configuration
          test_executor = 'termopen', -- Use termopen for test execution

          -- Crate graph configuration (requires graphviz)
          crate_graph = {
            backend = 'dot', -- Use graphviz dot
            output = 'svg',  -- Output format
            enabled_graphviz_backends = { 'dot', 'neato', 'fdp', 'sfdp', 'twopi' },
          },

          -- Code actions UI fallback
          code_actions = {
            ui_select_fallback = true, -- Fall back to vim.ui.select when no grouped actions
          },
        },

        -- LSP configuration (rustaceanvim handles rust-analyzer automatically)
        server = {
          -- Performance optimizations
          standalone = false, -- Disable standalone file support for faster startup
          ra_multiplex = {
            enable = true, -- Connect to running ra-multiplex server for better performance
          },

          -- Custom on_attach for Rust-specific keymaps
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true, desc = '' }

            -- Standard LSP mappings (ensure they work in Rust files)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, {
              desc = 'LSP Rename'
            }))
            vim.keymap.set({'n', 'x'}, '<leader>a', vim.lsp.buf.code_action, opts)
            vim.keymap.set({'n', 'x'}, '<leader>f', function()
              vim.lsp.buf.format({ async = true })
            end, opts)
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, opts)

            -- Use standard LSP hover for reliability
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, {
              desc = 'LSP Hover'
            }))

            -- Rust-specific mappings (enhanced functionality)

            -- Enhanced code actions (grouped) - Rust-specific enhancement
            vim.keymap.set('n', '<leader>ca', function()
              vim.cmd.RustLsp('codeAction')
            end, vim.tbl_extend('force', opts, { desc = 'Rust Code Actions (Grouped)' }))

            -- Debugging commands - following your existing <leader>d pattern
            vim.keymap.set('n', '<leader>dr', function()
              vim.cmd.RustLsp('debuggables')
            end, vim.tbl_extend('force', opts, { desc = 'Rust Debuggables' }))

            vim.keymap.set('n', '<leader>dR', function()
              vim.cmd.RustLsp { 'debug', bang = true } -- Rerun last debuggable
            end, vim.tbl_extend('force', opts, { desc = 'Rust Debug Last' }))

            -- Running commands - consolidated under single <leader>rr
            vim.keymap.set('n', '<leader>rr', function()
              vim.cmd.RustLsp('runnables')
            end, vim.tbl_extend('force', opts, { desc = 'Rust Runnables' }))

            vim.keymap.set('n', '<leader>rR', function()
              vim.cmd.RustLsp { 'runnables', bang = true } -- Rerun last runnable
            end, vim.tbl_extend('force', opts, { desc = 'Rust Run Last' }))

            -- Testing commands - following vim-test patterns
            vim.keymap.set('n', '<leader>tn', function()
              vim.cmd.RustLsp('testables') -- Test nearest function
            end, vim.tbl_extend('force', opts, { desc = 'Rust Test Nearest' }))

            vim.keymap.set('n', '<leader>tf', function()
              vim.cmd.RustLsp { 'testables', bang = true } -- Test current file
            end, vim.tbl_extend('force', opts, { desc = 'Rust Test File' }))

            -- Macro operations - simplified key mapping pattern
            vim.keymap.set('n', '<leader>rm', function()
              vim.cmd.RustLsp('expandMacro')
            end, vim.tbl_extend('force', opts, { desc = 'Expand Macro' }))

            vim.keymap.set('n', '<leader>rM', function()
              vim.cmd.RustLsp('rebuildProcMacros')
            end, vim.tbl_extend('force', opts, { desc = 'Rebuild Proc Macros' }))

            -- Code analysis and debugging - using <leader>g for "go/analysis" pattern
            vim.keymap.set('n', '<leader>gs', function()
              vim.cmd.RustLsp('ssr')
            end, vim.tbl_extend('force', opts, { desc = 'Structural Search Replace' }))

            vim.keymap.set('n', '<leader>rd', function()
              vim.cmd.RustLsp('renderDiagnostic')
            end, vim.tbl_extend('force', opts, { desc = 'Render Diagnostic' }))

            vim.keymap.set('n', '<leader>re', function()
              vim.cmd.RustLsp('explainError')
            end, vim.tbl_extend('force', opts, { desc = 'Explain Error' }))

            vim.keymap.set('n', '<leader>gq', function()
              vim.cmd.RustLsp('relatedDiagnostics')
            end, vim.tbl_extend('force', opts, { desc = 'Related Diagnostics' }))

            -- File and project navigation - following your existing patterns
            vim.keymap.set('n', '<leader>ro', function()
              vim.cmd.RustLsp('openCargo')
            end, vim.tbl_extend('force', opts, { desc = 'Open Cargo.toml' }))

            vim.keymap.set('n', '<leader>K', function()
              vim.cmd.RustLsp('openDocs')
            end, vim.tbl_extend('force', opts, { desc = 'Open Rust Documentation' }))

            vim.keymap.set('n', '<leader>rp', function()
              vim.cmd.RustLsp('parentModule')
            end, vim.tbl_extend('force', opts, { desc = 'Parent Module' }))

            -- Code manipulation - using simpler, more intuitive patterns
            vim.keymap.set('n', '<leader>gj', function()
              vim.cmd.RustLsp('joinLines')
            end, vim.tbl_extend('force', opts, { desc = 'Join Lines' }))

            vim.keymap.set('n', '<leader>gi', function()
              vim.cmd.RustLsp { 'moveItem', 'up' }
            end, vim.tbl_extend('force', opts, { desc = 'Move Item Up' }))

            vim.keymap.set('n', '<leader>gk', function()
              vim.cmd.RustLsp { 'moveItem', 'down' }
            end, vim.tbl_extend('force', opts, { desc = 'Move Item Down' }))

            -- Advanced features - simplified patterns
            vim.keymap.set('n', '<leader>cg', function()
              vim.cmd.RustLsp('crateGraph')
            end, vim.tbl_extend('force', opts, { desc = 'Crate Graph' }))

            vim.keymap.set('n', '<leader>cs', function()
              vim.cmd.RustLsp('syntaxTree')
            end, vim.tbl_extend('force', opts, { desc = 'Syntax Tree' }))

            -- Hover actions - keeping your existing <leader>ra pattern
            vim.keymap.set('n', '<leader>ra', '<Plug>RustHoverAction',
              vim.tbl_extend('force', opts, { desc = 'Execute Hover Action' }))

            vim.keymap.set('n', '<leader>rh', function()
              vim.cmd.RustLsp { 'hover', 'range' }
            end, vim.tbl_extend('force', opts, { desc = 'Hover Range' }))

            -- Fly check (background cargo check) - simplified pattern
            vim.keymap.set('n', '<leader>cc', function()
              vim.cmd.RustLsp { 'flyCheck', 'run' }
            end, vim.tbl_extend('force', opts, { desc = 'Cargo Check Run' }))

            vim.keymap.set('n', '<leader>cC', function()
              vim.cmd.RustLsp { 'flyCheck', 'clear' }
            end, vim.tbl_extend('force', opts, { desc = 'Cargo Check Clear' }))

            vim.keymap.set('n', '<leader>cX', function()
              vim.cmd.RustLsp { 'flyCheck', 'cancel' }
            end, vim.tbl_extend('force', opts, { desc = 'Cargo Check Cancel' }))

    
            -- Additional Rustc commands (requires nightly compiler) - optional
            vim.keymap.set('n', '<leader>rhb', function()
              vim.cmd.Rustc { 'unpretty', 'hir' }
            end, vim.tbl_extend('force', opts, { desc = 'Rustc HIR' }))

            vim.keymap.set('n', '<leader>rbm', function()
              vim.cmd.Rustc { 'unpretty', 'mir' }
            end, vim.tbl_extend('force', opts, { desc = 'Rustc MIR' }))

            -- Inlay hints (Neovim 0.10+ handles these natively, but we can enable/disable them)
            vim.keymap.set('n', '<leader>rih', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, vim.tbl_extend('force', opts, { desc = 'Toggle Inlay Hints' }))

            -- Debug LSP status
            vim.keymap.set('n', '<leader>rl', function()
              print("LSP Clients active:")
              local clients
              if vim.lsp.get_clients then
                -- Neovim 0.10+
                clients = vim.lsp.get_clients({ bufnr = bufnr })
              else
                -- Fallbalk for older versions
                clients = vim.lsp.get_active_clients({ bufnr = bufnr })
              end

              for _, client in ipairs(clients) do
                local rename_status = client.server_capabilities.renameProvider and "✓ rename" or "✗ rename"
                print(string.format("- %s: %s", client.name, rename_status))
              end
              if #clients == 0 then
                print("No active LSP clients")
              end
            end, vim.tbl_extend('force', opts, { desc = 'LSP Status' }))
          end,

          -- rust-analyzer server settings (optimized for performance)
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true, -- Load output directories from check command for better performance
              },
              check = {
                command = "clippy",
                extraArgs = { "--all", "--all-features", "--", "-D", "warnings" },
                onSave = "file", -- Only check current file on save for faster response
              },
              procMacro = { enable = true },
              inlayHints = {
                enable = true,
                typeHints = { enable = true },
                parameterHints = { enable = true },
                chainingHints = { enable = true },
                lifetimeElisionHints = { enable = "skip_trivial" },
              },
              -- Performance optimizations
              files = {
                watcher = "server", -- Use server-side file watcher for better performance
                excludeDirs = { "target", ".git" }, -- Exclude unnecessary directories
              },
              imports = {
                granularity = { group = "module" }, -- Group imports by module for better organization
                prefix = "crate", -- Use crate prefix for imports
              },
              completion = {
                addCallParentheses = true,
                addCallArgumentSnippets = true,
                postfix = { enable = true },
              },
              -- Disable some expensive features if not needed
              diagnostics = {
                enable = true,
                experimental = { enable = false }, -- Disable experimental diagnostics for better performance
              },
            },
          },
        },

        -- DAP (Debug Adapter Protocol) configuration
        dap = {
          -- Auto-load DAP configurations
          autoload_configurations = true,
          adapter = {
            type = 'executable',
            command = debug_adapter,
            name = 'rt_lldb',
          },
        },
      }
    end,
  },

  -- Cargo.toml management
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('crates').setup({
        src = {
          cmp = {
            enabled = true,
          },
        },
      })

      -- Key mappings for cargo operations
      vim.keymap.set('n', '<leader>ct', function()
        require('crates').toggle()
      end, { desc = 'Toggle Crate Versions' })

      vim.keymap.set('n', '<leader>cu', function()
        require('crates').upgrade_crate()
      end, { desc = 'Upgrade Crate' })

      vim.keymap.set('n', '<leader>cA', function()
        require('crates').upgrade_all_crates()
      end, { desc = 'Upgrade All Crates' })

      vim.keymap.set('n', '<leader>cr', function()
        require('crates').reload()
      end, { desc = 'Reload Crates' })
    end,
  },

  -- -- Rust test runner
  -- {
  --   'vim-test/vim-test',
  --   ft = { 'rust' },
  --   dependencies = {
  --     'preservim/vimux',
  --   },
  --   config = function()
  --     -- Test configuration for Rust
  --     vim.g['test#rust#runner'] = 'cargo'
  --     vim.g['test#rust#cargo#options'] = '--quiet'

  --     -- Key mappings for testing
  --     vim.keymap.set('n', '<leader>tn', function()
  --       vim.cmd('TestNearest')
  --     end, { desc = 'Test Nearest' })

  --     vim.keymap.set('n', '<leader>tf', function()
  --       vim.cmd('TestFile')
  --     end, { desc = 'Test File' })

  --     vim.keymap.set('n', '<leader>ts', function()
  --       vim.cmd('TestSuite')
  --     end, { desc = 'Test Suite' })

  --     vim.keymap.set('n', '<leader>tl', function()
  --       vim.cmd('TestLast')
  --     end, { desc = 'Test Last' })
  --   end,
  -- },

  -- Claude Code integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    version="^0.3",
    config = true,
    opts = {
      -- Server Configuration
      port_range = { min = 54590, max = 54666 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      -- terminal_cmd = nil, -- Custom terminal command (default: "claude")
      --                     -- For local installations: "~/.claude/local/claude"
      --                     -- For native binary: use output from 'which claude'
    
      -- Send/Focus Behavior
      -- When true, successful sends will focus the Claude terminal if already connected
      focus_after_send = false,
    
      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,
    
      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.30,
        provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
        auto_close = true,
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
    
        -- Provider-specific options
        provider_opts = {
          -- Command for external terminal provider. Can be:
          -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
          -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
          -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
          external_terminal_cmd = nil,
        },
      },
    
      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
      },
    },
    keys = {
      { "<leader>i", nil, desc = "AI/Claude Code" },
      { "<leader>ii", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>it",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>ia", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

}
