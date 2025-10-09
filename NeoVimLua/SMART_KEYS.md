# 智能键位覆盖引擎使用指南

## 概述

智能键位覆盖引擎是一个上下文感知的键位映射系统，它允许相同的按键序列在不同场景下调用不同的实现。这符合您的要求："一套标准按键在不同场景虽然按键序列一样但是对应实现不一样"。

## 核心特性

### 1. 上下文感知路由
- 根据文件类型、项目类型、可用工具等上下文信息智能选择处理器
- 支持多模式键位映射（普通、视觉、插入、终端等）
- 优先级系统确保正确的处理器被选中

### 2. 语言特定支持
- **Rust**: 完整的 rust-analyzer 集成、Cargo 操作、调试支持
- **Python**: 代码动作、测试运行、脚本执行
- **Lua**: Neovim 特定配置支持
- **JavaScript/TypeScript**: 现代前端开发支持
- **Go/C++/Java**: 预定义的编译和运行支持

### 3. 冲突检测与解决
- 自动检测键位冲突
- 多种冲突解决策略（智能替换、条件替换、上下文感知）
- 冲突报告生成器

### 4. 扩展框架
- 简单的语言扩展注册系统
- 工具扩展支持
- 代码生成器帮助创建新扩展

## 核心组件

### 1. 智能路由核心 (`config/smart-keys.lua`)
- 上下文检测器
- 处理器注册表
- 智能键映射创建器

### 2. 语言扩展 (`config/smart-keys-languages.lua`)
- 语言特定处理器
- 预定义的语言支持
- 语言感知键映射

### 3. 冲突解决 (`config/smart-keys-conflict.lua`)
- 冲突检测系统
- 解决策略
- 冲突报告生成器

### 4. 多模式支持 (`config/smart-keys-multi.lua`)
- 多模式键映射
- 模式特定处理器
- 增强上下文检测

### 5. 扩展框架 (`config/smart-keys-framework.lua`)
- 扩展注册系统
- 代码生成器
- 预定义扩展

## 使用示例

### 基本使用

系统会自动根据当前上下文选择合适的处理器：

```lua
-- 在 Rust 文件中按 <leader>a
-- 自动使用 rust-analyzer 的代码动作
vim.cmd.RustLsp('codeAction')

-- 在 Python 文件中按 <leader>a
-- 使用标准的 LSP 代码动作
vim.lsp.buf.code_action()

-- 在任何文件中按 <leader>f
-- 根据文件类型选择适当的格式化器
```

### 用户命令

系统提供了多个有用的用户命令：

```vim
:SmartKeyStatus          -- 显示智能键位系统状态
:SmartKeyRefresh         -- 刷新智能键位系统
:SmartKeyLanguages       -- 显示语言支持状态
:SmartKeyMultiMode       -- 显示多模式支持状态
:SmartKeyExtensions      -- 显示扩展框架状态
:SmartKeyConflictReport  -- 显示冲突报告
:SmartKeySafeSuggest     -- 获取安全键位建议
:SmartKeyGenerateExtension <name>  -- 生成扩展代码
```

### 创建自定义扩展

#### 1. 语言扩展示例

```lua
-- 创建新的语言扩展
local my_extension = {
  name = 'mylang',
  description = 'My Language 扩展',
  filetypes = { 'mylang' },
  priority = 90,

  handlers = {
    {
      name = 'mylang_compile',
      priority = 90,
      description = 'My Language 编译',
      modes = { 'n' },
      match_conditions = function(context)
        return context.filetype == 'mylang'
      end,
      execute = function()
        vim.cmd('!mylang-compiler %')
      end,
    },
  },

  keymaps = {
    {
      keys = '<leader>cb',
      description = 'My Language 编译',
      modes = { 'n' },
    },
  },

  init = function()
    vim.notify('My Language 扩展已初始化', vim.log.levels.INFO)
  end,
}

-- 注册扩展
require('config.smart-keys-framework').load_extension(my_extension)
```

#### 2. 工具扩展示例

