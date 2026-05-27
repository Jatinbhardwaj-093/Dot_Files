-- ~/.config/nvim/lua/plugins/coding.lua

return {
  -- Autocomplete engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- complete words from buffer
      "hrsh7th/cmp-path",   -- complete file paths
      "hrsh7th/cmp-nvim-lsp", -- complete words from LSP
      "hrsh7th/cmp-nvim-lua", -- complete neovim lua API
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),          -- trigger completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection
          ["<Tab>"] = cmp.mapping.select_next_item(),      -- next item
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),    -- previous item
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- Commenting utility (gcc to comment line, gc in visual mode)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto pairing of brackets/parentheses
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Surround text with quotes/parentheses (ysiw" or ds" or cs"')
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- AI Autocomplete (Free alternative to Copilot)
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },

  -- Diagnostics & list view
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {},
  },

  -- Auto-close & auto-rename HTML/XML tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Treesj to split/join blocks of code using Treesitter
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Split or Join code block" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
  },

  -- Flash for ultra-fast, visual navigation jumps
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
