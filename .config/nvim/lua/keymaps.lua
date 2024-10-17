local opts = { noremap = true, silent = true }
local which_key = require("which-key")
local which_key_keys = {
    q = { "<cmd>confirm q<CR>", "Quit" },
    h = { "<cmd>split<CR>", "H-Split" },
    v = { "<cmd>vsplit<CR>", "V-Split" },
    n = { "<cmd>Neotree toggle<CR>", "NeoTree" },
    b = {
        name = "Buffers",
        d = { "<cmd>bd<CR>", "Delete" },
        n = { "<cmd>bn<CR>", "Next" },
        p = { "<cmd>bp<CR>", "Previous" },
    },
    l = { name = "LSP" },
    s = { name = "Search/Replace" },
    t = { "<cmd>TransparentToggle<CR>", "Transparent Toggle" },
}

-- End of line navigation
-- vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Begining of line" })
-- vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set({ "n", "o", "x" }, "<s-h>", "^", opts)  -- Shift+h to go to start of line
vim.keymap.set({ "n", "o", "x" }, "<s-l>", "g_", opts) -- Shift+l to go to end of line

-- Prevent space tp move cursor in noraml mode
vim.keymap.set("n", "<Space>", "", opts)

-- Why?
-- vim.keymap.set("n", "<C-i>", "<C-i>", opts)
--
---- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-tab>", "<c-6>", opts)

