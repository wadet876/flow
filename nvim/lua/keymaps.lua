local map = vim.keymap.set
local opts = { silent = true }

map({ "n", "v" }, "<Space>", "<Nop>", opts)

-- windows
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- buffers
map("n", "<S-l>", "<cmd>bnext<cr>", opts)
map("n", "<S-h>", "<cmd>bprevious<cr>", opts)
map("n", "<S-q>", "<cmd>bdelete<cr>", opts)

map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", opts)

-- save; from insert mode it stays in insert mode
map({ "n", "i" }, "<C-s>", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })

-- keep selection when indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- editor-style line moving and selecting (normal and visual mode)
-- Shift+Up/Down moves the line (or selection)
map("n", "<S-Down>", "<cmd>m .+1<cr>==", opts)
map("n", "<S-Up>", "<cmd>m .-2<cr>==", opts)
map("x", "<S-Down>", ":m '>+1<cr>gv=gv", opts)
map("x", "<S-Up>", ":m '<-2<cr>gv=gv", opts)

-- Alt+Arrow selects a column (block), VS Code style: Alt+Down extends the same
-- columns onto the next line, Alt/Ctrl+Alt+Right widens every line at once.
-- A plain arrow cancels a selection started this way; Ctrl-v stays stock.
local function alt_select(motion)
  return function()
    if vim.fn.mode() ~= "\22" then
      vim.b.alt_block = true
      return "<C-v>" .. motion
    end
    return motion
  end
end
for key, motion in pairs({ Left = "h", Right = "l", Up = "k", Down = "j" }) do
  map({ "n", "x" }, "<A-" .. key .. ">", alt_select(motion), { expr = true, silent = true })
end
for key, motion in pairs({ Left = "b", Right = "e" }) do
  map({ "n", "x" }, "<C-A-" .. key .. ">", alt_select(motion), { expr = true, silent = true })
end
for _, key in ipairs({ "Left", "Right", "Up", "Down" }) do
  map("x", "<" .. key .. ">", function()
    local m = vim.fn.mode()
    if m == "v" or (m == "\22" and vim.b.alt_block) then return "<Esc><" .. key .. ">" end
    return "<" .. key .. ">"
  end, { expr = true, silent = true })
end
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:n",
  callback = function() vim.b.alt_block = nil end,
})

-- break the undo step at spaces and punctuation, so undo goes back a word at a time
for _, ch in ipairs({ " ", ",", ".", ";", "!", "?" }) do
  map("i", ch, ch .. "<C-g>u", opts)
end
