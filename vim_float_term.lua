-- ~/.config/nvim/lua/float_term.lua

local state = {
  buf = -1,
  win = -1,
}

local function toggle_float_terminal()
  -- If window is open and valid, close it
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = -1
  else
    -- Calculate window dimensions (80% of editor size)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Create or retrieve buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(state.buf) then
      buf = state.buf
    else
      buf = vim.api.nvim_create_buf(false, true) -- no file, scratch
      state.buf = buf
    end

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      style = "minimal",
      border = "rounded",
    })
    state.win = win

    -- If the buffer is not already a terminal, spawn the terminal shell
    if vim.bo[buf].buftype ~= "terminal" then
      vim.fn.termopen(os.getenv("SHELL") or "zsh")
      
      -- Automatically enter insert mode when switching to this buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        buffer = buf,
        callback = function()
          vim.cmd("startinsert")
        end
      })
    end
    
    -- Ensure we enter insert mode immediately on creation
    vim.cmd("startinsert")
  end
end

-- Create the user command :FloatTerm
vim.api.nvim_create_user_command("FloatTerm", toggle_float_terminal, {})

-- Map <leader>ft in Normal and Terminal modes to toggle the terminal
vim.keymap.set({ "n", "t" }, "<leader>ft", toggle_float_terminal, { desc = "Toggle floating terminal" })
