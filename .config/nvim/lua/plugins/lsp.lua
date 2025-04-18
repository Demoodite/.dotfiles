return {
    {
	"williamboman/mason.nvim",
	opts = function()
	    require("mason").setup()
	end
    },
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
	"neovim/nvim-lspconfig",
	config = function()
	    local lspconfig = require("lspconfig")
	    local servers = { "lua_ls", "pyright" }

	    for _, server in ipairs(servers) do
		lspconfig[server].setup({})
	    end
	end
    }
}
