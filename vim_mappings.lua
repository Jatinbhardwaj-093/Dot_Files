-- ~/.config/nvim/lua/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<C-l>", function() return vim.fn["codeium#AcceptNextLine"]() end, { expr = true, silent = true, desc = "Codeium Accept Line" })
map("i", "<C-k>", function() return vim.fn["codeium#AcceptNextWord"]() end, { expr = true, silent = true, desc = "Codeium Accept Word" })
map("i", "<C-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true, desc = "Codeium Next Suggestion" })
map("n", "dd", '"_dd', { noremap = true })
map("v", "d", '"_d', { noremap = true })
map("n", "_dd", "dd", { noremap = true })
map("v", "_d", "d", { noremap = true })
