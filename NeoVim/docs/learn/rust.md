# Rust 开发环境重构文档

## 概述

本次重构对 Neovim 配置中的 Rust 开发环境进行了重大改进，将原本集中在 `misc.lua` 中的 Rust 相关配置分离到专用模块中，提高了代码的可维护性和组织性。

## 主要变更

### 1. 插件架构重组

#### 原架构
- 所有 Rust 相关插件配置都在 `lua/plugins/misc.lua` 中
- 大量的内联配置使文件变得臃肿
- 难以维护和扩展

#### 新架构
```
lua/
├── plugins/
│   ├── rust.lua          # 专用 Rust 插件配置
│   └── misc.lua          # 清理后的杂项插件
├── config/
│   └── dap.lua           # 调试适配器协议配置
└── init.lua              # 更新以加载新模块
```

### 2. 专用 Rust 配置 (`lua/plugins/rust.lua`)

#### 核心特性
- **rustaceanvim v5**: 升级到最新版本，提供更好的 Rust 支持
- **增强的 LSP 配置**: 包含完整的 rust-analyzer 设置
- **智能调试适配器检测**: 自动选择可用的调试器 (codelldb > lldb-vscode > lldb-dap)
- **优化的内联提示**: 防抖机制，提升性能
- **全面的键位映射**: 保持与原有配置的兼容性

#### 主要插件
1. **rustaceanvim**: 核心 Rust 开发环境
2. **crates.nvim**: Cargo.toml 依赖管理
3. **neotest**: 集成测试框架

### 3. 调试配置模块化 (`lua/config/dap.lua`)

#### 新增功能
- **自动调试适配器配置**: 检测系统可用的调试器
- **DAP UI 集成**: 完整的调试用户界面
- **虚拟文本支持**: 在代码中显示调试信息
- **Mason DAP 集成**: 自动安装调试工具

#### 调试配置
```lua
-- 支持的调试场景
- 启动程序调试
- 附加到进程调试
- 测试调试
- Rust 专用调试快捷键
```

### 4. 依赖更新

#### 新增依赖
- `nvim-nio`: 异步 IO 库
- `nvim-dap-ui`: 调试用户界面
- `nvim-dap-virtual-text`: 调试虚拟文本
- `mason-nvim-dap.nvim`: Mason DAP 集成
- `FixCursorHold.nvim`: 光标保持修复

#### 移除的依赖
- `darcula` 主题
- `edge` 主题
- `papercolor-theme` 主题
- `mini.nvim` 插件集

### 5. 键位映射优化

#### 保留的 Rust 专用键位
```vim
" 调试相关
<leader>dr     - Rust Debuggables
<leader>dR     - Rust Debug Last
<leader>rr     - Rust Runnables
<leader>rR     - Rust Run Last

" 测试相关
<leader>tn     - Test Nearest
<leader>tf     - Test File

" 代码操作
<leader>ca     - Rust Code Actions
<leader>rm     - Expand Macro
<leader>rs     - Structural Search Replace

" Cargo 管理
<leader>ct     - Toggle Crate Versions
<leader>cu     - Upgrade Crate
<leader>cA     - Upgrade All Crates
```

#### 新增调试键位
```vim
" 通用调试
<leader>db     - Toggle Breakpoint
<leader>dB     - Conditional Breakpoint
<leader>dc     - Continue/Start Debug
<leader>di     - Step Into
<leader>do     - Step Over
<leader>dO     - Step Out

" Rust 专用调试
<leader>dt     - Debug Current Test
<leader>dm     - Debug Main Function
<leader>dbp    - Log Breakpoint
```

## 配置详情

### rustaceanvim 增强配置

#### 工具配置
- **悬停操作**: 增强的边框样式和自动焦点控制
- **测试执行器**: 后台执行模式，更好的用户体验
- **Crate 图**: 支持多种 Graphviz 后端
- **代码操作**: 分组图标和 UI 选择回退

