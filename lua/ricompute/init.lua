vim.g.mapleader = " "

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.smartindent = true

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

--vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50


vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.autowrite = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimport()
    end,
    group = format_sync_grp,
})

-- Set up spelling
vim.g.spelllang_is_en_us = false
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "tex", "plaintex", "latex", "pandoc", "markdown", "md", 
        "rmarkdown", "rmd", "qmd", "quarto" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
        vim.g.spelllang_is_en_us = true
    end
})
vim.opt_local.spellfile:append { "~/.vim/spell/en.utf-8.add", "local.utf-8.add" }
vim.keymap.set("n", "<F7>", function()
    if vim.g.spelllang_is_en_us then
        vim.opt.spell = true
        vim.opt.spelllang = ""
        vim.g.spelllang_is_en_us = false
    else
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
        vim.g.spelllang_is_en_us = true
    end
end)

-- LaTeX autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "latex", "plaintex" },
    callback = function()
        vim.keymap.set("n", "<F3>", ":w !detex \\| wc -w<CR>")
        vim.keymap.set("i", "<F3>", "<Esc>:w !detex \\| wc -w<CR>a")
        vim.keymap.set("n", "<F5>", ":!xelatex<Space><C-r>%<Enter>")
        vim.keymap.set("i", "<F5>", "<Esc>:!xelatex<Space><C-r>%<Enter>a")
    end
})

-- Markdown autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "md" },
    callback = function()
        vim.keymap.set("n", "<F5>", ":!pandoc-html <C-r>%<Enter>")
        vim.keymap.set("i", "<F5>", "<Esc>:!pandoc-html <C-r>%<Enter>a")
        vim.keymap.set("n", "<F6>", ":AsyncRun pandoc-html <C-r>%<Enter>")
        vim.keymap.set("i", "<F6>", "<Esc>:AsyncRun pandoc-html <C-r>%<Enter>a")
        vim.keymap.set("n", "<C-F5>", ":!pandoc-html-toc <C-r>%<Enter>")
        vim.keymap.set("i", "<C-F5>", "<Esc>:!pandoc-html-toc <C-r>%<Enter>a")
        vim.keymap.set("n", "<C-F6>", ":AsyncRun pandoc-html-toc <C-r>%<Enter>")
        vim.keymap.set("i", "<C-F6>", "<Esc>:AsyncRun pandoc-html-toc <C-r>%<Enter>a")
        vim.keymap.set("n", "<C-S-F5>", ":!pandoc-html-toc-sc <C-r>%<Enter>")
        vim.keymap.set("i", "<C-S-F5>", "<Esc>:!pandoc-html-toc-sc <C-r>%<Enter>a")
        vim.keymap.set("n", "<C-S-F6>", ":AsyncRun pandoc-html-toc-sc <C-r>%<Enter>")
        vim.keymap.set("i", "<C-S-F6>", "<Esc>:AsyncRun pandoc-html-toc-sc <C-r>%<Enter>a")
    end
})

-- R Markdown autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rmarkdown", "rmd" },
    callback = function()
        vim.keymap.set("n", "<F5>", ":!echo<Space>\"rmarkdown::render('<C-r>%')\"<Space>|<Space>r<Enter>")
        vim.keymap.set("i", "<F5>", "<Esc>:!echo<Space>\"rmarkdown::render('<C-r>%')\"<Space>|<Space>r<Enter>a")
        vim.keymap.set("n", "<F6>", ":AsyncRun echo<Space>\"rmarkdown::render('<C-r>%')\"<Space>|<Space>r<Enter>")
        vim.keymap.set("i", "<F6>", "<Esc>:AsyncRun echo<Space>\"rmarkdown::render('<C-r>%')\"<Space>|<Space>r<Enter>a")
    end
})

-- lilypond autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ly" },
    callback = function()
        vim.keymap.set("n", "<F5>", ":! lilypond <C-r>%<Enter>")
        vim.keymap.set("i", "<F5>", "<Esc>:! lilypond <C-r>%<Enter>a")
        vim.keymap.set("n", "<F6>", ":AsyncRun lilypond <C-r>%<Enter>")
        vim.keymap.set("i", "<F6>", "<Esc>:AsyncRun lilypond <C-r>%<Enter>a")
        vim.keymap.set("n", "<C-F5>", ":! ly2mp3 <C-r>%<Enter>")
        vim.keymap.set("i", "<C-F5>", "<Esc>:! ly2mp3 <C-r>%<Enter>a")
        vim.keymap.set("n", "<C-F6>", ":AsyncRun ly2mp3 <C-r>%<Enter>")
        vim.keymap.set("i", "<C-F6>", "<Esc>:AsyncRun ly2mp3 <C-r>%<Enter>a")
    end
})

-- Fix my spelling
vim.cmd("abbr adn and")
vim.cmd("abbr nad and")
vim.cmd("abbr teh the")
vim.cmd("abbr hte the")
vim.cmd("abbr wiht with")

