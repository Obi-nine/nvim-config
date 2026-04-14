local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})

require('mason-lspconfig').setup({
    ensure_installed = {
        'ts_ls',
        'rust_analyzer',
        'intelephense',
        'html',
        'cssls',
        'svelte',
        'arduino_language_server',
        'pyright',
    },
    handlers = {
        lsp_zero.default_setup,

        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(vim.tbl_deep_extend('force', lua_opts, {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            }))
        end,
    }
})

vim.lsp.config('intelephense', {
    settings = {
        intelephense = {
            telemetry = { enabled = false },
            stubs = {
                "bcmath", "bz2", "calendar", "Core", "curl", "date",
                "dba", "dom", "enchant", "fileinfo", "filter", "ftp",
                "gd", "gettext", "hash", "iconv", "imap", "intl",
                "json", "ldap", "libxml", "mbstring", "mcrypt",
                "mysql", "mysqli", "password", "pcntl", "pcre",
                "PDO", "pdo_mysql", "Phar", "readline", "recode",
                "Reflection", "regex", "session", "SimpleXML",
                "soap", "sockets", "sodium", "SPL", "standard",
                "superglobals", "sysvsem", "sysvshm", "tokenizer",
                "xml", "xdebug", "xmlreader", "xmlwriter", "yaml",
                "zip", "zlib", "wordpress", "woocommerce", "acf-pro",
                "wordpress-globals", "wp-cli", "polylang"
            },
            environment = {
                includePaths = {
                    vim.fn.expand('~/.composer/vendor/php-stubs/wordpress-stubs'),
                    vim.fn.expand('~/.composer/vendor/php-stubs/woocommerce-stubs'),
                    vim.fn.expand('~/.composer/vendor/php-stubs/wordpress-globals'),
                    vim.fn.expand('~/.composer/vendor/php-stubs/acf-pro-stubs'),
                    vim.fn.expand('~/.composer/vendor/php-stubs/wp-cli-stubs'),
                }
            },
            files = { maxSize = 5000000 }
        }
    }
})

vim.lsp.config('arduino_language_server', {
    cmd = {
        "arduino-language-server",
        "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
        "-fqbn", "arduino:avr:uno",
        "-cli", "arduino-cli",
        "-clangd", "clangd"
    }
})

vim.lsp.config('svelte', {
    filetypes = { "svelte" }
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
