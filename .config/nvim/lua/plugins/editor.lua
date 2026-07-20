return {
    { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
    { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
            { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = { scope = { enabled = true } },
    },
}
