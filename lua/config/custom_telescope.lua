local telescope = require("telescope")

telescope.setup({
  defaults = {
    preview = true,
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { preview_width = 0.6 },
    },
  },
})


vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#7c6f64" })       
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#fe8019" }) 
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#b8bb26", bold = true }) 
