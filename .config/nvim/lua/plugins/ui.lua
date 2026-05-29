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

      -- Define custom colors for rainbow indent levels and active scope
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#fb4934" })     -- Gruvbox Red
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#fe8019" })  -- Gruvbox Orange
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#fabd2f" })  -- Gruvbox Yellow
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#b8bb26" })   -- Gruvbox Green
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#83a598" })    -- Gruvbox Blue
        vim.api.nvim_set_hl(0, "RainbowPurple", { fg = "#d3869b" })  -- Gruvbox Purple
        vim.api.nvim_set_hl(0, "RainbowAqua", { fg = "#8ec07c" })    -- Gruvbox Aqua

        -- Make active scope high contrast and bold
        vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#fe8019", bold = true })
      end)

      opts.indent.highlight = {
        "RainbowRed",
        "RainbowOrange",
        "RainbowYellow",
        "RainbowGreen",
        "RainbowBlue",
        "RainbowPurple",
        "RainbowAqua",
      }

      require("ibl").setup(opts)
      dofile(vim.g.base46_cache .. "blankline")
    end,
  },
}
