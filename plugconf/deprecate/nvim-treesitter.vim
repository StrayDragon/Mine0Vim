lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,                    -- false will disable the whole extension
        disable = { 'c', 'rust' },        -- list of language that will be disabled
    },
    incremental_selection = {
        enable = true,
        disable = { 'cpp', 'lua' },
        keymaps = {                       -- mappings for incremental selection (visual mappings)
          init_selection = 'gzz',         -- maps in normal mode to init the node/scope selection
          node_incremental = "gzn",       -- increment to the upper named parent
          scope_incremental = "gzs",      -- increment to the upper scope (as defined in locals.scm)
          node_decremental = "gzd",      -- decrement to the previous node
        }
    },
    ensure_installed = 'all' -- one of 'all', 'language', or a list of languages
}
EOF
