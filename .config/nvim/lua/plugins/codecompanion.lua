-- ~/.config/nvim/lua/plugins/codecompanion.lua

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
    })
  end,
  keys = {
    -- Toggle Chat Panel (Normal and Visual mode to ask questions about selected code!)
    { "<leader>cc", "<cmd>CodeCompanionToggle<cr>", desc = "Toggle CodeCompanion Chat", mode = { "n", "v" } },
    
    -- Show CodeCompanion AI Actions menu (explain, optimize, fix, test, etc.)
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
    
    -- Trigger Inline Code Assistant (Gemini will write/refactor directly in the buffer)
    { "<leader>ci", "<cmd>CodeCompanion<cr>", desc = "Inline Code Assistant", mode = { "n", "v" } },
  }
}
