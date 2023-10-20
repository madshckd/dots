" This line makes pacman-installed global Arch Linux vim packages work.
" source /usr/share/nvim/archlinux.vim

" custom rules and specifications 
" carefully handpicked by z31a

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
Plug 'shaunsingh/nord.nvim'     

" snippets
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'

" lsp configuration plugin
Plug 'neovim/nvim-lspconfig'    

" autocompletion setup
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" autosave plugin
Plug 'okuuva/auto-save.nvim'
call plug#end()
" plugin specific customisation

" theme
" colorscheme nord

" configs written using 'lua'
" comprises configurations for :
    " nvim-lspconfig
    " nvim-cmp

lua << EOF

-- lspconfig starts

-- declaring a local variable
local lspconfig = require('lspconfig')


lspconfig.html.setup{}          -- html lsp support from vscode with default js and css support
-- enabling completion support via snippets
-- completion is enabled only when snippet support is enabled.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.gopls.setup{}         -- go language lsp server from google

-- lspconfig ends

-- nvim-cmp config starts

-- setting up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    -- snippet engine config
    snippet = {
        expand = function(args)
            -- using 'ultisnips' as snippet engine
            vim.fn["UltiSnips#Anon"](args.body)
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
        { name = 'ultisnips' },
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

-- auto-save plugin
require('auto-save').setup {}

-- nvim-cmp config ends
EOF
