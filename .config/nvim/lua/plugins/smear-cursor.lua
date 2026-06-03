return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    cursor_color = "#fabd2f", -- Gruvbox vibrant gold/yellow
    stiffness = 0.8,         -- Physics stiffness (higher is faster)
    trailing_stiffness = 0.5,
    trailing_exponent = 4,   -- Exponent for trailing speed (creates a sharp ninja slice fade!)
  },
}
