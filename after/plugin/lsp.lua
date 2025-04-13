-- Sign column and true color support
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

-- Add LSP capabilities from nvim-cmp
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
'force',
lspconfig_defaults.capabilities,
require('cmp_nvim_lsp').default_capabilities()
)

-- Setup Mason and Mason LSP bridge
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "html",
        "cssls",
        "rust_analyzer",
--        "intelephense",
        "ts_ls",
        "pylsp",
        "clangd",
        "jsonls",
    },
    handlers = {
        function(server_name)
            if server_name == "intelephense" then
                require("lspconfig")[server_name].setup({
                    root_dir = function() return vim.loop.cwd() end,
                })
            else
                require("lspconfig")[server_name].setup({})
            end
        end,
    },
})

-- Setup html lsp inside of php files
require("lspconfig").html.setup{
  filetypes = { "html", "php" },
  init_options = { provideFormatter = true },
}

-- Setup keymaps when an LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
    end,
})

-- Load LuaSnip and VSCode-style snippets
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

-- Setup nvim-cmp
local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
})

-- Enable Emmet
local lspconfig = require('lspconfig')

lspconfig.emmet_ls.setup({
    filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue" },
    init_options = {
        html = {
            options = {
                ["bem.enabled"] = true, -- Enable BEM syntax support if needed
                ["output.indent"] = "    "
            }
        }
    }
})

