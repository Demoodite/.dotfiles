return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "1.*",
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                documentation = { auto_show = false, auto_show_delay_ms = 500 },
            },

            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },

            fuzzy = { implementation = "lua" },
            signature = { enabled = true },
        },
    },
}
