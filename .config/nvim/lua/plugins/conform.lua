-- ~/.config/nvim/lua/plugins/conform.lua

-- LINE WIDTHS: Change these numbers to adjust line lengths per language
local python_line_length = "120"
local js_ts_css_html_line_length = "120"
local lua_column_width = "120"

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "jq" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true,
    },
    formatters = {
      black = {
        args = { "--line-length", python_line_length, "--stdin-filename", "$FILENAME", "-" },
      },
      prettier = {
        args = { "--print-width", js_ts_css_html_line_length, "--stdin-filepath", "$FILENAME" },
      },
      stylua = {
        args = { "--column-width", lua_column_width, "--stdin-filepath", "$FILENAME", "-" },
      },
    },
  },
}
