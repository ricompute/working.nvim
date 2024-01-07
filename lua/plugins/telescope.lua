return {
    -- telescope
    -- a nice seletion UI also to find and open files
    { 'nvim-telescope/telescope.nvim', config = function()
        local builtin = require('telescope.builtin')
        local wk = require("which-key")
        wk.register({
            f = {
                name = "find",
                f = { builtin.find_files, "find files" },
                g = { builtin.live_grep, "grep files" },
                b = { builtin.buffers, "find buffers" },
                h = { builtin.help_tags, "find help tags" },
                r = { "<cmd>Telescope bibex<cr>", "find references" },
                s = { "<cmd>Telescope luasnip<cr>", "find luasnips" }
            },
        }, { prefix = "<leader>" })
        -- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})    
        local telescope = require 'telescope'
        local actions = require('telescope.actions')
        local previewers = require("telescope.previewers")
        local new_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            filepath = vim.fn.expand(filepath)
            vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then return end
                if stat.size > 100000 then
                    return
                else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
            end)
        end
        telescope.setup {
            defaults = {
                buffer_previewer_maker = new_maker,
                file_ignore_patterns = { "node_modules", "%_files/*.html", "%_cache", ".git/", "site_libs", ".venv" },
                layout_strategy = "flex",
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                },
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                        ["<esc>"] = actions.close,
                        ["<c-j>"] = actions.move_selection_next,
                        ["<c-k>"] = actions.move_selection_previous,
                    }
                }
            },
            pickers = {
                find_files = {
                    hidden = true,
                    find_command = { "rg", "--no-ignore", "--files", "--hidden", "--glob", "!.git/*",
                        '--glob', '!**/.Rproj.user/*', '-L' },
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            }
        }
        telescope.load_extension('ui-select')
        telescope.load_extension('fzf')
        telescope.load_extension('ui-select')
        telescope.load_extension('file_browser')
        telescope.load_extension('bibtex')
        telescope.load_extension('luasnip')
        --telescope.load_extension('dap')
        -- telescope.load_extension('project')
    end
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    --{ 'nvim-telescope/telescope-dap.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'nvim-telescope/telescope-bibtex.nvim' },
    {
        "benfowler/telescope-luasnip.nvim",
        module = "telescope._extensions.luasnip",  -- if you wish to lazy-load
    },
    -- { 'nvim-telescope/telescope-project.nvim' },
    { 'nvim-lualine/lualine.nvim',
        dependencies = {
            { 'f-person/git-blame.nvim' },
        },
        config = function()
            local git_blame = require('gitblame')
            vim.g.gitblame_display_virtual_text = 0
            vim.o.shortmess = vim.o.shortmess .. "S" -- this is for the search_count function so lua can know this is `lua expression`
            --function for optimizing the search count 
            local function search_count()
                if vim.api.nvim_get_vvar("hlsearch") == 1 then
                    local res = vim.fn.searchcount({ maxcount = 999, timeout = 500 })

          if res.total > 0 then
            return string.format("%d/%d", res.current, res.total)
          end
        end

                return ""
            end
            local function macro_reg()
                return vim.fn.reg_recording()
            end
            require('lualine').setup {
                options = {
                    -- section_separators = '',
                    -- component_separators = '',
                    globalstatus = false,
                    --theme = "catppuccin",
                },
                sections = {
                    lualine_a = {'mode', {macro_reg, type = 'lua_expr', color = 'WarningMsg'} },
                    -- lualine_b = { { 'filename', path = 3 }, 'branch'},
                    -- lualine_b = {'branch', { search_count, type = 'lua_expr' } },
                    -- lualine_c = {
                    --     { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
                    -- },
                    lualine_c = { {'filename', path = 3} },
                    lualine_y = { { search_count, type = 'lua_expr' }, 'progress'}
                },
                extensions = { 'nvim-tree' },
            }
        end
    },
}

