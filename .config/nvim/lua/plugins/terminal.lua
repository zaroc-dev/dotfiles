return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
            { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Floating terminal" },
            { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
        },
        opts = {
            direction = "float",
            open_mapping = [[<C-\>]],
            float_opts = { border = "curved" },
        },
    },
}
