return {
  "OXY2DEV/markview.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.api.nvim_create_user_command("Preview", function()
      vim.cmd("Markview toggle")
    end, {})
  end,
}
