return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
    opts = {
      view_options = { show_hidden = true },
      -- let <C-h>/<C-l> move between panes instead of split/refresh
      keymaps = { ["<C-h>"] = false, ["<C-l>"] = false, ["<C-x>"] = "actions.select_split" },
    },
  },
}
