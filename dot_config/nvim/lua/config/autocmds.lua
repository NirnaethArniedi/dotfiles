-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Autosave when leaving a buffer or when Neovim loses focus. Writing triggers
-- format-on-save, so this must not fire on every edit (TextChanged/InsertLeave).
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  command = "silent! wall",
  nested = true,
})
