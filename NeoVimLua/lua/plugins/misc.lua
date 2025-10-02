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
      vim.g.rustaceanvim = {
        -- Plugin configuration following official guidelines
        tools = {
          -- Enable hover actions with floating window
          hover_actions = {
            border = 'rounded',
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
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, opts)

            -- Override hover keymap to show hover actions (recommended by official docs)
            vim.keymap.set('n', 'K', function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end, vim.tbl_extend('force', opts, { desc = 'Rust Hover Actions' }))

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

            -- Workspace symbol search - following telescope patterns
            vim.keymap.set('n', '<space>s', function()
              vim.cmd.RustLsp('workspaceSymbol')
            end, vim.tbl_extend('force', opts, { desc = 'Workspace Symbol' }))

            vim.keymap.set('n', '<space>S', function()
              vim.cmd.RustLsp { 'workspaceSymbol', 'allSymbols', bang = true }
            end, vim.tbl_extend('force', opts, { desc = 'Workspace All Symbols' }))

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
              local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
              for _, client in ipairs(clients) do
                print(string.format("- %s: %s", client.name, table.concat(client.server_capabilities.renameProvider and "✓ rename" or "✗ rename", ", ")))
              end
              if #clients == 0 then
                print("No active LSP clients")
              end
            end, vim.tbl_extend('force', opts, { desc = 'LSP Status' }))
          end,

          -- rust-analyzer server settings (comprehensive configuration)
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              -- Cargo configuration
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                features = "all", -- Enable all features
              },

              -- Build configuration
              buildScripts = {
                enable = true,
              },

              -- Proc macro support
              procMacro = {
                enable = true,
                attributes = { enable = true },
              },

              -- Completion configuration
              completion = {
                addCallParentheses = true,
                addCallArgumentSnippets = true,
                postfix = { enable = true },
                autoimport = { enable = true },
              },

              -- Rename configuration
              rename = {
                enable = true,
              },

              -- Diagnostics configuration
              diagnostics = {
                enable = true,
                experimental = { enable = true },
                disabled = { 'unresolved-proc-macro' },
                styleLints = { enable = true },
              },

              -- Inlay hints (Neovim 0.10+ handles these natively)
              inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { minLines = 25 },
                discriminantHints = { enable = true },
                lifetimeElisionHints = {
                  enable = 'skip_trivial',
                  useParameterNames = true,
                },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = 'mutable' },
                renderColon = false,
                typeHints = {
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },

              -- Hover configuration
              hover = {
                actions = {
                  enable = true,
                  implementations = true,
                  references = true,
                  run = true,
                },
                documentation = { enable = true },
                links = { enable = true },
              },

              -- Lens configuration
              lens = {
                enable = true,
                implementations = { enable = true },
                references = {
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
                run = { enable = true },
              },

              -- Check configuration
              check = {
                command = 'clippy',
                extraArgs = { '--all', '--all-features', '--', '-D', 'warnings' },
                features = 'all',
              },

              -- Semantic highlighting
              semanticHighlighting = {
                strings = { enable = true },
              },

              -- Workspace symbol search
              workspace = {
                symbol = {
                  search = {
                    kind = 'all',
                    limit = 200,
                  },
                },
              },
            },
          },
        },

        -- DAP (Debug Adapter Protocol) configuration
        dap = {
          -- Auto-load DAP configurations
          autoload_configurations = true,
          -- Try to auto-detect debug adapters
          adapter = {
            type = 'executable',
            command = function()
              -- Try to find codelldb first (better experience)
              if vim.fn.executable('codelldb') == 1 then
                return { 'codelldb' }
              elseif vim.fn.executable('lldb-vscode') == 1 then
                return { 'lldb-vscode' }
              else
                return { 'lldb-dap' }
              end
            end,
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

  -- Rust test runner
  {
    'vim-test/vim-test',
    ft = { 'rust' },
    dependencies = {
      'preservim/vimux',
    },
    config = function()
      -- Test configuration for Rust
      vim.g['test#rust#runner'] = 'cargo'
      vim.g['test#rust#cargo#options'] = '--quiet'

      -- Key mappings for testing
      vim.keymap.set('n', '<leader>tn', function()
        vim.cmd('TestNearest')
      end, { desc = 'Test Nearest' })

      vim.keymap.set('n', '<leader>tf', function()
        vim.cmd('TestFile')
      end, { desc = 'Test File' })

      vim.keymap.set('n', '<leader>ts', function()
        vim.cmd('TestSuite')
      end, { desc = 'Test Suite' })

      vim.keymap.set('n', '<leader>tl', function()
        vim.cmd('TestLast')
      end, { desc = 'Test Last' })
    end,
  },

}