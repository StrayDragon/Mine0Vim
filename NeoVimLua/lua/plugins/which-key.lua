-- Which-Key.nvim 智能配置 - 自动发现现有键位映射
-- 解决键位映射记忆问题，避免维护两套配置

-- 前缀分组配置
local prefix_groups = {
  ["<leader>f"] = "文件", ["<leader>e"] = "编辑", ["<leader>v"] = "视图",
  ["<leader>g"] = "Git", ["<leader>s"] = "搜索", ["<leader>l"] = "LSP", ["<leader>t"] = "测试",
  ["<leader>D"] = "调试", ["<leader>d"] = "诊断", ["<leader>b"] = "缓冲区", ["<leader>w"] = "窗口",
  ["<leader>c"] = "代码", ["<leader>r"] = "Rust",
  ["<leader>u"] = "工具", ["<leader>o"] = "选项", ["<leader>S"] = "大小调整",
  ["<leader>T"] = "标签页", ["<leader>h"] = "帮助", ["<space>"] = "Space",
  ["g"] = "g 前缀", ["["] = "上一个", ["]"] = "下一个",
}

-- 特殊键位映射
local special_mappings = {
  ["gd"] = "跳转到定义", ["gr"] = "查找引用", ["gi"] = "跳转到实现",
  ["gy"] = "跳转到类型定义", ["K"] = "悬停帮助", ["gq"] = "快速修复",
  ["g["] = "上一个诊断", ["g]"] = "下一个诊断", ["gw"] = "切换窗口",
}

-- 常见 Leader 键描述（自动补全用）
local common_descriptions = {
  ["<leader>ff"] = "查找文件", ["<leader>fg"] = "全局搜索", ["<leader>fb"] = "查找缓冲区",
  ["<leader>fh"] = "帮助文档", ["<leader>fo"] = "最近文件", ["<leader>ca"] = "代码动作", ["<leader>ra"] = "Rust代码动作",
  ["<leader>rn"] = "重命名", ["<leader>cf"] = "格式化", ["<leader>cd"] = "诊断信息",
  ["<leader>ui"] = "切换内联提示", ["<leader>gs"] = "Git 状态", ["<leader>gc"] = "Git 提交",
  ["<leader>gp"] = "推送", ["<leader>gl"] = "日志", ["<leader>gd"] = "差异",
  ["<leader>tn"] = "测试函数", ["<leader>tf"] = "测试文件(neotest)", ["<leader>ts"] = "测试套件(neotest)",
  ["<leader>tT"] = "测试函数(rust)", ["<leader>tC"] = "测试文件(cargo)", ["<leader>tA"] = "测试套件(cargo)",
  ["<space>f"] = "查找文件", ["<space>g"] = "全局搜索", ["<space>s"] = "符号列表",
  ["<space>o"] = "大纲视图", ["<space>c"] = "命令面板",
}

-- 插件内部映射排除模式
local exclude_patterns = {"^<Plug>", "^<SNR>", "^<Cmd>", "^<C%-", "^<Tab>", "^<A%-", "^<S%-"}

-- 支持的模式
local modes = {"n", "v", "x", "s", "o"}

-- 统一过滤规则：排除不需要显示的映射
local function should_exclude(mapping)
  -- 空键位排除
  if not mapping.lhs or mapping.lhs == "" then return true end

  -- 无描述且非特殊映射的排除
  if not mapping.desc or mapping.desc == "" then
    return not special_mappings[mapping.lhs]
  end

  -- 插件内部映射排除
  for _, pattern in ipairs(exclude_patterns) do
    if mapping.lhs:match(pattern) then return true end
  end

  -- 单字母模式映射排除
  if mapping.lhs:match("^[nvsicot]$") then return true end

  -- Which-Key 自身排除
  if mapping.desc:match("^Which%-Key") then return true end

  -- 排除一些可能被错误分类的映射
  if mapping.desc:match("^Telescope") or mapping.desc:match("^Neo") or
     mapping.desc:match("^LSP") or mapping.desc:match("^Format") then
    -- 只排除不属于我们定义前缀的映射
    local has_valid_prefix = false
    for prefix, _ in pairs(prefix_groups) do
      if mapping.lhs:match("^" .. vim.pesc(prefix)) then
        has_valid_prefix = true
        break
      end
    end
    if not has_valid_prefix and not special_mappings[mapping.lhs] then
      return true
    end
  end

  return false
end

-- 生成描述信息
local function generate_description(lhs)
  if not lhs then return nil end

  -- Leader 键映射
  if lhs:match("^<leader>") and #lhs > 9 then
    local key = lhs:sub(10)
    local descriptions = {
      f = "文件操作", e = "编辑操作", v = "视图操作", g = "Git操作", l = "LSP操作",
      t = "测试操作", d = "调试操作", b = "缓冲区操作", w = "窗口操作",
      s = "搜索操作", c = "代码操作", r = "Rust操作", u = "工具操作",
      o = "选项操作", h = "帮助操作", ff = "查找文件", fg = "全局搜索",
      fb = "查找缓冲区", ca = "代码动作", ra = "Rust代码动作", rn = "重命名", cf = "格式化",
      ui = "切换内联提示", gs = "Git 状态", gc = "Git 提交", gp = "推送",
      gl = "日志", gd = "差异", tn = "测试函数", tf = "测试文件", ts = "测试套件",
      tT = "测试函数(rust)", tC = "测试文件(cargo)", tA = "测试套件(cargo)", tt = "运行最近测试", tl = "运行上次测试",
    }
    return descriptions[key] or ("Leader " .. key)
  end

  -- 空格键映射 - 只处理明确的空格键映射
  if lhs:match("^<space>") and #lhs > 7 then
    local key = lhs:sub(8)
    local space_descriptions = {
      f = "查找文件", g = "全局搜索", s = "符号列表", o = "大纲视图", c = "命令面板",
    }
    return space_descriptions[key] or ("Space " .. key)
  end

  -- 特殊映射
  return special_mappings[lhs]
