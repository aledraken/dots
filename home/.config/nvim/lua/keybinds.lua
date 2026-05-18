vim.g.mapleader = " " -- (space) used for other keybinds
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex) -- explore files
vim.keymap.set({"n", "v"}, "<S-C-y>", '"+y') -- system yank
vim.keymap.set({"n", "v"}, "<S-C-p>", '"+p') -- system paste
