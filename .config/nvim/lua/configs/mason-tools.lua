--require("nvchad.configs.lspconfig").defaults()

local function hasExe(name)
  return vim.fn.executable(name) == 1
end

local hasNode = function()
  return hasExe("node")
end

local hasBash = function()
  return hasExe("bash")
end

local hasGCC = function()
  return hasExe("gcc")
end

local hasDotnet = function()
  return hasExe("dotnet")
end

local hasJavac = function()
  return hasExe("javac")
end

local hasKotlin = function()
  return hasExe("kotlinc")
end

local hasPython = function()
  return hasExe("python3")
end

local hasRust = function()
  return hasExe("rustup") or hasExe("cargo")
end

-- List of LSPs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local tools = { 
  -- Web
  {"html", condition = hasNode },
  {"cssls", condition = hasNode },
  -- "tailwindcss",  -- pray you never have to uncomment this
  {"angularls", condition = hasNode },
  {"eslint", condition = hasNode },
  {"jsonls", condition = hasNode },
  {"ts_ls", condition = hasNode },
 
  -- Terminal
  {"bashls", condition = hasBash },
 
  -- C
  {"clangd", condition = hasGCC },
  {"cmake", condition = hasGCC },
  {"csharp_ls", condition = hasDotnet },
 
  -- Godot
  "gdtoolkit",
 
  -- Java
  {"java_language_server", condition = hasJavac },
  {"kotlin_language_server", condition = hasJavac },
  {"gradle_ls", condition = hasJavac },
 
  -- Python
  {"ruff", condition = hasPython },
  {"basedpyright", condition = hasPython },
 
  -- TypeScript/JavaScript
  {"ts_ls", condition = hasNode },
  {"eslint", condition = hasNode },
  {"angularls", condition = hasNode },
 
  -- Rust
  {"rust_analyzer", condition = hasRust },
 
  -- Misc.
  "docker_language_server",
  "nginx_language_server",
  "systemd_lsp",
  "yamlls",
 
  -- Misc. Languages
  "lua_ls",
}

return tools

