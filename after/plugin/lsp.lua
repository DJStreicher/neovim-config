-- Sign column and true color support
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

-- Add LSP capabilities from nvim-cmp
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Setup Mason and Mason LSP bridge
require("mason").setup()

-- Configure servers using a common on_attach function
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
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
end

-- Use Mason-LSPConfig to ensure servers are installed, and then configure them manually
require("mason-lspconfig").setup({
    ensure_installed = {
        "html",
        "cssls",
        "intelephense",
        "ts_ls",
        "emmet_ls",
        "clangd",
    },
})

-- Setup servers with a common on_attach callback
local function disable_diagnostic(client)
    client.handlers["textDocument/publishDiagnostics"] = function() end
end

local capabilities = cmp_nvim_lsp.default_capabilities()
lspconfig.intelephense.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        disable_diagnostic(client)
        on_attach(client, bufnr)
    end,
    filetypes = { "php", "html" }, -- Ensure this is correct
})
lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        disable_diagnostic(client)
        on_attach(client, bufnr)
    end,
    filetypes = { "html", "php" }, -- Add php here to allow the html LSP to attach
    init_options = { provideFormatter = true },
})
lspconfig.emmet_ls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        disable_diagnostic(client)
        on_attach(client, bufnr)
    end,
    filetypes = { "html", "php" }, -- Add php here to allow the emmet LSP to attach
    init_options = {
        html = {
            options = {
                ["bem.enabled"] = true,
                ["output.indent"] = "    "
            }
        }
    }
})

-- Load LuaSnip and VSCode-style snippets
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

-- Setup nvim-cmp
local cmp = require('cmp')
cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
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

-- Add the autocmd for PHP
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        vim.opt.smartindent = true
        vim.opt.indentexpr = nil
    end,
})

-- Setup diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
})
