return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    current_line_blame = false,
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview Hunk" })
    vim.keymap.set("n", "<leader>hb", ":Gitsigns blame_line<CR>", { desc = "Git Blame Line" })
    vim.keymap.set("n", "<leader>hd", ":Gitsigns diffthis<CR>", { desc = "Git Diff This" })
  end,
}
