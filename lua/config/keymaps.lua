vim.g.mapleader = " "

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode fast" })

vim.keymap.set("n", "<leader>w", ":wq<CR>", { desc = "Save and close the file" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move cursor to left window split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move cursor to right window split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move cursor to upper window split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move cursor to lower window split" })


-- Telescope Keybindings (Kept cleanly in your global keymaps module)
vim.keymap.set('n', '<leader><leader>', ':Telescope find_files<CR>', { desc = 'Telescope Find Files' })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Telescope Live Grep' })


vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer Sidebar" })


-- Close current buffer/tab (the 'x' mark)
vim.keymap.set("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close tab/buffer" })

-- Shift + H/L to cycle through open buffers/tabs
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer tab" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer tab" })
