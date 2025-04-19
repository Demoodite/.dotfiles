local g = vim.g
-- local o = vim.o
local opt = vim.opt

g.python_recommended_style = 0
g.rust_recommended_style = 0
g.have_nerd_font = true

opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Number of spaces for autoindent
opt.softtabstop = 4 -- Number of spaces per tab press
opt.tabstop = 4 -- Number of spaces a tab counts for

opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.undofile = true
opt.showmode = false
opt.signcolumn = "yes"
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 10
-- vim: ts=2 sts=2 sw=2 et
