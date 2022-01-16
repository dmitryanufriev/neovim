--*******************************************************
--* PLUGINS 
--*******************************************************

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'

  -- Информационная строка внизу
  use { 'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('lualine').setup()
    end, 
  }

  -- Файловый менеджер
  vim.g.nvim_tree_indent_markers = 1
  use { 
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() 
      require'nvim-tree'.setup {} 
    end, 
  }

  -- Telescope
  use { 
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function() 
      require'telescope'.setup {} 
    end, 
  }

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  -- Автодополнялка
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'saadparwaiz1/cmp_luasnip'

  --- Автодополнлялка к файловой системе
  use 'hrsh7th/cmp-path'

  use 'tpope/vim-endwise'

  -- Bookmarks
  vim.g.bookmark_no_default_key_mappings = 1
  vim.g.bookmark_save_per_working_dir = 1
  use 'MattesGroeger/vim-bookmarks'
  use 'tom-anders/telescope-vim-bookmarks.nvim'

  -- Emmet
  use 'mattn/emmet-vim'

  -- Terminal
  use "akinsho/toggleterm.nvim"

  -- Comment
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
end)


--*******************************************************
--* SETTINGS 
--*******************************************************

vim.cmd([[
  colorscheme gruvbox
]])

vim.cmd([[
  filetype indent plugin on
  syntax enable
]])

vim.cmd([[
  set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
  set list
]])

vim.cmd([[
  set nowrap
]])

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = '120'
vim.opt.cursorline = true
vim.opt.so = 999
vim.opt.expandtab = true
vim.opt.shiftwidth = 2        -- shift 2 spaces when tab
vim.opt.tabstop = 2           -- 1 tab == 2 spaces
vim.opt.smartindent = true    -- autoindent new lines
vim.opt.termguicolors = true  -- 24-bit RGB colors
vim.opt.mouse = 'a'

-- Подсвечивает на доли секунды скопированную часть текста
vim.api.nvim_exec([[
  augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
  augroup end
]], false)

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
--vim.o.completeopt = 'menuone,noselect'

-- LSP settings
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities
    }

    if server.name == "html" then
      opts.filetypes = { "html", "eruby" }
    end

    server:setup(opts)
end)

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', option = {
        get_bufnrs = function()
            return vim.api.nvim_list_bufs()
        end
      },
    },
  },
}

-- Bookmarks
require('telescope').load_extension('vim_bookmarks')

--*******************************************************
--* KEY BINDINGS 
--*******************************************************

vim.g.mapleader = ","

local default_opts = { noremap = true, silent = true }

-- Telescope
vim.api.nvim_set_keymap('n', '<C-t>', [[<cmd>lua require('telescope.builtin').tags()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<C-f>', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-f>', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-F>', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], default_opts)

-- LSP
vim.api.nvim_set_keymap('n', '<M-p>', [[<cmd>lua vim.lsp.buf.hover()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-P>', [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-O>', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-o>', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-d>', [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-r>', [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<M-R>', [[<cmd>lua vim.lsp.buf.rename()<cr>]], default_opts)
vim.api.nvim_set_keymap('n', '<Leader>rf', [[<cmd>lua vim.lsp.buf.formatting()<cr>]], default_opts)

-- NVimTree
vim.api.nvim_set_keymap('n', '<F5>', ':NvimTreeRefresh<cr>:NvimTreeToggle<cr>', default_opts)
vim.api.nvim_set_keymap('n', '<Leader>tf', ':NvimTreeFindFile<cr>', default_opts)

-- Window management
vim.api.nvim_set_keymap('n', '<', ':vertical res +5<cr>', default_opts)
vim.api.nvim_set_keymap('n', '>', ':vertical res -5<cr>', default_opts)
vim.api.nvim_set_keymap('n', '_', ':res +5<cr>', default_opts)
vim.api.nvim_set_keymap('n', '+', ':res -5<cr>', default_opts)

-- Bookmarks
vim.api.nvim_set_keymap('n', '<M-b>', ':BookmarkAnnotate<cr>', default_opts)
vim.api.nvim_set_keymap('n', '<M-B>', ':BookmarkToggle<cr>', default_opts)
vim.api.nvim_set_keymap('n', '<Leader>bf', [[<cmd>lua require('telescope').extensions.vim_bookmarks.all()<cr>]], default_opts)
