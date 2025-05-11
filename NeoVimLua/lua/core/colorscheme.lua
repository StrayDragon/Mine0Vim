-- NeoVimLua 颜色主题配置

local colorscheme = "tokyonight"

local function set_colorscheme(name)
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. name)
    if not status_ok then
        vim.notify("找不到颜色主题: " .. name, vim.log.levels.WARN)
        -- 回退到内置主题
        vim.cmd("colorscheme habamax")
        return
    end

    -- 主题后额外设置
    if name == "tokyonight" then
        -- 增强一些UI元素的可见度
        vim.cmd([[
            hi CursorLine guibg=#2a2e36
            hi Visual guibg=#2d3640
        ]])
    end
end

-- 尝试设置主题
set_colorscheme(colorscheme)

-- 设置一些全局的高亮样式，确保与主题兼容
vim.cmd([[
    hi CursorLineNr guifg=#a9b1d6
    hi Comment gui=italic
    hi Search guibg=#3b4252 guifg=#f1fa8c gui=bold
]])

-- 透明背景设置
local transparent_background = false
if transparent_background then
    vim.cmd([[
        hi Normal guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi EndOfBuffer guibg=NONE ctermbg=NONE
    ]])
end