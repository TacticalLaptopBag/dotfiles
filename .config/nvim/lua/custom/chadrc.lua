---@type ChadrcConfig
local M = {}

M.ui = { theme = 'gruvchad' }
M.plugins = "custom.plugins"

require "custom.keybinds"
require "custom.vim-options"

return M
