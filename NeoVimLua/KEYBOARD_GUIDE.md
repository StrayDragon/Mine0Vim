# NeoVim Lua 键盘操作指南

## 🎯 核心导航

### 基础移动
- `h`/`j`/`k`/`l` - 左/下/上/右移动
- `w`/`W` - 下一个单词（小写/大写单词）
- `b`/`B` - 上一个单词（小写/大写单词）
- `e`/`E` - 单词末尾（小写/大写单词）
- `0`/`$` - 行首/行尾
- `gg`/`G` - 文件开头/结尾
- `f{char}`/`t{char}` - 查找字符/在字符前
- `;`/`,` - 重复/反向查找

### 窗口管理
- `gw` - 切换窗口
- `<Leader>S<direction>` - 调整窗口大小（上下左右）
- `<Leader>SL` - 右侧垂直分割
- `<Leader>SH` - 左侧垂直分割
- `<Leader>SK` - 上方水平分割
- `<Leader>SJ` - 下方水平分割
- `<Leader>Sr` - 旋转窗口布局
- `<Leader>SR` - 翻转窗口布局

### 标签页管理
- `<Leader>TE` - 新建标签页
- `<Leader>TH` - 上一个标签页
- `<Leader>TL` - 下一个标签页

## 🔍 搜索与替换

### 基础搜索
- `/pattern` - 向下搜索
- `?pattern` - 向上搜索
- `*`/`#` - 搜索当前单词（向下/向上）
- `n`/`N` - 下一个/上一个搜索结果
- `:%s/old/new/g` - 全局替换
- `:%s/old/new/gc` - 全局替换（确认）

### 高级搜索
- `<leader>y` - 替换当前单词
- `gd` - 跳转到定义
- `gy` - 跳转到类型定义
- `gi` - 跳转到实现
- `gr` - 查找引用

## ✏️ 编辑操作

### 基础编辑
- `i`/`I` - 插入模式（当前位置/行首）
- `a`/`A` - 插入模式（下一个字符/行尾）
- `o`/`O` - 新建行（下方/上方）
- `c`/`d`/`y` - 修改/删除/复制（配合移动命令）
- `p`/`P` - 粘贴（之后/之前）
- `u`/`Ctrl-r` - 撤销/重做
- `.` - 重复上一个命令

### 块操作
- `v`/`V`/`Ctrl-v` - 字符/行/块可视化模式
- `>`/`<` - 缩进/反缩进
- `=` - 自动格式化

### 代码操作
- `gc`/`gcc` - 注释行/块
- `gs` - 循环替换（true/false 等）
- `Ctrl-s` - Treesitter 增量选择

## 🚀 LSP 功能

### 代码导航
- `gd` - 跳转到定义
- `gy` - 跳转到类型定义
- `gi` - 跳转到实现
- `gr` - 查找引用
- `K` - 悬停文档

### 代码操作
- `<leader>rn` - 重命名符号
- `<leader>a` - 代码动作
- `gq` - 快速修复
- `<leader>f` - 格式化代码

### 诊断导航
- `g[`/`g]` - 上一个/下一个诊断
- `<space>e` - 浮动诊断窗口
- `<space>d` - 诊断列表（Telescope）

### 命令与符号
- `<space>c` - 命令列表
- `<space>s` - 文档符号
- `<space>S` - 工作区符号
- `<space>o` - 大纲视图

## 🦀 Rust 专用功能 (rustaceanvim)

### 🚀 核心运行与调试
- `K` - Rust 悬停操作（推荐，包含快速操作菜单）
- `<leader>rr` - Rust 运行目标选择器
- `<leader>rR` - 重新运行上次的可执行文件
- `<leader>dr` - Rust 调试目标选择器
- `<leader>dR` - 重新调试上次的目标

### 🔧 代码分析与操作
- `<leader>ca` - Rust 代码动作（分组支持）
- `<leader>a` - 标准代码动作（带分组）
- `<leader>ra` - 执行悬停操作（快速访问）
- `<leader>gs` - 结构化搜索替换 (SSR)
- `<leader>rd` - 渲染诊断（cargo build 风格）
- `<leader>re` - 解释错误（rust 错误代码索引）
- `<leader>gq` - 相关诊断导航
- `<leader>gj` - 连接行（智能空白处理）

### 📁 文件与项目导航
- `<leader>ro` - 打开 Cargo.toml
- `<leader>K` - 打开 docs.rs 文档
- `<leader>rp` - 父模块导航
- `<space>s` - 工作区符号搜索
- `<space>S` - 工作区所有符号（包含依赖）

