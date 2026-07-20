return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300 -- Zeit in ms, bis das Menü erscheint
        end,
        opts = {
            -- Hier kannst du das Design anpassen
            preset = "classic", -- oder "modern" / "helix"
            spec = {
                -- Hier geben wir den Gruppen Namen (z.B. <leader>f für "Find")
                { "<leader>f", group = "Find" },
                { "<leader>c", group = "Code" },
                { "<leader>g", group = "Git" },
                { "<leader>x", group = "Diagnostics" },
                { "<leader>t", group = "Toggle / Terminal" },
                { "<leader>r", group = "Rename" },
                { "<leader>y", group = "Yank (Clipboard)" },
                { "<leader>d", group = "Delete (No Register)" },
            },
        },
    },
}
