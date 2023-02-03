-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- settings passed of nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- colorscheme for arrows in tree to a light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

-- config nvim-tree
nvimtree.setup({
  -- folder arrow icons
  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_closed = " ", 
          arrow_open = " ",
        },
      },
    },
  },
  -- no window_picker for explorer
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})
