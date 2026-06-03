return {
  "lukas-reineke/indent-blankline.nvim",
  event = "User FilePost",
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      injected_languages = true,
      highlight = { "IblScopeChar" },
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "blankline")

    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

    -- Define custom colors for rainbow indent levels and active scope linked to rainbow brackets
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- Fallback colors for RainbowDelimiter groups in case they aren't configured by the theme
      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#fb4934", default = true })     -- Gruvbox Red
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#fabd2f", default = true })  -- Gruvbox Yellow
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#83a598", default = true })    -- Gruvbox Blue
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#fe8019", default = true })  -- Gruvbox Orange
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#b8bb26", default = true })   -- Gruvbox Green
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#d3869b", default = true })  -- Gruvbox Purple/Violet
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#8ec07c", default = true })    -- Gruvbox Aqua/Cyan

      -- Faded/muted colors for rainbow indent lines to prevent visual noise
      vim.api.nvim_set_hl(0, "RainbowIndentRed", { fg = "#5a3e3f" })
      vim.api.nvim_set_hl(0, "RainbowIndentYellow", { fg = "#5a523e" })
      vim.api.nvim_set_hl(0, "RainbowIndentBlue", { fg = "#3e4d5a" })
      vim.api.nvim_set_hl(0, "RainbowIndentOrange", { fg = "#5a473e" })
      vim.api.nvim_set_hl(0, "RainbowIndentGreen", { fg = "#465a3e" })
      vim.api.nvim_set_hl(0, "RainbowIndentViolet", { fg = "#503e5a" })
      vim.api.nvim_set_hl(0, "RainbowIndentCyan", { fg = "#3e5a51" })

      -- Make active scope high contrast and bold
      vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#fe8019", bold = true })
    end)

    -- Use custom faded highlight groups for indentation lines
    opts.indent.highlight = {
      "RainbowIndentRed",
      "RainbowIndentYellow",
      "RainbowIndentBlue",
      "RainbowIndentOrange",
      "RainbowIndentGreen",
      "RainbowIndentViolet",
      "RainbowIndentCyan",
    }

    require("ibl").setup(opts)
    dofile(vim.g.base46_cache .. "blankline")
  end,
}
