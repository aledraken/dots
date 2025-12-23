-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.termguicolors = true
vim.opt.cursorline = true -- highlights current line
vim.opt.nu = true -- enable line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.whichwrap = '<,>,h,l' -- allows going a line down/up when reaching end/beginning
vim.opt.clipboard = 'unnamedplus' -- sets the clipboard to system clipboard
vim.opt.expandtab = true -- when pressing tab actually uses spaces
vim.opt.shiftwidth = 2 -- how much space is added when pressing tab
