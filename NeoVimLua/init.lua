-- Bridge entrypoint for Neovim
-- Neovim loads this file from ~/.config/nvim/init.lua
-- We delegate to the actual Lua config at lua/init.lua to avoid duplication

local ok, err = pcall(function()
  local cfg = vim.fn.stdpath("config")
  dofile(cfg .. "/lua/init.lua")
end)

if not ok then
  vim.api.nvim_echo({ { "Error loading lua/init.lua: " .. tostring(err), "ErrorMsg" } }, true, {})
end