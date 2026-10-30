-- ~/.config/nvim/init.lua

-- Neovim 0.12+ compatibility fix for treesitter custom directives/predicates
-- (Neovim 0.12 passes captures as table<id, TSNode[]>, while older directives expect TSNode)
do
  local orig_get_node_text = vim.treesitter.get_node_text
  vim.treesitter.get_node_text = function(node, source, opts)
    if type(node) == "table" and not getmetatable(node) then
      node = node[1]
    end
    if not node then
      return ""
    end
    return orig_get_node_text(node, source, opts)
  end

  local orig_get_range = vim.treesitter.get_range
  vim.treesitter.get_range = function(node, source, metadata)
    if type(node) == "table" and not getmetatable(node) then
      node = node[1]
    end
    return orig_get_range(node, source, metadata)
  end
end

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)
vim.opt.number = true
vim.opt.relativenumber = true

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"
require "float_term"

vim.schedule(function()
  require "mappings"
end)

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("i", "<M-b>", "<Esc>bi")
vim.keymap.set("i", "<M-f>", "<Esc>ea")
vim.keymap.set("i", "<M-BS>", "<Esc>dbi")
