local options = {
  formatters_by_ft = {
    -- Web
    html = { "prettier" },
    css = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },

    -- Other langs
    lua = { "stylua" },
    python = { "ruff" },
    go = { "gofmt" },
    rust = { "rustfmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1500,
    lsp_fallback = true,
  },
}

return options
