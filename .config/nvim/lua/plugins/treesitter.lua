return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "master",
        dependencies = {
            "windwp/nvim-ts-autotag",
        },
        opts = {
            ensure_installed = {
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
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            autotag = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
            vim.treesitter.language.register("svelte", "svelte")
        end,
    },
}
