return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        branch = "main",
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        config = function()
            local languages = {
                "bash",
                "c",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "vim",
                "vimdoc",
                "typescript",
                "tsx",
                "svelte",
                "yaml",
                "rust",
                "c_sharp",
                "nix",
            }

            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/treesitter",
            })
            require("nvim-treesitter").install(languages):wait(300000)
            require("nvim-ts-autotag").setup()

            vim.treesitter.language.register("svelte", "svelte")

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(event)
                    pcall(vim.treesitter.start, event.buf)
                end,
            })
        end,
    },
}
