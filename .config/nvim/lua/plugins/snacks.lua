-- ~/.config/nvim/lua/plugins/snacks.lua

-- Force Snacks to recognize Ghostty graphics when running inside tmux
vim.env.SNACKS_GHOSTTY = "true"

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    zen = {
      enabled = true,
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = {
        width = 120,
      },
      on_open = function(win)
        local indicator = Snacks.win({
          show = false,
          style = "zoom_indicator",
          zindex = win.opts.zindex + 1,
          wo = { winhighlight = "NormalFloat:SnacksZenIcon" },
        })
        indicator:open_buf()
        local text = "▍ ZEN  󰊠  "
        vim.api.nvim_buf_set_lines(indicator.buf, 0, -1, false, { text })
        indicator.opts.width = vim.api.nvim_strwidth(text)
        indicator:show()

        win:on("WinClosed", function()
          if indicator and indicator:valid() then
            indicator:close()
          end
        end, { win = true })
      end,
    },
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
