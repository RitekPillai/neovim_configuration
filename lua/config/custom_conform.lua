local conform = require("conform")

conform.setup({
  -- Map your filetypes to the formatters you want to use
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    java = { "google-java-format" },
    go = { "gofmt" },
    json = { "prettier" },
    html = { "prettier" },
    dart = { "dart_format" },

    
  },
  
  -- Automatically format when you save a file
  format_on_save = {
    lsp_fallback = true, -- If no formatter is found above, use the LSP
    async = false,
    timeout_ms = 500,
  },
})

-- Optional: Add a keybind to trigger formatting manually
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
