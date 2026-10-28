return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local ts = require("nvim-treesitter")

    local install_dir = vim.fn.stdpath("data") .. "/site"

    ts.setup({
      install_dir = install_dir,
    })

    vim.opt.runtimepath:prepend(install_dir)

      -- Install parsers asynchronously.
      -- CSS and JavaScript also support embedded content in HTML.
      ts.install({
        "python",
        "lua",
        "bash",
        "html",
        "css",
        "javascript",
        "json",
        "yaml",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
      }):wait(300000)

      -- Highlighting only: leave indentexpr and folding unchanged.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(
          "server-treesitter-highlight",
          { clear = true }
        ),

        pattern = {
          "python",
          "lua",
          "sh",
          "bash",
          "html",
          "css",
          "javascript",
          "json",
          "yaml",
          "vim",
          "help",
        },

        callback = function(ev)
          -- A parser may still be installing on the first launch.
          -- Fall back to normal syntax highlighting if unavailable.
          local ok = pcall(vim.treesitter.start, ev.buf)
          if not ok then
            vim.bo[ev.buf].syntax = vim.bo[ev.buf].filetype
          end
        end,
      })
    end,
  },

  -- Keep these available in the configuration, but disabled.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    enabled = false,
  },

  {
    "windwp/nvim-ts-autotag",
    enabled = false,
  },
}
