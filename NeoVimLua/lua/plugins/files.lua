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
      },

      -- 简化视图设置
      view = {
        width = 30,
        side = "left",
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },

      -- 简化渲染器 - 禁用图标和Git状态
      renderer = {
        group_empty = false,
        full_name = false,
        root_folder_label = ":~:s?$",
        indent_width = 2,
        indent_markers = {
          enable = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
            modified = false,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_closed = "▶",
              arrow_open = "▼",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
          },
        },
      },

      -- 禁用Git集成
      git = {
        enable = false,
      },

      -- 禁用诊断
      diagnostics = {
        enable = false,
      },

      -- 简化过滤器
      filters = {
        dotfiles = false,
        custom = {},
      },

      -- 简化文件操作
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
        },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = false,
          },
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
      map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", vim.tbl_extend("force", opts_noremap, { desc = "Nvim-tree toggle" }))
      map("n", "<leader>nf", "<Cmd>NvimTreeFindFile<CR>", vim.tbl_extend("force", opts_noremap, { desc = "Nvim-tree find current file" }))

      -- 添加用户命令
      vim.api.nvim_create_user_command("NvimTreeHelp", function()
        print([[
Nvim-tree.lua 快捷键：
  Enter     - 打开文件/进入目录
  o         - 打开文件
  <C-e>     - 编辑文件名
  <C-t>     - 新标签页打开
  <C-v>     - 垂直分割打开
  <C-x>     - 水平分割打开
  Tab       - 预览文件
  <C-]>     - 切换根目录
  <BS>      - 上级目录
  .         - 显示/隐藏文件
  R         - 刷新
  a         - 添加文件
  A         - 添加目录
  d         - 删除
  r         - 重命名
  y         - 复制
  x         - 剪切
  p         - 粘贴
  c         - 复制到
  m         - 移动到
  q         - 关闭 Nvim-tree
  W         - 折叠所有
  E         - 展开所有
  C         - 折叠子节点
  ]])
      end, { desc = "Show Nvim-tree keymaps help" })

      -- 禁用 netrw 以避免冲突
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- mini.files 文件管理器（作为 Nvim-tree 的补充）
  {
    "echasnovski/mini.files",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 20,
        width_preview = 100,
      },
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "<CR>",
        go_out = "h",
        go_out_plus = "H",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<LocalLeader>l",
        trim_right = "<LocalLeader>r",
      },
      options = {
        use_as_default_explorer = false,  -- 不作为默认浏览器
        permanent_delete = false,
        windows_focus_preview = true,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      -- 创建迷你文件浏览器
      local MiniFiles = require("mini.files")

      -- 自定义文件过滤器
      local filter_hidden = function(entry)
        return not vim.startswith(entry.name, ".")
      end

      -- 添加用户命令
      vim.api.nvim_create_user_command("MiniFiles", function()
        MiniFiles.open()
      end, { desc = "Mini files explorer" })

      vim.api.nvim_create_user_command("MiniFilesCurrent", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end, { desc = "Mini files explorer at current file" })

      vim.api.nvim_create_user_command("MiniFilesCwd", function()
        MiniFiles.open(vim.fn.getcwd())
      end, { desc = "Mini files explorer at cwd" })

      -- 键位映射
      local map = vim.keymap.set
      local opts_desc = { noremap = true, silent = true, desc = "MiniFiles" }

      map("n", "<leader>mf", function() MiniFiles.open() end,
        vim.tbl_extend("force", opts_desc, { desc = "Mini files explorer" }))
      map("n", "<leader>mF", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end,
        vim.tbl_extend("force", opts_desc, { desc = "Mini files at current file" }))
      map("n", "<leader>mc", function() MiniFiles.open(vim.fn.getcwd()) end,
        vim.tbl_extend("force", opts_desc, { desc = "Mini files at cwd" }))

      -- 自定义文件操作
      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          local new_target_window
          vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
            vim.cmd(direction .. " split")
            new_target_window = vim.api.nvim_get_current_win()
          end)
          MiniFiles.set_target_window(new_target_window)
          MiniFiles.go_in({ close_on_file = true })
        end

        local desc = "Open in " .. direction .. " split"
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      -- 在 MiniFiles 窗口中设置映射
      local augroup = vim.api.nvim_create_augroup("mini_files_mapping", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          -- 在垂直/水平分割中打开文件
          map_split(buf_id, "<C-s>", "belowright horizontal")
          map_split(buf_id, "<C-v>", "belowright vertical")
          map_split(buf_id, "<C-t>", "tabnew")
        end,
      })

      -- 文件操作增强
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(args)
          local new_name = args.data.action.new_name
          local old_name = args.data.action.old_name

          -- 如果重命名的是当前缓冲区，更新缓冲区名称
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_name(buf) == old_name then
              vim.api.nvim_buf_set_name(buf, new_name)
              vim.api.nvim_buf_call(buf, function()
                vim.cmd("edit!")
              end)
            end
          end
        end,
      })

      -- 文件创建后自动打开
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionCreate",
        callback = function(args)
          local file_path = args.data.action.path
          local stat = vim.loop.fs_stat(file_path)
          if stat and stat.type == "file" then
            vim.schedule(function()
              vim.cmd("edit " .. file_path)
            end)
          end
        end,
      })
    end,
  },

  -- 文件操作增强（可选）
  {
    "echasnovski/mini.operators",
    optional = true,
    opts = {
      evaluate = { prefix = "g=" },
      exchange = { prefix = "gx" },
      multiply = { prefix = "gm" },
      replace = { prefix = "gr" },
      sort = { prefix = "gs" },
    },
  },
}