### 🎯 代码操作与重构
- `<leader>gi` - 向上移动代码项
- `<leader>gk` - 向下移动代码项

### 📊 高级功能
- `<leader>cg` - Crate 依赖图（需要 graphviz）
- `<leader>cs` - 语法树视图
- `<leader>rh` - 悬停范围

### 🔍 背景检查（Fly Check）
- `<leader>cc` - 运行后台 cargo check
- `<leader>cC` - 清除 fly check 诊断
- `<leader>cX` - 取消 fly check

### 🔬 Rustc 命令（需要 nightly 编译器）
- `<leader>rhb` - Rustc HIR 视图
- `<leader>rbm` - Rustc MIR 视图

### 📦 Cargo 管理（crates.nvim）
- `<leader>ct` - 切换 crate 版本显示
- `<leader>cu` - 升级当前 crate
- `<leader>cA` - 升级所有 crates
- `<leader>cr` - 重新加载 crates 配置

### 🧪 测试（vim-test 兼容）
- `<leader>tn` - 测试最近函数
- `<leader>tf` - 测试当前文件
- `<leader>ts` - 测试整个套件
- `<leader>tl` - 重新运行上次测试

## 📁 文件管理

### 文件浏览
- `Ctrl-1` - 切换 neo-tree 文件浏览器
- `Ctrl-3` - 切换撤销树
- `Ctrl-g` - Git 命令

### 多光标
- `Ctrl-d` - 添加下一个匹配项
- `Ctrl-c` - 跳过当前匹配项

### 可视化拖拽
- `←`/`→`/`↑`/`↓` - 拖拽选择（仅可视化模式）
- `D` - 复制选择

## ⚡ 快速菜单

### 意图动作
- `Ctrl-Enter` - 显示上下文菜单
- `Ctrl-CR` - 显示意图动作（JetBrains 风格）
- `Ctrl-t` - 重构菜单（JetBrains Ctrl+T）

### 重构快捷键
- `<leader>re` - 提取函数
- `<leader>rf` - 提取到文件
- `<leader>rv` - 提取变量
- `<leader>ri` - 内联变量
- `<leader>rI` - 内联函数
- `<leader>rb` - 提取块
- `<leader>rbf` - 提取块到文件
- `<leader>rr` - 重构菜单

## 🔧 终端与工具

### 终端操作
- `floatty` - 浮动终端（通过插件）
- `asyncrun` - 异步运行命令
- `asynctasks` - 任务管理

### 其他工具
- `Ctrl-l` - 清屏（终端模式下）

## 🎨 界面与主题

### 状态栏
- `lightline.vim` - 状态栏信息显示

### 主题切换
- PaperColor（亮色主题）
- edge（暗色主题）

### 代码高亮
- Treesitter 自动语法高亮
- Inlay hints 实时类型提示

## 📋 使用技巧

### 1. 高效导航模式
```vim
" 快速定位到定义
gd           # 跳转到定义
Ctrl-o       # 返回之前位置
Ctrl-i       # 前进到下一个位置
```

### 2. 批量编辑流程
```vim
" 多光标编辑
Ctrl-d       # 选择下一个匹配项
编辑内容
Esc          # 退出多光标模式
```

### 3. 代码重构流程
```vim
" 重构步骤
Ctrl-t       # 打开重构菜单
选择重构类型
确认操作
```

### 4. Rust 开发流程
```vim
" 日常 Rust 开发
编辑代码
<leader>f    # 格式化
<leader>tn   # 测试函数
<leader>ca   # 查看代码动作
```

## 🔥 高级技巧

### 1. 组合键使用
- `<leader>` + 快捷键 = 空格键 + 其他键
- `Ctrl-组合键` 适合常用操作
- 使用 `vim.keymap.set` 自定义映射

### 2. 模式切换技巧
- `i` -> `Esc` -> `:` -> 命令模式
- `v` -> 可视化模式 -> 编辑 -> `Esc`
- 保持在普通模式，减少模式切换

### 3. LSP 高效使用
- 先 `K` 查看文档
- 再 `gd` 跳转定义
- 最后 `gr` 查看引用
- 使用 `<space>e` 查看详细错误

### 4. 常用操作序列
```vim
" 快速修改函数名
ciw          # 修改单词
输入新名字
<leader>rn   # LSP 重命名
```

这个键盘指南涵盖了您配置中的所有主要功能，按功能分类组织，便于日常使用和参考。