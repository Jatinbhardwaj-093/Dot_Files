-- ~/.config/nvim/lua/plugins/venv-selector.lua

return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  opts = {
    auto_refresh = true,
    settings = {
      options = {
        notify_user_on_venv_activation = true,
      },
    },
  },
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Virtual Environment" },
    { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Virtual Environment" },
  },
}
