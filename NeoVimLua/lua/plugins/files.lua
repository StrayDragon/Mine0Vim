return {
  -- Modern file management with nvim-tree.lua (fast and lightweight)
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,  -- 立即加载文件管理器
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- 图标支持
    },
    opts = {
      -- 基本设置
      hijack_netrw = false,
      auto_reload_on_write = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },

      -- 性能优化配置
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = { ".git", "node_modules", "__pycache__", ".venv", "target", "dist", "build" },
      },

      -- 优化的视图设置
      view = {
        width = { min = 30, max = 45 },
        side = "left",
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 50,
            height = 30,
            row = 1,
            col = 1,
          },
        },
        preserve_window_proportions = true,
        cursorline = true,
      },

      -- 增强的渲染器配置
      renderer = {
        group_empty = true,
        full_name = false,
        root_folder_label = function(path)
          return vim.fn.fnamemodify(path, ":~:t")
        end,
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "signcolumn",
          modified_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = "󰈚",
            symlink = "",
            bookmark = "󰆃",
            modified = "●",
            folder = {
              arrow_closed = "▶",
              arrow_open = "▼",
              default = "󰉋",
              open = "󰝰",
              empty = "󰜌",
              empty_open = "󰝏",
              symlink = "󰉌",
              symlink_open = "󰝏",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        special_files = {
          "Cargo.toml", "README.md", "package.json", "requirements.txt",
          "Makefile", "CMakeLists.txt", "setup.py", "init.lua"
        },
        highlight_git = true,
        highlight_diagnostics = true,
        highlight_opened_files = "name",
        highlight_modified = "icon",
      },

      -- 优化的Git集成（异步）
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = { "node_modules", ".git", "target", "dist" },
        timeout = 400,
        ignore = {
          ".git", ".svn", ".hg", ".DS_Store", "node_modules", "__pycache__",
          ".venv", "target", "dist", "build", ".pytest_cache"
        },
      },

      -- 启用诊断（异步）
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = "󰌵",
          info = "󰋼",
          warning = "󰀪",
          error = "󰅙",
        },
      },

      -- 增强的过滤器
      filters = {
        git_ignored = true,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {
          ".git",
          "node_modules",
          "__pycache__",
          ".pytest_cache",
          ".mypy_cache",
          ".coverage",
          "target",
          "dist",
          "build",
          ".DS_Store",
          "*.pyc",
          "*.pyo",
          ".venv",
          "venv",
          "env",
          ".env",
          "*.log",
          "*.tmp"
        },
      },

      -- 修改的配置
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },

      -- 增强的文件操作
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = { ".git", "target", "node_modules", ".cache" },
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            border = "single",
            relative = "cursor",
            width = "30%",
            height = "40%",
          },
        },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },
    },
    config = function(_, opts)
      -- 自定义 on_attach 函数以添加 l/h 键映射
      local function on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- 应用默认映射
        api.config.mappings.default_on_attach(bufnr)

        -- 添加 l 和 h 键映射用于文件夹导航
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))

        -- 添加基本键位映射（使用安全的API调用）
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse All'))
        vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
        vim.keymap.set('n', '<C-q>', api.tree.close, opts('Close'))
      end

      -- 添加 on_attach 到配置
      opts.on_attach = on_attach
      require("nvim-tree").setup(opts)

      -- 键位映射
      local map = vim.keymap.set
      local opts_noremap = { noremap = true, silent = true, desc = "Nvim-tree" }

      -- 文件管理器键位（智能切换）
      local function nvim_tree_open_smart()
        -- 检查是否已经有 Nvim-tree 窗口打开
        local nvim_tree_found = false
        local nvim_tree_win = nil
        local current_win = vim.api.nvim_get_current_win()

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          if ft == "NvimTree" then
            nvim_tree_found = true
            nvim_tree_win = win
            break
          end
        end

        if nvim_tree_found and nvim_tree_win then
          if current_win == nvim_tree_win then
            -- 如果当前就在 Nvim-tree 窗口中，关闭它
            vim.cmd("NvimTreeClose")
          else
            -- 如果 Nvim-tree 已经打开但不在其中，切换到该窗口
            vim.api.nvim_set_current_win(nvim_tree_win)
          end
        else
          -- 否则打开新的 Nvim-tree 边栏
          vim.cmd("NvimTreeOpen")
        end
      end

      map("n", "<A-1>", nvim_tree_open_smart, vim.tbl_extend("force", opts_noremap, { desc = "Nvim-tree file browser (smart toggle)" }))
      -- 移除 <leader>e 文件浏览器功能，避免与 <space>e (LSP 查找器) 冲突
      -- 用户可以使用 <A-1> 作为文件浏览器替代
      map("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>", vim.tbl_extend("force", opts_noremap, { desc = "Nvim-tree find current file" }))

      
      -- 禁用 netrw 以避免冲突
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}