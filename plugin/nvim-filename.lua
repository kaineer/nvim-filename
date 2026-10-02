if vim.g.loaded_nvim_filename then
  return
end
vim.g.loaded_nvim_filename = true

require("nvim-filename").setup()
