-- Autoread when files change on disk
vim.cmd("set autoread")
vim.cmd("autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif")
-- Notification after file change
vim.cmd("autocmd FileChangedShell Post * echohl WarningMsg | echo \"File changed on disk. Buffer reloaded.\" | echohl None")

