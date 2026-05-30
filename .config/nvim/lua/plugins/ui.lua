-- ~/.config/nvim/lua/plugins/ui.lua

return {
  -- High-performance file explorer representing files as buffer text
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Virtual vertical guide line at 80/120 columns
  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    opts = {
      char = "│",
      virtcolumn = "80,120",
      highlight = "VirtColumn",
    },
  },

  -- Nvim tree sidebar file explorer
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filesystem_watchers = {
        enable = true,
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },
  },

  -- Markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  -- High-fidelity rendering of markdown syntax inside buffer
  {
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
  },

  -- Rainbow parenthetical colorization (makes matching brackets pop out beautifully!)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
  },

  -- Statusline enhancements (NvChad native statusline custom modules)
  {
    "NvChad/ui",
    opts = {
      statusline = {
        overriden_modules = function(modules)
          -- Replace filename module (index 5) with relative path representation
          modules[5] = function()
            local path = vim.fn.expand("%:p:~:.")
            if path == "" then
              return ""
            end
            -- a/b/c/d.py -> a / b / c / d.py
            return " " .. path:gsub("/", " / ") .. " "
          end
          return modules
        end,
      },
    },
  },

  -- Ninja-like smear trail animation when the cursor moves!
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      cursor_color = "#fabd2f", -- Gruvbox vibrant gold/yellow
      stiffness = 0.8,         -- Physics stiffness (higher is faster)
      trailing_stiffness = 0.5,
      trailing_exponent = 4,   -- Exponent for trailing speed (creates a sharp ninja slice fade!)
    },
  },


  -- Colorizer to highlight color hex codes inside buffers
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },

  -- Vim Tmux Navigator for seamless navigation between tmux panes and Neovim windows
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Custom rainbow indent guides to match the stunning aesthetic in your screenshot!
  {
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
  },
}
