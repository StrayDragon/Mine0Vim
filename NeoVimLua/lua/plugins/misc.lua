return {
  -- 快速 UI 和其他杂项功能
  -- { 'tpope/vim-fugitive', lazy = false, config = function()  -- 立即加载 Git 功能
  --     vim.keymap.set('n', '<C-g>', ':Git ', { noremap = true, desc = 'Git command' })
  --   end
  -- },
  { 'mbbill/undotree', lazy = false, config = function()  -- 立即加载撤销树
      vim.keymap.set('n', '<A-3>', ':UndotreeToggle<CR>', { noremap = true, silent = true, desc = '切换撤销树' })
    end
  },
  -- 代码动作插件 - 替代 vim-quickui
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      {"nvim-lua/plenary.nvim"},
      {"ibhagwan/fzf-lua"}, -- 使用 fzf-lua 作为选择器
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup()
    end,
    keys = {
      { "<A-Enter>", function() require("tiny-code-action").code_action() end, desc = "LSP Code Actions (Alt+Enter)" },
      { "<leader>a", function() require("tiny-code-action").code_action() end, desc = "LSP Code Actions" },
    },
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
      { '<leader>h', function() require('fzf-lua').files() end, desc = 'Find Files' },
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

  -- Rust specific plugins moved to dedicated rust.lua plugin file
  -- This maintains backward compatibility while providing better organization

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
