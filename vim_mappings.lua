-- ~/.config/nvim/lua/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlight" })
map("i", "jk", "<ESC>")
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
map("v", "<C-c>", "<Esc>", { desc = "Exit visual mode" })
map("i", "<C-l>", function() return vim.fn["codeium#AcceptNextLine"]() end, { expr = true, silent = true, desc = "Codeium Accept Line" })
map("i", "<C-k>", function() return vim.fn["codeium#AcceptNextWord"]() end, { expr = true, silent = true, desc = "Codeium Accept Word" })
map("i", "<C-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true, desc = "Codeium Next Suggestion" })
map("n", "dd", '"_dd', { noremap = true })
map("v", "d", '"_d', { noremap = true })
map("n", "_dd", "dd", { noremap = true })
map("v", "_d", "d", { noremap = true })

-- file movement
vim.keymap.set('n', '<leader>x', ':bd<CR>')
vim.keymap.set('n', '<S-l>', ':bnext<CR>')
vim.keymap.set('n', '<S-h>', ':bprevious<CR>')

-- terminal
vim.keymap.set('n', '<leader>t', ':terminal<CR>')
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Comment toggle keymaps (Cmd+/ translated via Ctrl+/ and Ctrl+_)
map("n", "<C-_>", function() require("Comment.api").toggle.linewise.current() end, { desc = "Comment toggle line" })
map("n", "<C-/>", function() require("Comment.api").toggle.linewise.current() end, { desc = "Comment toggle line" })
map("v", "<C-_>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Comment toggle selection" })
map("v", "<C-/>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Comment toggle selection" })
