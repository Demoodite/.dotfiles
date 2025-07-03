return {
    {
        "stevearc/conform.nvim",
        dependencies = {
            { "zapling/mason-conform.nvim", opts = {} },
            { "WhoIsSethDaniel/mason-tool-installer.nvim", opts = {} },
        },
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        config = function(_, opts)
            local ensure_installed = {}

            for _, list in pairs(opts.formatters_by_ft) do
                for _, item in pairs(list) do
                    if type(item) == "string" then
                        table.insert(ensure_installed, tostring(item))
                    end
                end
            end

            for item, _ in pairs(opts.formatters) do
                table.insert(ensure_installed, tostring(item))
            end

            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
            require("conform").setup(opts)
        end,
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = "fallback",
                    }
                end
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                cmake = { "gersemi" },
                cpp = { "clang-format" },
                c = { "clang-format" },
            },
            formatters = {
                stylua = { prepend_args = { "--indent-type", "spaces" } },
                ["clang-format"] = { prepend_args = { "--style={IndentWidth: 4}" } },
            },
        },
    },
}
