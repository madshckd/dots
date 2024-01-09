" This line makes pacman-installed global Arch Linux vim packages work.
" source /usr/share/nvim/archlinux.vim

" This is a neovim system wide configuration, so administrator permission is required

" custom rules and specifications (not too shabby but it is minimal and working for me ofcourse)
" minimal ide setup (golang, c, bash, html, python?)
" carefully handpicked by z31a

" plugin manager used : vim-plug
" download vim-plug and place it in /usr/share/nvim/runtime/autoload directory

" dependencies : (available via pacman)
"   + gopls
"   + clangd
"   + bash-languageserver
"   + vscode-html-languageserver
"   + pyright | python-pyright from pip | python-pynvim

" for makrdown-previw plugin to work properly, call mkdp#ulti#install() after plugin installation

" if you're trying to setup user specific configuration then remove the path in call plug#begin() function
" if you have administrator access then, leave it as it is

syntax on                   " syntax highlighting
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set noswapfile              " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
" set cc=80                  " set an 80 column border for good coding style
" set spell                  " enable spell check (may need to download language package)

" z31a special keymap
inoremap >? <esc>

" filetype 
filetype plugin on
filetype plugin indent on   " allow auto-indenting depending on file type

" plugin customisation
call plug#begin('/usr/share/nvim/runtime/autoload')

" nord theme plugin
" Plug 'shaunsingh/nord.nvim'     

" snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" lsp configuration plugin
Plug 'neovim/nvim-lspconfig'    

" NerdTree
Plug 'preservim/nerdtree'

" autocompletion setup
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" debugger setup
Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'

" autosave plugin
Plug 'okuuva/auto-save.nvim'

" markdown-preview plugin
Plug 'iamcco/markdown-preview.nvim'

call plug#end()

" plugin specific customisation

" theme
"colorscheme nord

" markdown-preview configs
let g:mkdp_auto_close = 1
let g:mkdp_echo_preview_url = 1
let g:mkdp_browser = 'firefox'

" disabling some providers
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" configs written using 'lua'
" comprises configurations for :
    " nvim-lspconfig
    " nvim-cmp

lua << EOF

-- lspconfig starts

-- declaring a local variable
local lspconfig = require('lspconfig')


-- enabling completion support via snippets
-- completion is enabled only when snippet support is enabled.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- enabling lsp's
lspconfig.html.setup{}          -- html lsp server
lspconfig.gopls.setup{}         -- go language lsp server from google
lspconfig.clangd.setup{}        -- c language lsp server (clangd)
lspconfig.bashls.setup{}        -- bash (shell scripting) language server
--lspconfig.pyright.setup{}       -- python language server (pyright)

-- lspconfig ends

-- nvim-cmp config starts

-- setting up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    -- snippet engine config
    snippet = {
        expand = function(args)
            -- using 'luasnip' as snippet engine
            require('luasnip').lsp_expand(args.body)
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
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

-- cmp config for lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()
  
-- html lspconfig
require('lspconfig')['html'].setup {
    capabilities = capabilities
}

-- golang lspconfig
require('lspconfig')['gopls'].setup {
    capabilities = capabilities
}

-- clangd lspconfig
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}

-- pyright lspconfig
-- require('lspconfig')['pyright'].setup {
--    capabilities = capabilities
--}

-- bashls lspconfig
require('lspconfig')['bashls'].setup {
    capabilities = capabilities
}

-- nvim-cmp config ends

-- dap-go config (go adapter for nvim-dap)
require('dap-go').setup()

-- auto-save plugin
require('auto-save').setup {}

EOF
