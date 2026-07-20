return {
    {
        "andweeb/presence.nvim",
        event = "VeryLazy",
        cond = function()
            return #vim.api.nvim_list_uis() > 0
        end,
    },
}
