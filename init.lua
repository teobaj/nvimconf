--General Config 

vim.cmd([[
set nocompatible
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set cursorline
:highlight Cursorline cterm=bold ctermbg=black
filetype on
filetype plugin on
filetype indent on
set hlsearch
set ignorecase
set smartcase
set showmatch
set noswapfile
set incsearch
set scrolloff=8
set colorcolumn=120
set undofile
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
set clipboard=unnamedplus
]])

-- Keybindings
vim.keymap.set('n', 'ss', ':split<Return><C-w>w')
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sl', '<C-w>l')
vim.keymap.set('n', 's.', '5<C-w>>')
vim.keymap.set('n', 's,', '5<C-w><')
vim.keymap.set('n', 'fe', ':Ex <CR>')

-- Telescope Keybindings


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  'BurntSushi/ripgrep',
  'nvim-telescope/telescope-fzf-native.nvim',
  'neovim/nvim-lspconfig',
  'nvim-lua/plenary.nvim',
  'nvim-treesitter/nvim-treesitter',  
  'nvim-telescope/telescope.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-tree/nvim-web-devicons',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'jose-elias-alvarez/null-ls.nvim',
  'MunifTanjim/prettier.nvim',
  'Equilibris/nx.nvim',
  'othree/html5.vim',
  'pangloss/vim-javascript',
  {'evanleck/vim-svelte', branch = 'main'},
  'akinsho/toggleterm.nvim',
  'tpope/vim-fugitive',
  'rbong/vim-flog',
  'williamboman/mason.nvim',
  'arzg/vim-colors-xcode',
  'nvim-lualine/lualine.nvim',
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { "mistricky/codesnap.nvim", build = "make" },
})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {
})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<C-/>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- CTRLP
vim.cmd("set wildignore+=*/tmp/*,*.so,*.swp,*.zip")  
vim.cmd("let g:ctrlp_custom_ignore = {'dir': 'node_modules'}")
-- LSP

local lspconfig = require('lspconfig')

-- Code actions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<space>h', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<space>l', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Cant remember what is this
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


-- LSPs

lspconfig.tsserver.setup {
  capabilities = capabilities
}

lspconfig.svelte.setup {
  capabilities = capabilities,
  filetype = { 'svelte' }
}
lspconfig.cssls.setup{
  capabilities = capabilities,
  filetype = { 'css', 'scss', 'sass', 'pcss' }
}

lspconfig.html.setup{
  capabilities = capabilities
}

lspconfig.tailwindcss.setup{
  capabilities = capabilities
}


lspconfig.gopls.setup{
  capabilities = capabilities
}

-- Angular LSP
local project_library_path = "/Users/TB19970/.nvm/versions/node/v18.17.1/lib/node_modules/@angular/language-server"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations","/Users/TB19970/.nvm/versions/node/v18.17.1/lib/node_modules/@angular/language-server", "--ngProbeLocations", "/Users/TB19970/.nvm/versions/node/v18.17.1/lib/node_modules/@angular/language-server" }


lspconfig.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}

-- Prettier 
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "sf", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "sf", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

-- toggleterm
require("toggleterm").setup({
  direction = 'float',
})


ToggleTerminal  = require('toggleterm.terminal').Terminal

terminal = nil
function openTerminal() 
  if terminal == nil then
    terminal = ToggleTerminal:new({})
  end
  terminal:toggle()
end

function killTerminal()
  terminal = nil
end

vim.keymap.set('n', 'T', openTerminal)
vim.keymap.set('n', '<C-T>', killTerminal)

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- LuaLine
require('lualine').setup {
}

vim.cmd.colorscheme "catppuccin"
-- Mason
require("mason").setup()

--Treesitter

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

  },
}

require("codesnap").setup({
  bg_padding = 0,
  has_breadcrumbs = true
})
