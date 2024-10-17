return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "stevearc/conform.nvim",
        "NvChad/nvim-colorizer.lua",
        "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    config = function()
        -- Setup cmp for completion suggestions
        local cmp = require("cmp")
        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-o>"] = cmp.mapping.abort(),
                ["<cr>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp", group_index = 2 },
                { name = "luasnip",  group_index = 2 },
                -- { name = "copilot",  group_index = 2 },
            }, {
                { name = "buffer" },
            }),
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
                { name = "buffer" },
            }),
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("cmp").config.formatting = {
            format = require("tailwindcss-colorizer-cmp").formatter
        }

        -- Set up Mason (Used to download and install lsp servers
        -- Linters, daps and formatters
        require("mason").setup({
            ui = {
                border = "rounded",
            },
        })

        -- Set up lspconfig used for configuring the lsp servers
        -- Using mason-lspconfig instead of lspconfig directly
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "rust_analyzer", "tsserver" },
            handlers = {
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                -- Next, you can provide targeted overrides for specific servers.
                ["lua_ls"] = function()
                    require("neodev").setup({})
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    })
                end,
                ["astro"] = function()
                    require("lspconfig").astro.setup({})
                end,
            },
        })

        require("colorizer").setup({
            user_default_options = { tailwind = true },
        })
        require("lspconfig.ui.windows").default_options.border = "rounded"
        -- require("mason-lspconfig").setup_handlers(handlers)

        -- Setup Conform to be used for formatting
        require("conform").setup({
            -- Sets formatter for each filetype
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                astro = { "prettierd", "prettier" },
            },
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
