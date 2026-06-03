return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer", -- complete words from buffer
    "hrsh7th/cmp-path", -- complete file paths
    "hrsh7th/cmp-nvim-lsp", -- complete words from LSP
    "hrsh7th/cmp-nvim-lua", -- complete neovim lua API
    "hrsh7th/cmp-cmdline", -- complete commands in command line mode
  },
  config = function()
    local cmp = require "cmp"

    cmp.setup {
      mapping = {
        ["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
        ["<CR>"] = cmp.mapping.confirm { select = true }, -- confirm selection
        ["<Tab>"] = cmp.mapping.select_next_item(), -- next item
        ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous item
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "path" },
      },
    }

    -- Setup for search (/) and backward search (?)
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Setup for command-line (:)
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
