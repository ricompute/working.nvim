return {
    { "williamboman/mason.nvim", config = function ()
        require("mason").setup()
    end
    },
    { "williamboman/mason-lspconfig.nvim", config = function ()
        require("mason-lspconfig").setup {
            ensure_installed = { 
                "lua_ls",
                "r_language_server",
                "pyright",
                "awk_ls",
                "bashls",
                "clangd",
                "cssls",
                "eslint",
                "emmet_ls",
                "gopls",
                "html",
                "jsonls",
                "julials",
                "ltex",
                "marksman",
                "vimls",
                "lemminx",
                "yamlls",
                "zls"
            },
            automatic_installation = true
        }
    end
    },
    { "neovim/nvim-lspconfig", 
        event = "BufReadPre",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            { "williamboman/mason.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "folke/neodev.nvim", opt = {} },
            { "microsoft/python-type-stubs", cond = false }
        },
        config = function ()
            -- BEGIN COPYING FROM QUARTO/quarto
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local util = require("lspconfig.util")

            local on_attach = function(client, bufnr)
                local function buf_set_keymap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                end
                local function buf_set_option(...)
                    vim.api.nvim_buf_set_option(bufnr, ...)
                end

                buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
                local opts = { noremap = true, silent = true }

                buf_set_keymap("n", "gS", "<cmd>Telescope lsp_document_symbols<CR>", opts)
                buf_set_keymap("n", "gD", "<cmd>Telescope lsp_type_definitions<CR>", opts)
                buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
                buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
                buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
                buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
                buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
                buf_set_keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
                buf_set_keymap("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
                client.server_capabilities.document_formatting = true
            end

            local on_attach_qmd = function(client, bufnr)
                local function buf_set_keymap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                end
                local function buf_set_option(...)
                    vim.api.nvim_buf_set_option(bufnr, ...)
                end

                buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
                local opts = { noremap = true, silent = true }

                buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
                buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
                buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
                buf_set_keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
                client.server_capabilities.document_formatting = true
            end

            local lsp_flags = {
                allow_incremental_sync = true,
                debounce_text_changes = 150,
            }

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
            vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
            })
            vim.lsp.handlers["textDocument/hover"] =
            vim.lsp.with(vim.lsp.handlers.hover, { border = require("misc.style").border })
            vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = require("misc.style").border })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            -- See https://github.com/neovim/neovim/issues/23291
            if capabilities.workspace == nil then
                capabilities.workspace = {}
                capabilities.workspace.didChangeWatchedFiles = {}
            end
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

            -- also needs:
            -- $home/.config/marksman/config.toml :
            -- [core]
            -- markdown.file_extensions = ["md", "markdown", "qmd"]
            lspconfig.marksman.setup({
                on_attach = on_attach_qmd,
                capabilities = capabilities,
                filetypes = { "markdown", "quarto" },
                root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
            })

            lspconfig.r_language_server.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
                settings = {
                    r = {
                        lsp = {
                            rich_documentation = false,
                        },
                    },
                },
            })

            lspconfig.cssls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
            })

            lspconfig.html.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
            })

            lspconfig.emmet_language_server.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
            })

            lspconfig.yamlls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = true,
                            url = "",
                        },
                    },
                },
            })

            lspconfig.dotls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
            })

            local function strsplit(s, delimiter)
                local result = {}
                for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
                    table.insert(result, match)
                end
                return result
            end

            local function get_quarto_resource_path()
                local f = assert(io.popen("quarto --paths", "r"))
                local s = assert(f:read("*a"))
                f:close()
                return strsplit(s, "\n")[2]
            end

            local lua_library_files = vim.api.nvim_get_runtime_file("", true)
            local lua_plugin_paths = {}
            local resource_path = get_quarto_resource_path()
            if resource_path == nil then
                vim.notify_once("quarto not found, lua library files not loaded")
            else
                table.insert(lua_library_files, resource_path .. "/lua-types")
                table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")
            end

            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        runtime = {
                            version = "LuaJIT",
                            plugin = lua_plugin_paths,
                        },
                        diagnostics = {
                            globals = { 
                                "vim", 
                                "quarto", 
                                "pandoc", 
                                "io", 
                                "string", 
                                "print", 
                                "require", 
                                "table" 
                            },
                            disable = { "trailing-space" },
                        },
                        workspace = {
                            library = lua_library_files,
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- See https://github.com/neovim/neovim/issues/23291
            -- disable lsp watcher.
            -- Too slow on linux for
            -- python projects
            -- where pyright and nvim both create many watchers otherwise
            -- if it is not fixed by
            -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
            -- up top
            -- local ok, wf = pcall(require, "vim.lsp._watchfiles")
            -- if ok then
            --   wf._watchfunc = function()
            --     return function() end
            --   end
            -- end

            lspconfig.pyright.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
                settings = {
                    python = {
                        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = false,
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
                root_dir = function(fname)
                    return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(
                        fname
                    ) or util.path.dirname(fname)
                end,
            })

            lspconfig.julials.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
            })

            lspconfig.bashls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
                filetypes = { "sh", "bash" },
            })
            -- END COPYING FROM QUARTO/quarto
        end 
    }
}
