require("mason").setup()

require("mason-lspconfig").setup({
   ensure_installed = { "lua_ls", "jdtls" },
})

vim.lsp.config("lua_ls", {})
vim.lsp.enable("lua_ls")

local lombok_path = vim.fn.expand("~/.local/share/nvim/lombok.jar")

vim.lsp.config("jdtls", {
   cmd = {
      "jdtls",
      "--jvm-arg=-javaagent:" .. lombok_path
   }
})
vim.lsp.enable("jdtls")

vim.lsp.config("dartls", {})
vim.lsp.enable("dartls")


vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions (Lightbulb)" })


-- Show the error message on the current line
vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float, { desc = "Show Error Message" })

-- Jump to the previous/next error in the file
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Error" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Error" })
