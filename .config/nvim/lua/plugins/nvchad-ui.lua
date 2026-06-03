return {
  "NvChad/ui",
  opts = {
    statusline = {
      order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "venv", "cwd", "cursor" },
      modules = {
        -- Replace default file module with Relative Path representation
        file = function()
          local path = vim.fn.expand("%:p:~:.")
          if path == "" then
            return ""
          end
          local utils = require "nvchad.stl.utils"
          local x = utils.file()
          local sep_style = require("nvconfig").ui.statusline.separator_style
          local sep_r = utils.separators[sep_style]["right"]
          
          -- formatted nicely like:  󰈚  a / b / c / d.py 
          return "%#St_file# " .. x[1] .. " " .. path:gsub("/", " / ") .. " %#St_file_sep#" .. sep_r
        end,

        -- Custom Python Virtual Environment Indicator
        venv = function()
          local status, venv_selector = pcall(require, "venv-selector")
          if not status then
            return ""
          end
          local venv = venv_selector.get_active_venv()
          if venv then
            local name = venv:match("([^/]+)/?$")
            if name then
              return "%#St_Lsp#  " .. name .. " "
            end
          end
          return ""
        end,
      },
    },
  },
}
