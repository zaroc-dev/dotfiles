return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- 1. Mason
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- 2. Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            -- 3. Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            -- === 1. MASON SETUP ===
            require("mason").setup()

            -- Definiere hier deine Server als Liste
            local servers = {
                "ts_ls", -- TypeScript/JavaScript
                "svelte", -- Svelte
                "yamlls", -- YAML
                "rust_analyzer", -- Rust
                "omnisharp", -- C#
                "lua_ls", -- Lua
                "ruff",
                "nil_ls", -- Nix
            }

            require("mason-lspconfig").setup({
                ensure_installed = servers,
                automatic_installation = true,
            })

            -- === 2. SERVER MIT NEOVIM VERBINDEN (NEOVIM 0.11 READY) ===
            require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            for _, lsp in ipairs(servers) do
                if vim.fn.has("nvim-0.11") == 1 then
                    vim.lsp.config[lsp] = vim.tbl_deep_extend("force", vim.lsp.config[lsp] or {}, {
                        capabilities = capabilities,
                        -- NEU: Wir schalten Semantic Tokens für Svelte ab,
                        -- damit Treesitter das HTML wieder einfärben darf!
                        on_attach = function(client, bufnr)
                            if client.name == "svelte" then
                                client.server_capabilities.semanticTokensProvider = nil
                            end
                        end,
                    })
                    vim.lsp.enable(lsp)
                else
                    require("lspconfig")[lsp].setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            if client.name == "svelte" then
                                client.server_capabilities.semanticTokensProvider = nil
                            end
                        end,
                    })
                end
            end

            -- === 3. AUTOCOMPLETION (CMP) KONFIGURIEREN ===
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
            -- === DIAGNOSTICS (Fehleranzeige wie in LazyVim) ===

            -- Schicke Icons für die linke Leiste definieren (Nerd Font benötigt)
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Neovim sagen, wie Fehler dargestellt werden sollen
            vim.diagnostic.config({
                -- Das ist das Wichtigste: Zeigt den Fehlertext am Ende der Zeile an!
                virtual_text = {
                    prefix = "●", -- Kleiner Punkt vor dem Text
                },
                signs = true, -- Zeigt die Icons links an
                underline = true, -- Unterstreicht das fehlerhafte Wort (wie 'dog')
                update_in_insert = false, -- Wartet mit der Fehlersuche, bis du den Insert-Mode verlässt (besser für die Performance)
                severity_sort = true, -- Schlimmste Fehler immer zuerst anzeigen
            })
            -- === 4. KEYMAPS FÜR LSP ===
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                    vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                end,
            })
        end,
    },
}
