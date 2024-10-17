vim.opt.number = true                           -- Enable line numbers
vim.opt.relativenumber = true                   -- Enable relative numbers
vim.opt.splitbelow = true                       -- New windows open on the bottom
vim.opt.splitright = true                       -- New windows open to the right
vim.opt.wrap = false                            -- No line wrapping
vim.opt.expandtab = true                        -- Treat tabs as spaces
vim.opt.tabstop = 4                             -- This should always be 8 (default)
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4                          -- Default number of spaces to indent
vim.opt.clipboard = "unnamedplus"               -- Sync vim clipboard with system clipboard
vim.opt.scrolloff = 999                         -- Keeps cursor in the middle of screen when scrolling
vim.g.mapleader = " "                           -- Set leader key to spacebar
vim.g.maplocalleader = " "                      -- Set local leader to spacebar
vim.opt.virtualedit =
"block"                                         -- Lets the cursor move beond the end of the line when in Visual Block mode
vim.opt.inccommand = "split"                    -- Shows a preview when doing find / replace (and maybe more...)
vim.opt.ignorecase = true                       -- Makes searching for commands easier
vim.opt.termguicolors = true                    -- Allows vim to use the full color (24-bit) range from the terminal (nicer)
vim.opt.timeoutlen = 500                        -- Sets the timeout for keybindings
vim.opt.backup = false                          -- do not creates a backup file
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 1                        -- 0 = so that `` is visible in markdown files
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.pumblend = 10                           -- pop up meny height
vim.opt.showmode = false                        -- see things like -- INSERT, NORMAL etc...
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.swapfile = false                        -- do not create a swapfile
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 100                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.laststatus = 3                          -- 3= Show status line always and ONLY the last window. (default 2=always)
vim.opt.ruler = false
vim.opt.numberwidth = 3                         -- set number column width to 3 {default 4}
vim.opt.signcolumn =
"yes"                                           -- always show the sign column, otherwise it would shift the text each time
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 8
vim.opt.title = false
-- Folding
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Unsure about these
-- vim.cmd "set whichwrap+=<,>,[,],h,l"
-- vim.cmd [[set iskeyword+=-]]
vim.opt.showtabline = 1 -- always show tabs
-- vim.opt.colorcolumn = "120",
-- vim.opt.fileformats = "unix,mac,dos"