#### LSP 服务器设置
- **性能优化**: 独立文件支持关闭，ra-multiplex 启用
- **Cargo 集成**: 全功能启用，输出目录加载优化
- **检查配置**: Clippy 集成，文件级保存检查
- **内联提示**: 全面的类型和生命周期提示
- **补全增强**: 后缀代码片段、自动导入、自动 self

#### 诊断增强
- **透镜功能**: 运行、调试、实现的代码透镜
- **悬停增强**: 内存布局、实现、引用信息
- **语义高亮**: 字符串、标点、语法高亮

### DAP 配置特性

#### 自动适配器检测
```lua
-- 优先级顺序
1. codelldb (推荐)
2. lldb-vscode
3. lldb-dap (回退)
```

#### UI 布局
- **左侧面板**: 作用域、断点、调用栈、监视 (各占 25%)
- **底部面板**: REPL 和控制台 (各占 50%)
- **浮动窗口**: 单边框映射，q/Esc 关闭

#### 虚拟文本配置
- 变量值显示在行尾
- 高亮显示变量变化
- 显示停止原因
- 智能过滤器避免模块噪音

## 性能改进

### 1. 加载优化
- **模块化加载**: Rust 配置仅在 Rust 文件中加载
- **延迟加载**: DAP 组件按需加载
- **依赖优化**: 移除不必要的主题和插件

### 2. 运行时优化
- **防抖内联提示**: 300ms 延迟，避免频繁切换
- **智能文件监视**: 排除 target、.git 等目录
- **错误处理**: 增强的错误恢复机制

### 3. 内存优化
- **条件加载**: 仅在需要时加载调试组件
- **缓存机制**: rust-analyzer 输出目录缓存
- **清理机制**: 自动清理未使用的插件

## 兼容性

### 向后兼容
- 保留所有原有的键位映射
- 维持相同的开发工作流
- 不影响其他语言配置

### 版本要求
- **Neovim**: 0.8+ (推荐 0.10+ 用于完整功能)
- **rust-analyzer**: 自动通过 Mason 安装
- **调试器**: codelldb (推荐) 或 lldb-vscode

## 迁移指南

### 自动迁移
- 配置更改是自动的，无需手动干预
- 现有项目无需修改
- 所有功能保持可用

### 手动配置 (可选)
如需自定义调试器路径：
```lua
-- 在 lua/config/dap.lua 中修改
local debug_adapters = {
  codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = '/path/to/your/codelldb',
      args = { '--port', '${port}' },
    },
  },
}
```

## 故障排除

### 常见问题

#### 1. 调试器未找到
```
解决方案: 安装 codelldb
brew install codelldb  # macOS
或通过 Mason 安装: :MasonInstall codelldb
```

#### 2. Rust LSP 未启动
```
解决方案: 检查 rust-analyzer 安装
:MasonInstall rust-analyzer
:LspRestart
```

#### 3. 内联提示不显示
```
解决方案: 检查 Neovim 版本和配置
:lua print(vim.version().major .. '.' .. vim.version().minor)
需要 0.10+ 版本支持完整功能
```

### 调试命令
```vim
:lua print(vim.inspect(vim.lsp.get_active_clients()))  " 检查 LSP 客户端
:lua require('dap').session()                           " 检查调试会话
:lua print(vim.fn.executable('codelldb'))              " 检查调试器可用性
```

## 未来计划

### 短期目标
- [ ] 添加更多 Rust 主题支持
- [ ] 优化大项目性能
- [ ] 增加更多测试框架支持

### 长期目标
- [ ] 集成 Rust 文档生成工具
- [ ] 添加 Cargo 工作区支持
- [ ] 实现智能代码重构建议

## 总结

这次重构显著改善了 Rust 开发体验：

1. **更好的组织性**: 模块化配置，易于维护
2. **增强的功能**: 更丰富的调试和测试支持
3. **改进的性能**: 优化的加载和运行时性能
4. **更好的用户体验**: 更直观的键位映射和 UI 反馈
5. **向后兼容**: 不影响现有工作流

配置现在更加专业和完整，为 Rust 开发提供了类 IDE 的体验。