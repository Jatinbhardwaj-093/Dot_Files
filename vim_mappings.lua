-- ~/.config/nvim/lua/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlight" })
map("i", "jk", "<ESC>")
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
map("v", "<C-c>", "<Esc>", { desc = "Exit visual mode" })
map("i", "<C-l>", function()
  return vim.fn["codeium#AcceptNextLine"]()
end, { expr = true, silent = true, desc = "Codeium Accept Line" })
map("i", "<C-k>", function()
  return vim.fn["codeium#AcceptNextWord"]()
end, { expr = true, silent = true, desc = "Codeium Accept Word" })
map("i", "<C-;>", function()
  return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true, desc = "Codeium Next Suggestion" })
map("n", "dd", '"_dd', { noremap = true })
map("v", "d", '"_d', { noremap = true })
map("n", "_dd", "dd", { noremap = true })
map("v", "_d", "d", { noremap = true })

-- file movement
vim.keymap.set("n", "<leader>x", ":bd<CR>")
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- terminal
vim.keymap.set("n", "<leader>t", ":terminal<CR>")
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Comment toggle keymaps (Cmd+/ translated via Ctrl+/ and Ctrl+_)
map("n", "<C-_>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment toggle line" })

-- Add blank line below / above without leaving Normal mode
map("n", "<leader>o", "o<Esc>", { desc = "Insert newline below" })
map("n", "<leader>O", "O<Esc>", { desc = "Insert newline above" })

-- Copy file paths to clipboard
map("n", "<leader>cf", function()
  local filename = vim.fn.expand("%:t")
  vim.fn.setreg("+", filename)
  vim.notify("Copied filename: " .. filename)
end, { desc = "Copy filename (with extension)" })

map("n", "<leader>cn", function()
  local filename = vim.fn.expand("%:t:r")
  vim.fn.setreg("+", filename)
  vim.notify("Copied filename without extension: " .. filename)
end, { desc = "Copy filename (no extension)" })

map("n", "<leader>cd", function()
  local dirpath = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", dirpath)
  vim.notify("Copied directory path: " .. dirpath)
end, { desc = "Copy directory path" })

map("n", "<leader>cc", function()
  local fullpath = vim.fn.expand("%:p")
  vim.fn.setreg("+", fullpath)
  vim.notify("Copied full path: " .. fullpath)
end, { desc = "Copy full path" })
