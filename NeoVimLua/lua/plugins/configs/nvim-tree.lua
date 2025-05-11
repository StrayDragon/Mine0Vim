-- NeoVimLua nvim-tree 文件树配置
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("nvim-tree not found!")
  return
end

-- 推荐设置来自nvim-tree文档
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 设置按键映射函数
local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- 默认映射
  api.config.mappings.default_on_attach(bufnr)

  -- 自定义映射
  vim.keymap.set('n', '?',     api.tree.toggle_help,              opts('Help'))
  vim.keymap.set('n', 'l',     api.node.open.edit,                opts('Open'))
  vim.keymap.set('n', 'h',     api.node.navigate.parent_close,    opts('Close Directory'))
  vim.keymap.set('n', 'H',     api.tree.collapse_all,             opts('Collapse All'))
  vim.keymap.set('n', 'L',     api.tree.expand_all,               opts('Expand All'))
end

nvim_tree.setup({
  on_attach = my_on_attach,
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "CMakeLists.txt" },
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$", "^node_modules$", "^.DS_Store$" },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
      },
    },
  },
})

-- 添加快捷键到全局
local wk = require("which-key")

wk.register({
  f = {
    name = "文件",
    t = { "<cmd>NvimTreeToggle<cr>", "切换文件树" },
    o = { "<cmd>NvimTreeFindFile<CR>", "在文件树中定位当前文件" },
  },
}, { prefix = "<leader>" })

-- 创建自动命令：当NvimTree是最后一个窗口时自动关闭
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd "quit"
    end
  end
})