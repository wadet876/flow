-- :restart saves a session, and a visible oil window writes `file oil://...`
-- into it, which errors on restore (E95) and aborts it half way: buffers come
-- back with no filetype and no highlighting. Drop oil windows first.
local function drop_oil_windows()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "oil" then
      if #vim.api.nvim_list_wins() > 1 then
        vim.api.nvim_win_close(win, true)
      else
        vim.api.nvim_win_call(win, function() vim.cmd("enew") end)
      end
    end
  end
end

vim.api.nvim_create_user_command("Restart", function(o)
  drop_oil_windows()
  vim.cmd("restart" .. (o.bang and "!" or ""))
end, { bang = true })

-- so plain :restart goes through the command above
vim.cmd([[cnoreabbrev <expr> restart (getcmdtype() == ':' && getcmdline() ==# 'restart') ? 'Restart' : 'restart']])
