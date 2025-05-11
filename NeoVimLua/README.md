# NeoVimLua

基于Lua的现代Neovim配置框架

## 要求

- Neovim >= 0.8.0
- Git
- 一个Nerd Font字体 (推荐: [JetBrains Mono Nerd Font](https://www.nerdfonts.com/))
- (可选) ripgrep - 用于更好的搜索体验
- (可选) fd - 用于更好的文件查找

## 安装

### 备份现有配置

```bash
# 备份现有的Neovim配置
mv ~/.config/nvim ~/.config/nvim.bak
```

### 安装NeoVimLua

```bash
# 克隆仓库到Neovim配置目录
git clone <THIS_REPO> ~/.config/nvim
```


首次启动Neovim时，它会自动安装lazy.nvim插件管理器
- 使用 :Lazy sync 安装所有配置的插件
- 使用 :Mason 安装需要的LSP服务器

## 目录结构

```
~/.config/nvim/
├── lua/                    # Lua配置文件
│   ├── core/               # 核心配置
│   │   ├── autocmds.lua    # 自动命令
│   │   ├── colorscheme.lua # 配色方案
│   │   ├── keymaps.lua     # 按键映射
│   │   └── options.lua     # Neovim选项
│   ├── lsp/                # LSP配置
│   │   ├── cmp.lua         # 补全配置
│   │   ├── handlers.lua    # LSP处理函数
│   │   ├── init.lua        # LSP入口
│   │   ├── mason.lua       # Mason配置
│   │   └── servers.lua     # LSP服务器配置
│   ├── plugins/            # 插件配置
│   │   ├── configs/        # 各插件详细配置
│   │   └── init.lua        # 插件列表和基本配置
│   ├── init.lua            # 主入口文件
│   └── user_config.lua     # 用户自定义配置(可选)
└── snippets/               # 代码片段
```

## 自定义配置

1. 复制示例用户配置文件:
```bash
cp ~/.config/nvim/lua/user_config.lua.example ~/.config/nvim/lua/user_config.lua
```

2. 根据个人喜好编辑 `user_config.lua`

## 主要功能

- 现代UI和配色方案
- 完整的LSP支持
- 智能代码补全
- 语法高亮和代码折叠
- 文件树和模糊查找
- Git集成
- 终端集成
- 代码运行器

## 按键映射

查看 `lua/core/keymaps.lua` 获取完整的按键映射列表。

主要按键映射:

- `,` - Leader键
- `<Space>` - LocalLeader键
- `<Leader>ff` - 查找文件
- `<Leader>fg` - 查找文本
- `<Leader>e` - 打开文件浏览器
- `<Leader>t` - 打开终端
- `<Leader>lf` - 格式化代码

## 插件列表

查看 `lua/plugins/init.lua` 获取完整的插件列表和配置。

## 问题排查

如果遇到问题:

1. 确保Neovim版本 >= 0.8.0
2. 运行 `:checkhealth` 检查系统状态
3. 尝试使用 `:Lazy sync` 更新所有插件
