require("nvchad.configs.lspconfig").defaults()
local tools = require("configs.mason-tools")

-- tools[i] is either a string, or a table where table[1] is a string
local servers = {}

-- table.insert(servers, "lsp")
for i,v in pairs(tools) do
  if type(v) == "table" then
    table.insert(servers, v[1])
  else
    table.insert(servers, v)
  end
end

vim.lsp.enable(servers)
return servers

-- read :h vim.lsp.config for changing options of lsp servers 
