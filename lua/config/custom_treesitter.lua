local configs = require("nvim-treesitter.config")

configs.setup({
   ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "dart" }, -- Add "dart" here

   highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
   },

   indent = { enable = true },
})
