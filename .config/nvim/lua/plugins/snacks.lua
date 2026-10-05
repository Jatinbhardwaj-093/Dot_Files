-- ~/.config/nvim/lua/plugins/snacks.lua

-- Force Snacks to recognize Ghostty graphics when running inside tmux
vim.env.SNACKS_GHOSTTY = "true"

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    image = {
      enabled = true,
      force = true, -- display images even if terminal query is delayed/obscured by tmux
      doc = {
        enabled = true,
        inline = true,
        float = true,
        max_width = 80,
        max_height = 40,
      },
    },
  },
}
