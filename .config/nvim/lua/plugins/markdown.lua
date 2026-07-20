return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {
            completions = { lsp = { enabled = true } },
            heading = { sign = false },
            code = { sign = false, width = "block", right_pad = 1 },
        },
        keys = {
            { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown rendering" },
        },
    },
}
