return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = require "configs.mason-tools",
      integrations = {
        ["mason-lspconfig"] = true,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Neovim (defaults)
        "lua",
        "vim",
        "vimdoc",

        -- Web
        "html",
        "css",
        "scss",
        "javascript",
        "jsx",
        "jsdoc",
        "typescript",
        "tsx",
        "json",
        "angular",

        -- Terminal
        "bash",
        "zsh",

        -- C
        "c",
        "cpp",
        "cmake",
        "c_sharp",

        -- Godot
        "gdscript",
        "gdshader",
        "godot_resource",

        -- Git
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",

        -- Java
        "java",
        "javadoc",
        "properties",
        "kotlin",

        -- Python
        "python",
        "requirements",

        -- Misc.
        "desktop",
        "diff",
        "dockerfile",
        "editorconfig",
        "gpg",
        "http",
        "markdown",
        "markdown_inline",
        "nginx",
        "ninja",
        "make",
        "passwd",
        "ssh_config",
        "strace",
        "tmux",
        "toml",
        "xml",
        "yaml",

        -- Misc. Languages
        "go",
        "rust",
        "latex",
        "sql",
      },
    },
  },
}