end

-- 自动发现并注册所有键位映射
local function auto_discover_mappings()
  local wk = require("which-key")
  local registered = {}
  local count = 0

  -- 注册分组
  for prefix, name in pairs(prefix_groups) do
    wk.add({ { prefix, group = name } })
    registered[prefix] = true
  end

  -- 注册特殊映射
  for key, desc in pairs(special_mappings) do
    wk.add({ { key, desc = desc } })
    registered[key] = true
    count = count + 1
  end

  -- 扫描所有模式的映射
  for _, mode in ipairs(modes) do
    for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
      if not should_exclude(mapping) and not registered[mapping.lhs] then
        local desc = mapping.desc or generate_description(mapping.lhs) or common_descriptions[mapping.lhs]
        if desc then
          wk.add({ { mapping.lhs, desc = desc, mode = mode } })
          registered[mapping.lhs] = true
          count = count + 1
        end
      end
    end
  end

  return count
end

-- 创建用户命令
local function create_commands()
  vim.api.nvim_create_user_command("WhichKeyRefresh", function()
    local count = auto_discover_mappings()
    vim.notify("Which-Key 已刷新，发现 " .. count .. " 个快捷键", vim.log.levels.INFO)
  end, { desc = "刷新 Which-Key 键位映射" })

  vim.api.nvim_create_user_command("WhichKeyStats", function()
    local stats = {}
    local total = 0

    for _, mode in ipairs(modes) do
      local mode_mappings = vim.api.nvim_get_keymap(mode)
      local valid = 0
      for _, mapping in ipairs(mode_mappings) do
        if not should_exclude(mapping) then valid = valid + 1 end
      end
      stats[mode] = valid
      total = total + valid
    end

    local lines = {"=== 快捷键统计 ===", "", string.format("总计: %d 个快捷键", total), ""}
    for mode, count in pairs(stats) do
      local mode_names = {n = "普通", v = "视觉", x = "选择", s = "选择", o = "操作"}
      table.insert(lines, string.format("  %-6s模式: %3d 个", mode_names[mode] or mode, count))
    end

    table.insert(lines, "")
    table.insert(lines, "提示: 使用 <leader> 查看可用映射")

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor", width = 40, height = #lines + 2,
      col = math.floor((vim.o.columns - 40) / 2),
      row = math.floor((vim.o.lines - #lines - 2) / 2),
      style = "minimal", border = "rounded", title = "快捷键统计"
    })

    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", {})
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", {})
  end, { desc = "显示快捷键统计" })
end

-- 提供全局注册函数供其他插件使用
local function setup_global_functions()
  vim.g.which_key_register = function(keys, desc, mode)
    require("which-key").add({ { keys, desc = desc, mode = mode or "n" } })
  end
end

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = function(ctx) return ctx.plugin and 100 or 200 end,

      -- 过滤器：复用统一的过滤逻辑
      filter = function(mapping)
        -- 转换为 should_exclude 函数期望的格式
        local mock_mapping = {
          lhs = mapping.lhs or mapping.key,
          desc = mapping.desc
        }
        return not should_exclude(mock_mapping)
      end,

      -- 显示设置
      show_help = true, show_keys = true, show_icons = true,

      -- 窗口设置
      win = { border = "rounded", padding = {1, 2}, title = true, title_pos = "center", wo = { winblend = 10 } },

      -- 布局设置
      layout = { width = { min = 20, max = 50 }, spacing = 3, align = "left" },

      -- 图标设置
      icons = { rules = false, colors = true, keys = {
        Up = " ", Down = " ", Left = " ", Right = " ",
        C = "󰘴 ", M = "󰘵 ", D = "󰘳 ", S = "󰘶 ",
        CR = "󰌑 ", Esc = "󱊷 ", Space = "󱁐 ", Tab = "󰌒 ",
      }},

      -- 触发器设置 - 只为明确分组的键位显示
      triggers = {
        {"<leader>", mode = {"n", "v"}},
        {"g", mode = "n"}, {"[", mode = "n"}, {"]", mode = "n"},
      },
    },

    -- 键位映射
    keys = {
      {"<leader>?", function() require("which-key").show({ global = false }) end, desc = "缓冲区本地映射"},
      {"<leader>hs", function() vim.cmd("WhichKeyStats") end, desc = "快捷键统计"},
    },

    -- 初始化配置
    config = function(_, opts)
      local which_key = require("which-key")

      -- 延迟初始化
      vim.schedule(function()
        which_key.setup(opts)
        local count = auto_discover_mappings()
        create_commands()
        setup_global_functions()
        vim.notify("Which-Key 已启用！发现 " .. count .. " 个快捷键", vim.log.levels.INFO)
      end)
    end,
  },
}