return {
  'stevearc/conform.nvim',
  opts = {},
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'
    conform.setup {
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
      },
    }
    vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
      conform.format()
    end, { desc = 'Format the code' })

    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
