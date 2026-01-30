vim.g.mapleader = " " -- leader key (space) used for other keybinds
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex) -- leader key + cd to explore files
vim.keymap.set({"n", "v"}, "<S-C-y>", '"+y') -- copy to system clipboard
vim.keymap.set({"n", "v"}, "<S-C-v>", '"+p') -- paste from system clipboard
