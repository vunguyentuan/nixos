-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>q', '<Cmd>q<cr>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- save file with Ctrl + S
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

vim.keymap.set({ 'n', 'i', 'v' }, '<C-c>', 'gcc', { noremap = true, silent = true, desc = 'Toggle comments' })

-- move line
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Diagnostic keymaps
vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>ww', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- track buffers and close unused
local id = vim.api.nvim_create_augroup('startup', {
  clear = false,
})

local persistbuffer = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.fn.setbufvar(bufnr, 'bufpersist', 1)
end

vim.api.nvim_create_autocmd({ 'BufRead' }, {
  group = id,
  pattern = { '*' },
  callback = function()
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'BufModifiedSet' }, {
      buffer = 0,
      once = true,
      callback = function()
        persistbuffer()
      end,
    })
  end,
})

local function closeOtherBuffers()
  local curbufnr = vim.api.nvim_get_current_buf()
  local buflist = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buflist) do
    if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, 'bufpersist') ~= 1) then
      vim.cmd('bd ' .. tostring(bufnr))
    end
  end
end

vim.keymap.set('n', '<leader>bc', function()
  closeOtherBuffers()
end, { silent = true, desc = 'Close unused buffers' })

vim.api.nvim_create_user_command('CloseOtherBuffers', closeOtherBuffers, {
  desc = 'Close other buffers',
})
