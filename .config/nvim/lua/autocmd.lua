-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
--   group = highlight_group,
--   pattern = '*',
-- })

-- run linter
vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
  callback = function()
    local lint_status, lint = pcall(require, 'lint')
    if lint_status then
      lint.try_lint()
    end
  end,
})
