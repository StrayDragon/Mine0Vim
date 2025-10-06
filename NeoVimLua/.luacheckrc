-- Luacheck configuration for Neovim
globals = {
    "vim",
    "describe",
    "it",
    "before_each",
    "after_each",
    "assert",
    "packer_plugins",
}

-- Ignore unused self arguments in methods
self = false

-- Ignore some common patterns
ignore = {
    "631", -- variable is unused but set
    "211", -- unused variable
}