```lua
-- 创建新的工具扩展
local my_tool = {
  name = 'mytool',
  description = 'My Tool 扩展',

  check_availability = function()
    return vim.fn.executable('mytool') == 1
  end,

  handlers = {
    {
      name = 'mytool_action',
      priority = 85,
      description = 'My Tool 操作',
      modes = { 'n' },
      match_conditions = function(context)
        return true -- 适用于所有文件类型
      end,
      execute = function()
        vim.cmd('!mytool %')
      end,
    },
  },

  init = function()
    vim.notify('My Tool 扩展已初始化', vim.log.levels.INFO)
  end,
}

-- 注册扩展
require('config.smart-keys-framework').load_extension(my_tool)
```

## 键位映射示例

### 1. 代码动作 (`<leader>a`)
- **Rust 文件**: 使用 rust-analyzer 的分组代码动作
- **其他文件**: 使用 tiny-code-action 或标准 LSP 代码动作
- **视觉模式**: 对选中文本执行代码动作

### 2. 格式化 (`<leader>f`)
- **Rust 文件**: 使用 rust-analyzer 格式化
- **其他文件**: 使用标准 LSP 格式化
- **视觉模式**: 格式化选中区域

### 3. 测试 (`<leader>tt`)
- **Rust 文件**: 使用 neotest 运行测试
- **Python 文件**: 使用 pytest 运行测试
- **JavaScript 文件**: 使用 npm test 运行测试

### 4. 运行 (`<leader>rr`)
- **Rust 文件**: 执行 cargo build
- **Python 文件**: 执行 python 脚本
- **C/C++ 文件**: 编译并运行

## 上下文检测

系统会检测以下上下文信息：

### 文件类型
- `vim.bo.filetype` - 当前文件类型

### 项目类型
- 自动检测项目根目录的配置文件
- Python: `pyproject.toml`, `requirements.txt`
- Rust: `Cargo.toml`
- Node.js: `package.json`
- Lua: `init.lua`

### 可用工具
- `rust-analyzer` - Rust LSP 服务器
- `tiny-code-action` - 增强代码动作 UI
- `dap` - 调试适配器协议
- `neotest` - 测试框架

### 光标位置
- 当前行和列
- 光标前后的文本
- 是否在单词边界

### 缓冲区状态
- 是否已修改
- 是否只读
- 缓冲区类型
- 文件大小

## 冲突解决

系统提供多种冲突解决策略：

### 1. 智能替换
基于优先级的自动替换

### 2. 条件替换
根据上下文条件决定是否替换

### 3. 多模式共存
在不同模式下使用不同的处理器

### 4. 上下文感知
基于上下文动态选择处理器

## 性能优化

- 延迟初始化
- 缓存上下文信息
- 优先级排序
- 防抖处理

## 故障排除

### 常见问题

1. **键位映射不工作**
   - 使用 `:SmartKeyStatus` 检查系统状态
   - 使用 `:SmartKeyConflictReport` 检查冲突

2. **语言扩展不工作**
   - 使用 `:SmartKeyLanguages` 检查语言支持
   - 确认文件类型正确

3. **处理器选择错误**
   - 检查处理器优先级
   - 验证匹配条件

### 调试命令

```vim
:messages                    -- 查看消息日志
:verbose map <leader>a       -- 查看键位映射详情
:lua print(vim.inspect(require('config.smart-keys').get_current_context()))  -- 查看当前上下文
```

## 扩展开发

### 创建新语言扩展

1. 使用 `:SmartKeyGenerateExtension <language>` 生成模板
2. 修改生成的代码以适配您的语言
3. 使用 `require('config.smart-keys-framework').load_extension(extension)` 注册

### 创建新工具扩展

1. 定义工具检测函数
2. 实现处理器
3. 注册扩展

## 贡献指南

欢迎贡献新的语言扩展和工具扩展！

1. Fork 项目
2. 创建您的扩展
3. 测试兼容性
4. 提交 Pull Request

---

## 版本信息

- **版本**: 1.0.0
- **兼容性**: Neovim 0.11+
- **依赖**: lazy.nvim, which-key.nvim (可选)

**享受智能键位覆盖引擎带来的便利！** 🚀