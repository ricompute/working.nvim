
-- Move selected lines up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Append next line without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centered when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Capital S to search and replace
vim.keymap.set("n", "S", ":%s//g<Left><Left>")

local wk = require("which-key")
wk.register({
    f = {
        name = "find/files",
        v = { vim.cmd.Ex, "Netrw" }
    },
    v = {
        name = "vim",
        l = { vim.cmd.Lazy, "Lazy" },
        m = { vim.cmd.Mason, "Mason" }
    },
    t = {
        name = "tabs",
        n = { vim.cmd.tabnew, "new tab" },
        h = { vim.cmd.tabprevious, "previous tab" },
        l = { vim.cmd.tabnext, "next tab" },
        s = { vim.cmd.split, "horizontal split" },
        v = { vim.cmd.vsplit, "vertical split" }
    },
    c = {
        name = 'code',
        c = { ':SlimeConfig<cr>', 'slime config' },
        n = { ':split term://$SHELL<cr>', 'new terminal' },
        r = { ':split term://R --no-save<cr>', 'new R terminal' },
        p = { ':split term://python<cr>', 'new python terminal' },
        i = { ':split term://ipython<cr>', 'new ipython terminal' },
        j = { ':split term://julia<cr>', 'new julia terminal' },
        v = {
            name = 'vertical',
            n = { ':vsplit term://$SHELL<cr>', 'new terminal' },
            r = { ':vsplit term://R --no-save<cr>', 'new R terminal' },
            p = { ':vsplit term://python<cr>', 'new python terminal' },
            i = { ':vsplit term://ipython<cr>', 'new ipython terminal' },
            j = { ':vsplit term://julia<cr>', 'new julia terminal' },
        },
    },
    s = {
        name = 'snips',
        s = { "<cmd>source ~/.config/nvim/lua/ricompute/snips.lua<CR>", "source LuaSnips file"},
    }
}, { prefix = "<leader>" })

vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Move between windows using <ctrl> direction
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-l>", "<C-W>l")

-- Resize window using <shift> arrow keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

vim.keymap.set("n", "Q", "<Nop>")

-- Escape from insert mode with jj
vim.keymap.set("i", "jj", "<Esc>")

-- Escape from terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- send code with ctrl+Enter
-- just like in e.g. RStudio
-- needs kitty (or other terminal) config:
-- map shift+enter send_text all \x1b[13;2u
-- map ctrl+enter send_text all \x1b[13;5u
vim.keymap.set("n", '<c-cr>', '<Plug>SlimeSendCell')
vim.keymap.set("n", '<s-cr>', '<Plug>SlimeSendCell')
vim.keymap.set("i", '<c-cr>', '<esc><Plug>SlimeSendCell<cr>i')
vim.keymap.set("i", '<s-cr>', '<esc><Plug>SlimeSendCell<cr>i')

-- send code with Enter and leader Enter
vim.keymap.set("v", '<cr>', '<Plug>SlimeRegionSend')
vim.keymap.set("n", '<leader><cr>', '<Plug>SlimeSendCell')

-- keep selection after indent/dedent
vim.keymap.set("v", '>', '>gv')
vim.keymap.set("v", '<', '<gv')

-- remove search highlight on esc
vim.keymap.set("n", '<esc>', '<cmd>noh<cr>')

