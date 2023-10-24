{ config, pkgs, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		plugins = with pkgs.vimPlugins; [
    lazy-nvim
    nvim-treesitter.withAllGrammars
		];

 extraLuaConfig = /* lua */ ''
	vim.g.mapleader = ' '
	vim.g.maplocalleader = ' '
	vim.opt.cmdheight = 1
	vim.opt.swapfile = false

	-- defaults tab
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true
	vim.bo.softtabstop = 2

	-- Set highlight on search
	vim.o.hlsearch = false

	-- Make line numbers default
	vim.wo.number = true

	-- Enable mouse mode
	vim.o.mouse = 'a'

	vim.o.clipboard = 'unnamedplus'

	-- Enable break indent
	vim.o.breakindent = true

	-- Save undo history
	vim.o.undofile = true

	-- Case-insensitive searching UNLESS \C or capital in search
	vim.o.ignorecase = true
	vim.o.smartcase = true

	-- Keep signcolumn on by default
	vim.wo.signcolumn = 'yes'

	-- Decrease update time
	vim.o.updatetime = 250
	vim.o.timeout = true
	vim.o.timeoutlen = 100

	-- Set completeopt to have a better completion experience
	vim.o.completeopt = 'menuone,noselect'

	-- NOTE: You should make sure your terminal supports this
	vim.o.termguicolors = true

	vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'


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



require('lazy').setup({
{
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = "i",
      -- },
      -- { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      -- { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local defaults = require("cmp.config.default")()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local function next_item(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local function prev_item(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end
      --
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<tab>"] = cmp.mapping(next_item, { "i", "s" }),
          ["<s-tab>"] = cmp.mapping(prev_item, { "i", "s" }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
},
{
  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '[g', require('gitsigns').prev_hunk,
        { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
      vim.keymap.set('n', ']g', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
      vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
    end,
  },
},
{ 
  'christoomey/vim-tmux-navigator',
},
{
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- 'nvim-treesitter/nvim-treesitter-context',
    'gungun974/nvim-ts-autotag',
  },
  build = ':TSUpdate',
  config = function()
    -- [[ Configure Treesitter ]]
    -- See `:help nvim-treesitter`
    require('nvim-treesitter.configs').setup {
      modules = {},

      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },
      ignore_install = {},
      sync_install = false,

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,
      autotag = {
        enable = true,
      },

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          -- scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>wp'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>wP'] = '@parameter.inner',
          },
        },
      },
    }

    -- setup code folding
    -- vim.opt.foldmethod = 'expr'
    -- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  end,
},
{
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
},
{
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
    'nvimdev/lspsaga.nvim',
  },
  config = function()
    -- configure lsp saga
    require('lspsaga').setup {
      ui = {
        border = 'rounded',
      },
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
      outline = {
        layout = 'float',
        enable = false,
      },
    }

    -- [[ Configure LSP ]]
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      vim.keymap.set({ 'n', 'v' }, '<leader>a', '<cmd>Lspsaga code_action<CR>')

      nmap('gd', '<cmd>Lspsaga goto_definition<CR>', '[G]oto [D]efinition')
      nmap('gr', function()
        require('fzf-lua').lsp_references { ignore_current_line = true }
      end, '[G]oto [R]eferences')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

      vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- tsserver = {},
      cssls = {},
      cssmodules_ls = {},
      vtsls = {},
      -- biome = {},

      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        }
      end,
    }

    require('lspconfig').vtsls.setup { --[[ your custom server config here ]]
    }
  end,
},
{
  "folke/flash.nvim",
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
},
{
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      '<leader>hh',
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      desc = '[H]arpoon [H]ome',
    },
    {
      '<leader>ha',
      function()
        require('harpoon.mark').add_file()
      end,
      desc = '[H]arpoon Add',
    },
    {
      '<leader>jj',
      function()
        require('harpoon.ui').nav_file(1)
      end,
      desc = '[H]arpoon to file 1',
    },
    {
      '<leader>kk',
      function()
        require('harpoon.ui').nav_file(2)
      end,
      desc = '[H]arpoon to file 2',
    },
  },
  config = function()
    require('harpoon').setup {}

    -- require("telescope").load_extension('harpoon')
  end,
},
{
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
      }
    end

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
    keymap('n', '<leader><space>', '<cmd>lua MiniPick.builtin.buffers()<cr>', { noremap = true, silent = true, desc = 'Find Buffer' })
    keymap('n', '<leader>ss', '<cmd>lua MiniPick.builtin.grep_live()<cr>', { noremap = true, silent = true, desc = 'Find String' })

    require('mini.sessions').setup {
      autowrite = true,
    }
    require('mini.surround').setup()

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
        ignore_blank_line = true,
      },
      mappings = {
        comment = '<C-c>',
        comment_line = '<C-c>',
        textobject = 'gc',
      },
    }

  end,
},
{
  -- Theme inspired by Atom
  'catppuccin/nvim',
  name = 'catppuccin',
  enabled = true,
  lazy = false,
  priority = 1000,
  ---@class CatppuccinOptions
  opts = {
    flavour = 'mocha',
    transparent_background = true,

    integrations = {
      cmp = true,
      fidget = true,
      gitsigns = true,
      harpoon = true,
      lsp_trouble = true,
      mason = true,
      neotest = true,
      noice = true,
      notify = true,
      nvimtree = true,
      flash = true,
      octo = true,
      telescope = {
        enabled = false,
        -- style = "nvchad"
      },

      treesitter = true,
      treesitter_context = true,
      symbols_outline = true,
      illuminate = true,
      which_key = true,
      barbecue = {
        dim_dirname = true,
        bold_basename = true,
        dim_context = false,
        alt_background = false,
      },
      dap = {
        enabled = true,
        enable_ui = true,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { 'italic' },
          hints = { 'italic' },
          warnings = { 'italic' },
          information = { 'italic' },
        },
        underlines = {
          errors = { 'underline' },
          hints = { 'underline' },
          warnings = { 'underline' },
          information = { 'underline' },
        },
      },
    },
    color_overrides = {
      all = {
        surface0 = '#444444',
        surface1 = '#666666',
        surface2 = '#a3a7bc',
        surface3 = '#a3a7bc',
      },
    },
  },
  config = function()
    vim.cmd.colorscheme 'catppuccin'
  end,
}





}, {
  defaults = {
    lazy = false
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true,        -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {},          -- add any custom paths here that you want to includes in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

    '';
	};

}
