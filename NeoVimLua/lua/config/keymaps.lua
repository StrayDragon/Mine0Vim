-- Keymaps migrated from core/mapping.vim
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- cancel s and S mappings to avoid conflicts with leader+s and leader+S
map({"n","x","o"}, "s", "<nop>")
map({"n","x","o"}, "S", "<nop>")

-- command-line navigation
vim.cmd([[
  cnoremap <c-h> <left>
  cnoremap <c-j> <down>
  cnoremap <c-k> <up>
  cnoremap <c-l> <right>
  cnoremap <c-a> <home>
  cnoremap <c-e> <end>
  cnoremap <c-f> <c-d>
  cnoremap <c-b> <left>
  cnoremap <c-d> <del>
  cnoremap <c-_> <c-k>
]])

-- window switch
map('n', 'gw', '<C-w>w', opts)

-- replace current word
map('n', '<Leader>y', [[:%s/<C-r><C-w>/]], { noremap = true })
-- yank all to clipboard
map('n', '<Leader>Y', [[ggVG"+y<CR><C-o><C-o>]], { noremap = true, silent = true })

-- splits
map('n', '<Leader>SL', ':set splitright<CR>:vsplit<CR>', { noremap = true })
map('n', '<Leader>SH', ':set nosplitright<CR>:vsplit<CR>', { noremap = true })
map('n', '<Leader>SK', ':set nosplitbelow<CR>:split<CR>', { noremap = true })
map('n', '<Leader>SJ', ':set splitbelow<CR>:split<CR>', { noremap = true })

-- move split layout
map('n', '<Leader>Sr', '<C-w>t<C-w>H<Esc>', { noremap = true })
map('n', '<Leader>SR', '<C-w>t<C-w>K<Esc>', { noremap = true })

-- resize
map('n', '<Leader>S<up>', ':resize +4<CR>', { noremap = true })
map('n', '<Leader>S<down>', ':resize -4<CR>', { noremap = true })
map('n', '<Leader>S<left>', ':vertical resize -4<CR>', { noremap = true })
map('n', '<Leader>S<right>', ':vertical resize +4<CR>', { noremap = true })

-- tabs
map('n', '<Leader>TE', ':tabe<CR>', { noremap = true })
map('n', '<Leader>TH', ':tabprevious<CR>', { noremap = true })
map('n', '<Leader>TL', ':tabnext<CR>', { noremap = true })

-- help navigation via quickfix
map('n', '<RIGHT>', ':cnext<CR>', { silent = true })
map('n', '<RIGHT><RIGHT>', ':cnfile<CR><C-G>', { silent = true })
map('n', '<LEFT>', ':cprev<CR>', { silent = true })
map('n', '<LEFT><LEFT>', ':cpfile<CR><C-G>', { silent = true })

-- Toggle inlay hints
vim.keymap.set('n', '<leader>ui', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = false
  if vim.lsp.inlay_hint then
    if vim.lsp.inlay_hint.is_enabled then
      -- Try both signatures for is_enabled
      local ok, val = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
      if not ok then
        ok, val = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
      end
      if ok then enabled = val end
    end
    if enabled then
      -- Try new API: enable(bufnr, false); fallback to old: enable(false, {bufnr=})
      local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, false)
      if not ok then pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr }) end
    else
      local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, true)
      if not ok then pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr }) end
    end
  end
end, { desc = 'Toggle Inlay Hints' })

-- Quick fix (code action) similar to coc.nvim mapping `gq`
vim.keymap.set('n', 'gq', function()
  -- Prefer Quick Fix code actions at cursor
  vim.lsp.buf.code_action({
    context = { only = { 'quickfix' } },
  })
end, { noremap = true, silent = true, desc = 'LSP Quick Fix (Code Action)' })

-- Terminal navigation: Use Esc to exit terminal mode
vim.cmd([[
  " Use Esc to exit terminal mode (like Vim)
  tnoremap <Esc> <C-\><C-N>
]])
