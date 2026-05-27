-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- Code formatting configuration using Conform
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- LSP core configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")

      -- Diagnostic configuration (Rounded border, floats, etc.)
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      vim.o.updatetime = 250

      -- Open diagnostics float on CursorHold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
          })
        end,
      })

      -- Rounded border for hover handler
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = "rounded",
        }
      )

      -- Hover keymap
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Info" })
    end,
  },

  -- Fidget for beautiful real-time LSP progress spinners
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
}