-- Center screen
vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "N", "Nzz", opts)
vim.keymap.set("n", "*", "*zz", opts)
vim.keymap.set("n", "#", "#zz", opts)
vim.keymap.set("n", "g*", "g*zz", opts)
vim.keymap.set("n", "g#", "g#zz", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Increment / decrement numbers
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Select all text in the buffer
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Yanking
-- x means that
vim.keymap.set("x", "p", [["_dP]])   -- Keep last yank in default register after paste
vim.keymap.set("x", "y", "ygv<Esc>") -- Move cursor to last line of the yanked text instead of to the beginning
vim.keymap.set("x", "Y", "y$")       -- Yank to end of line

-- Mouse mappings
vim.cmd([[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
vim.cmd([[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]])
vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

-- Move lines up and down
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keys for Copilot
vim.api.nvim_set_keymap("n", "<c-s>", ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

-- Undotree
vim.keymap.set(
    "n",
    "<leader>u",
    "<cmd>lua require('undotree').toggle()<cr>",
    { noremap = true, silent = true, desc = "Undotree" }
)

-- Saving
vim.keymap.set("n", "<c-s>", "<cmd>w<cr>", opts)
vim.keymap.set("i", "<c-s>", "<cmd>w<cr><esc>", opts)

-- Clear search highlighta
vim.keymap.set(
    "n",
    "<leader><cr>",
    "<cmd>nohlsearch<cr>",
    { noremap = true, silent = true, desc = "Clear search highlights" }
)

-- Oil File explorer
vim.keymap.set("n", "<leader>o", "<cmd>lua require('oil').toggle_float()<cr>", { desc = "File explorer" })

-- Telescope
local builtin = require("telescope.builtin")
table.insert(which_key_keys, { f = { name = "Find" } })
-- Lists files in your current working directory, respects .gitignore
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
-- Search for a string in your current working directory and get results live as you type, respects .gitignore.
vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep Dir" })
-- Searches for the string under your cursor or selection in your current working directory
vim.keymap.set("n", "<leader>w", builtin.grep_string, { desc = "Grep word" })
-- Lists open buffers in current neovim instance
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
-- Lists previously open files
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent" })
-- Fuzzy search through the output of git ls-files command, respects .gitignore
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find Git files" })
-- Lists vim registers, pastes the contents of the register on <cr>
--vim.keymap.set('n', '<leader>r', builtin.registers, {})

--Copy current buffer file name or file path
vim.keymap.set("n", "<leader>fn", "<cmd>let @+ = expand(\"%\")<CR>", { desc = "Copy File Name" })
vim.keymap.set("n", "<leader>fp", "<cmd>let @+ = expand(\"%:p\")<CR>", { desc = "Copy File Path" })

-- Harpoon
-- table.insert(which_key_keys, {a = { name = "Harpoon", ["1"] = "which_key_ignore" }})
vim.keymap.set("n", "<s-m>", ":lua require('harpoon.mark').add_file()<cr>", { desc = "Harpoon file", silent = true })
vim.keymap.set(
    "n",
    "<Tab>",
    ":lua require('harpoon.ui').toggle_quick_menu()<cr>",
    { desc = "Show Harpooned files", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>1",
    ":lua require('harpoon.ui').nav_file(1)<cr>",
    { desc = "which_key_ignore", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>2",
    ":lua require('harpoon.ui').nav_file(2)<cr>",
    { desc = "which_key_ignore", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>3",
    ":lua require('harpoon.ui').nav_file(3)<cr>",
    { desc = "which_key_ignore", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>4",
    ":lua require('harpoon.ui').nav_file(4)<cr>",
    { desc = "which_key_ignore", silent = true }
)
vim.keymap.set(
    "n",
    "<leader>5",
    ":lua require('harpoon.ui').nav_file(5)<cr>",
    { desc = "which_key_ignore", silent = true }
)

-- Peek (Markdown preview)
table.insert(which_key_keys, { m = { name = "Markdown" } })
vim.keymap.set("n", "<leader>mp", function()
    local peek = require("peek")
    if peek.is_open() then
        peek.close()
    else
        peek.open()
    end
end, { desc = "Peek (Markdown Preview)" })

-- Cellular automaton
table.insert(which_key_keys, { c = { name = "Cellular" } })
vim.keymap.set("n", "<leader>cg", ":CellularAutomaton game_of_life<cr>", { desc = "Game of life" })
vim.keymap.set("n", "<leader>cm", ":CellularAutomaton make_it_rain<cr>", { desc = "Make it rain", silent = true })
vim.keymap.set("n", "<leader>cs", ":CellularAutomaton scramble<cr>", { desc = "Scramble", silent = true })

--Lazygit
table.insert(which_key_keys, { g = { name = "Git" } })
vim.keymap.set("n", "<leader>gg", ":LazyGit<cr>", { desc = "LazyGit", silent = true })

-- Trouble
table.insert(which_key_keys, { d = { name = "Diagnostics" } })
vim.keymap.set("n", "<leader>dd", function()
    require("trouble").toggle()
end, { desc = "Toggle Trouble", silent = true })

vim.keymap.set("n", "<leader>dn", function()
    require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Toggle Trouble", silent = true })

vim.keymap.set("n", "<leader>dp", function()
    require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "Toggle Trouble", silent = true })
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open Float", silent = true })

-- Folding with ufo
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zK', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end, { desc = "Peek Fold" })

-- Treesitter text objects
-- table.insert(which_key_keys, { s = { name = "Select" } })

-- LSP
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Goto declaration" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Goto definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover info" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Goto implementation" })
        vim.keymap.set("n", "S", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signarure help" })
        -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- vim.keymap.set('n', '<space>wl', function()
        --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        vim.keymap.set("n", "<space>ld", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Type definition" })
        vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
        vim.keymap.set({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Goto reperences" })
        vim.keymap.set("n", "<space>lF", function()
            vim.lsp.buf.format({ async = true })
        end, { buffer = ev.buf, desc = "Format LSP" })
        vim.keymap.set("n", "<space>lf", function()
            require("conform").format({ async = true })
        end, { buffer = ev.buf, desc = "Format Conform" })
    end,
})

-- Spectre (find and replace)
vim.keymap.set('n', '<leader>P', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

which_key.register(which_key_keys, { mode = "n", prefix = "<leader>" })
