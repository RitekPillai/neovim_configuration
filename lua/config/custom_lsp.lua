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
