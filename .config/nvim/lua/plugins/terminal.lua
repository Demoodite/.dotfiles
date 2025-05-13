return {
    {
        "numToStr/FTerm.nvim",
        opts = {},
        config = function(_, opts)
            local fterm = require("FTerm")
            fterm.setup(opts)

            vim.keymap.set("n", "<A-i>", fterm.toggle)
        end,
    },
}
