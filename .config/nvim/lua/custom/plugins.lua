local plugins = {
  -- None-ls - Drop-in replacement for null-ls. This provides language server capabilities to nvim
  {
    "nvimtools/none-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

  -- Mason - Package manager for lazy nvim.
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python:

        --[[
        -- mypy seems to disagree with... everyone
        -- It pinned multiple CPUs to 100%, spawned several processes, 
        -- and seems to have a rampant memory leak as it quickly gobbles up 8 GB of RAM
        --]]
        -- "mypy", 
        "ruff",
        "ruff-lsp",
        --"pyright",
        "basedpyright",
        "black",

        -- TypeScript/JavaScript:
        "typescript-language-server",
        "eslint-lsp",
        "prettierd",
      },
    },
  },

  -- lspconfig - Enables configuration of language servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  -- Autotag - Automatically adds closing tags to HTML/jsx/tsx
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}

return plugins

