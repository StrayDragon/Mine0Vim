-- Lazy.nvim 插件管理器引导配置
-- 自动下载并配置 lazy.nvim 插件管理器
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- 如果 lazy.nvim 不存在，则克隆仓库
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    -- 克隆失败时显示错误信息并退出
    vim.api.nvim_echo({
      { "无法克隆 lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\n按任意键退出..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- 将 lazy.nvim 添加到运行时路径
vim.opt.rtp:prepend(lazypath)