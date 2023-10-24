return {
  'echasnovski/mini.nvim',
  version = false,
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    local keymap = vim.api.nvim_set_keymap

    local win_config = function()
      local height = math.floor(0.618 * vim.o.lines)
      local width = math.floor(0.618 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
        -- border = 'none',
      }
    end

    -- require('mini.base16').setup {
    --   palette = {
    --     base00 = '#1d2021',
    --     base01 = '#3c3836',
    --     base02 = '#504945',
    --     base03 = '#665c54',
    --     base04 = '#bdae93',
    --     base05 = '#d5c4a1',
    --     base06 = '#ebdbb2',
    --     base07 = '#fbf1c7',
    --     base08 = '#fb4934',
    --     base09 = '#fe8019',
    --     base0A = '#fabd2f',
    --     base0B = '#b8bb26',
    --     base0C = '#8ec07c',
    --     base0D = '#83a598',
    --     base0E = '#d3869b',
    --     base0F = '#d65d0e',
    --   },
    -- }

    require('mini.basics').setup {
      options = {
        extra_ui = true,
        win_borders = 'double',
      },
      mappings = {
        windows = true,
      },
    }

    require('mini.statusline').setup {
      user_icons = true,
    }

    require('mini.move').setup()
    require('mini.indentscope').setup {
      draw = {
        animation = function(s, n)
          return 5
        end,
      },
      symbol = '│',
    }
    require('mini.pairs').setup()
    require('mini.pick').setup {
      options = {
        use_cache = true,
      },
      mappings = {
        move_down = '<C-j>',
        move_up = '<C-k>',
      },
      window = {
        config = win_config,
      },
    }

    keymap('n', '<leader>f', '<cmd>lua MiniPick.builtin.files()<cr>', { noremap = true, silent = true, desc = 'Find File' })
    -- keymap('n', '<leader>fm', '<cmd>lua MiniFiles.open()<cr>', { noremap = true, silent = true, desc = 'Find Manualy' })
    keymap('n', '<leader><space>', '<cmd>lua MiniPick.builtin.buffers()<cr>', { noremap = true, silent = true, desc = 'Find Buffer' })
    keymap('n', '<leader>ss', '<cmd>lua MiniPick.builtin.grep_live()<cr>', { noremap = true, silent = true, desc = 'Find String' })

    -- keymap('n', '<leader>ss', '<cmd>lua MiniSessions.select()<cr>', { noremap = true, silent = true, desc = 'Switch Session' })

    require('mini.sessions').setup {
      autowrite = true,
    }
    --
    -- require('mini.starter').setup {
    --   header = '███╗   ███╗██╗   ██╗██╗███╗   ███╗\n████╗ ████║██║   ██║██║████╗ ████║\n██╔████╔██║██║   ██║██║██╔████╔██║\n██║╚██╔╝██║╚██╗ ██╔╝██║██║╚██╔╝██║\n██║ ╚═╝ ██║ ╚████╔╝ ██║██║ ╚═╝ ██║\n╚═╝     ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝\n                                  ',
    -- }

    require('mini.surround').setup()
    -- require('mini.tabline').setup()

    local minifiles = require 'mini.files'
    minifiles.setup {
      mappings = {
        go_in = 'L',
        go_in_plus = 'l',
        go_out = 'H',
        go_out_plus = 'h',
        show_help = '?',
        synchronize = '<cr>',
      },
      windows = {
        preview = true,
        width_preview = 80,
      },
    }
    vim.keymap.set('n', '<C-n>', function()
      if not minifiles.close() then
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end
      -- minifiles.open(vim.api.nvim_buf_get_name(-1))
    end, { desc = 'Open files' })

    require('mini.surround').setup {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        add = '<leader>sa', -- Add surrounding in Normal and Visual modes
        delete = '<leader>sd', -- Delete surrounding
        find = '<leader>sf', -- Find surrounding (to the right)
        find_left = '<leader>sF', -- Find surrounding (to the left)
        highlight = '<leader>sh', -- Highlight surrounding
        replace = '<leader>sr', -- Replace surrounding
        update_n_lines = '<leader>sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    }

    local miniclue = require 'mini.clue'
    miniclue.setup {
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        { mode = 'n', keys = ']' },
        { mode = 'x', keys = ']' },
        { mode = 'n', keys = '[' },
        { mode = 'x', keys = '[' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      window = {
        -- Floating window config
        config = {
          width = 'auto',
          -- Use double-line border
          -- border = 'double',
        },

        -- Delay before showing clue window
        delay = 0,

        -- Keys to scroll inside the clue window
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
    }

    -- require('mini.completion').setup()

    -- text object
    require('mini.ai').setup()

    require('mini.comment').setup {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
        ignore_blank_line = true,
      },
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        -- comment = 'gc',
        comment = '<C-c>',

        -- Toggle comment on current line
        comment_line = '<C-c>',

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        textobject = 'gc',
      },
    }
  end,
}
