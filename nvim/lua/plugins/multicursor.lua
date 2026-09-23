-- multicursor.nvim, set up as in its README except that cursors are added with
-- Ctrl+Alt+Up/Down instead of the plain arrow keys
return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    lazy = false,
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local set = vim.keymap.set

      -- add or skip a cursor above/below the main cursor
      set({ "n", "x" }, "<C-A-Up>", function() mc.lineAddCursor(-1) end, { desc = "Cursor above" })
      set({ "n", "x" }, "<C-A-Down>", function() mc.lineAddCursor(1) end, { desc = "Cursor below" })
      set({ "n", "x" }, "<leader><Up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip line above" })
      set({ "n", "x" }, "<leader><Down>", function() mc.lineSkipCursor(1) end, { desc = "Skip line below" })
      -- same from insert (no stock insert-mode meaning, so nothing is overridden)
      set("i", "<C-A-Up>", "<C-o><C-A-Up>", { remap = true })
      set("i", "<C-A-Down>", "<C-o><C-A-Down>", { remap = true })

      -- add or skip a cursor at the next/previous match of the word or selection
      set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Cursor at next match" })
      set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
      set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end, { desc = "Cursor at prev match" })
      set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end, { desc = "Skip prev match" })

      -- add and remove cursors with Ctrl + left click
      set("n", "<C-LeftMouse>", mc.handleMouse)
      set("n", "<C-LeftDrag>", mc.handleMouseDrag)
      set("n", "<C-LeftRelease>", mc.handleMouseRelease)

      -- disable/enable cursors (only the main one moves while disabled)
      set({ "n", "x" }, "<C-q>", mc.toggleCursor)

      -- these apply only while there are several cursors
      mc.addKeymapLayer(function(layer)
        layer({ "n", "x" }, "<Left>", mc.prevCursor)
        layer({ "n", "x" }, "<Right>", mc.nextCursor)
        layer({ "n", "x" }, "<leader>x", mc.deleteCursor)
        layer("n", "<Esc>", function()
          if not mc.cursorsEnabled() then mc.enableCursors() else mc.clearCursors() end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
