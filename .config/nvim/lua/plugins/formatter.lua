return {
    {
        "stevearc/conform.nvim",
        -- Lädt das Plugin kurz bevor du eine Datei speicherst
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            -- Hier ordnen wir den Dateitypen ihre Formatter zu
            formatters_by_ft = {
                lua = { "stylua" },
                -- Web-Entwicklung (Prettier übernimmt hier alles)
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                markdown_inline = { "prettier" },
                nix = { "nixfmt" },
                -- Python
                python = { "ruff" },
                -- C#
                cs = { "csharpier" },
                -- Für Rust lassen wir das Feld leer, damit er auf den lsp_fallback (rust_analyzer) zurückgreift
            },

            -- Die Magie: Automatisches Formatieren beim Speichern (Strg+S oder :w)
            format_on_save = {
                timeout_ms = 500,
                -- WICHTIG: Wenn für eine Sprache (wie Rust oder C#) kein extra Formatter
                -- definiert oder gefunden wird, fragt Conform den LSP-Server, ob er das übernehmen kann!
                lsp_fallback = true,
            },
        },
    },
}
