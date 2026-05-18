vim.pack.add ({
	"https://github.com/catgoose/nvim-colorizer.lua",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})


--vim.cmd.colorscheme('solarized')
--vim.opt.background = 'light'


require('colorizer').setup()

require('lualine').setup{
	options = {
		icons_enabled = true,
		theme = 'auto',
	}
}
