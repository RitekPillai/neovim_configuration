require("config.options")
require("config.keymaps")
require("config.lazy")


vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
   pattern = "*",
   command = "silent! wall",
})
