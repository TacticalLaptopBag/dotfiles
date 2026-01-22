local M = {}

M.nvimtree = {
  filters = {
    dotfiles = false,
    git_ignored = false,
    custom = { "^.git$" },
  },
  view = {
    number = true,
    relativenumber = true,
  }
}

return M

