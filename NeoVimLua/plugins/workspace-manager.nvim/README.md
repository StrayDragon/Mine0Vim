# Workspace Manager Plugin

一个功能强大的 Neovim 工作区管理插件，提供多工作区切换、状态保存和恢复功能。

## 特性

- 🔄 多工作区切换和管理
- 💾 自动保存工作区状态（包括文件、窗口布局）
- 🔍 FZF 集成的工作区快速选择
- ⌨️ 丰富的键盘快捷键
- 📁 JSON 持久化存储
- 🎯 智能默认工作区创建

## 依赖

- `fzf-lua` - 用于工作区模糊搜索
- `nvim-tree` (可选) - 用于文件树显示

## 安装

使用 lazy.nvim:

```lua
{
  dir = vim.fn.stdpath("config") .. "/lua/plugins/workspace-manager-plugin",
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    require("workspace-manager").setup()
  end,
}
```

## 配置

插件开箱即用，默认设置已配置好所有必要选项。

### 键位映射

| 快捷键 | 功能 |
|--------|------|
| `<Leader>ws` | 切换工作区 |
| `<Leader>wn` | 新建工作区 |
| `<Leader>ww` | 当前目录创建工作区 |
| `<Leader>wd` | 删除工作区 |
| `<Leader>wr` | 重命名当前工作区 |
| `<Leader>wsave` | 保存工作区状态 |
| `<Leader>wf` | 文件移动到新工作区 |

## 工作区数据

工作区数据保存在 `~/.local/share/nvim/workspaces.json`，包含：

- 工作区名称和路径
- 创建和最后访问时间
- 保存的文件和窗口布局
- 当前工作区状态

## 许可证

MIT License