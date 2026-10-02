if vim.g.loaded_nvim_filename then
  return
end
vim.g.loaded_nvim_filename = true

-- Defer default setup so a user call right after vim.pack.add() wins.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("nvim-filename", { clear = true }),
  once = true,
  callback = function()
    require("nvim-filename").setup()
  end,
})
