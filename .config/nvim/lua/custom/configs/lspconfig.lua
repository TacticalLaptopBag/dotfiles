local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

-- The names of the language servers in lspconfig
local servers = {
  --"pyright",
  "basedpyright",
  "tsserver",
  "eslint",
  "ruff_lsp",
}

-- Setup each language server
for _, lsp in ipairs(servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities
  }

  -- pyright-specific configuration
  --if lsp == "pyright" then
  if lsp == "basedpyright" then
    opts.filetypes = {"python"}
  end

  -- ruff_lsp config
  if lsp == "ruff_lsp" then
    opts.init_options = {
      settings = {
        enable = true,
        organizeImports = true,
        fixAll = true,
        lint = {
          enable = true,
          run = "onType",
        },
      },
    }
  end

  lspconfig[lsp].setup(opts)
end

-- lspconfig.pyright.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = {"python"},
-- })
--
-- lspconfig.tsserver.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })
--
-- lspconfig.eslint.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

