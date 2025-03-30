--return
--{
--	"catgoose/nvim-colorizer.lua",
--	event = "BufReadPre",
--	opts = { -- set to setup table
--	},
--}
return {
	"uga-rosa/ccc.nvim",
	config = function()
		local ccc = require 'ccc'
		ccc.setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
			inputs = {
				ccc.input.hsl,
				ccc.input.rgb,
				ccc.input.cmyk,
			},
		})	
	end,
}
