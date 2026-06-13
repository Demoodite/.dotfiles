return {
    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "neovim/nvim-lspconfig",
            { "mason-org/mason.nvim", opts = {} },
            { "j-hui/fidget.nvim", opts = {} },
            "saghen/blink.cmp",
        },

        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("dmo-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

                    map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
                    map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
                    map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
                    map("<leader>vd", vim.diagnostic.open_float, "[V]iew [D]iagnostic float")

                    map("K", vim.lsp.buf.hover, "Hover", { "n", "x" })
                    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", { "n", "x" })

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
                    then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    if
                        client
                        and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                    then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                } or {},
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                neocmake = {},
                clangd = {},
                basedpyright = {},
                glsl_analyzer = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                phpactor = {},
            }

            for server_name, server_opts in pairs(servers) do
                server_opts.capabilities =
                    vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
                vim.lsp.config(server_name, server_opts)
            end

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
            })

            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed,
            })
        end,
    },
}
