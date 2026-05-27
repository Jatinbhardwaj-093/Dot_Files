-- ~/.config/nvim/lua/plugins/yazi.lua

return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- Open Yazi at the current file's directory
    {
      "<leader>y",
      "<cmd>Yazi<cr>",
      desc = "Open Yazi at the current file",
    },
    -- Open Yazi at the Neovim working directory (cwd)
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open Yazi in current working directory",
    },
    -- Toggle Yazi (resume last session)
    {
      "<leader>yt",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last Yazi session",
    },
  },
  opts = {
    -- Automatically take over directory opening (replacing netrw)
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
