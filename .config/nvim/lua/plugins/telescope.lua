return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
                },
            },
            pickers = {
                find_files = { hidden = true },
            },
        })

        local builtin = require("telescope.builtin")

        -- Keymaps für Telescope
        -- <leader>ff = Finde Dateien (Find Files)
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

        -- <leader>fg = Suche Text in allen Dateien (Live Grep)
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })

        -- <leader>fb = Zeige offene Dateien (Buffers)
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })

        -- <leader>fh = Durchsuche die Neovim-Hilfe
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
        vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
        vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search buffer" })
    end,
}
