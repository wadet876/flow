-- servers that install without node; add pyright/bashls/jsonls once npm is on the box
local SERVERS = { "clangd", "lua_ls", "basedpyright" }

return {
  { "mason-org/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate" }, opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

      -- SystemVerilog through Verible, already on PATH so not in mason's list. With no
      -- verible.filelist it indexes only the buffers open here, never the tree; it starts only
      -- inside a repo with a .rules.verible_lint, and lints with that repo's rules and waivers.
      vim.lsp.config("verible", {
        cmd = function(dispatchers, config)
          -- ruleset=none: the repo's rules file is the whole authority, as in make lint.
          -- No push diagnostics: nvim pulls them, and taking both shows every one twice.
          local cmd = {
            "verible-verilog-ls",
            "--rules_config_search",
            "--ruleset=none",
            "--push_diagnostic_notifications=false",
          }
          local waivers = config.root_dir and (config.root_dir .. "/.verible_waivers")
          if waivers and vim.uv.fs_stat(waivers) then
            table.insert(cmd, "--waiver_files=" .. waivers)
          end
          return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
        end,
        filetypes = { "systemverilog", "verilog" },
        root_markers = { ".rules.verible_lint" },
        workspace_required = true,
      })
      vim.lsp.enable("verible")
      require("mason-lspconfig").setup({ ensure_installed = SERVERS })

      vim.diagnostic.config({ severity_sort = true, virtual_text = true, float = { border = "rounded" } })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("gl", vim.diagnostic.open_float, "Line diagnostics")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>lr", vim.lsp.buf.rename, "Rename")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        end,
      })
    end,
  },
}
