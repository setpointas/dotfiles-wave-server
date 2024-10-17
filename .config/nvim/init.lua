-- Set custom options
require("options")
require("autocommands")

-- Initialize the Lazy nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set the package manager to get plugins from the lua/plugins dir
local plugins = "plugins"
local opt = {
    -- Set the colorscheme to use for lazy nvim gui
    colorscheme = "kanagawa-wave",
}

-- Load all plugins
-- This will always call require(<plugin-name>).setup() automatically
-- But this can be overridden. See examples in the plugins dir.
require("lazy").setup(plugins, {})

-- set custom kaymaps
require("keymaps")

-- Set the colorscheme
-- vim.cmd [[colorscheme kanagawa-wave]]
