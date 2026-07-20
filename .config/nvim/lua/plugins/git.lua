return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            current_line_blame = true,
            current_line_blame_opts = { delay = 500 },
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
                map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
                map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage hunk")
                map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>gb", gs.blame_line, "Blame line")
                map("n", "<leader>gd", gs.diffthis, "Diff file")
            end,
        },
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
        },
    },
}
