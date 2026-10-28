return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {},
      },
      "mason-org/mason-lspconfig.nvim",
    },

    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff" },
        automatic_enable = false,
      })

      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
	  -- python = {
	  --          analysis = {
	  --            ignore = { "*" },
	  --          },
	  --        },
        },
      })

      vim.lsp.config("ruff", {
        on_attach = function(client)
          -- Let Pyright provide Python hover information.
          client.server_capabilities.hoverProvider = false
        end,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("server-lsp", { clear = true }),

        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end

          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
              autotrigger = true,
            })
          end

          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)

          vim.keymap.set("n", "<leader>bf", function()
            vim.lsp.buf.format({ bufnr = ev.buf })
          end, opts)

          vim.keymap.set("n", "<leader>br", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "x" }, "<leader>ca",
            vim.lsp.buf.code_action, opts)
        end,
      })

      vim.lsp.enable({ "lua_ls", "pyright", "ruff" })
    end,
  },
}
