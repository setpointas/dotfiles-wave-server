return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = { transparent = true },
    config = function()
        vim.cmd("colorscheme kanagawa-wave")
    end
}
