lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
   spec = {

      {
         "stevearc/conform.nvim",
         event = { "BufReadPre", "BufNewFile" },
         config = function()
            require("config.custom_conform")
         end,
      },

      {
         "ellisonleao/gruvbox.nvim",
         priority = 1000,
         config = function()
            vim.cmd.colorscheme("gruvbox")
         end,
      },

      {
         'nvim-telescope/telescope.nvim',
         version = '*',
         dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
         },
         config = function()
            require("config.custom_telescope")
         end,
      },
      {
         'nvim-treesitter/nvim-treesitter',
         lazy = false,
         build = ':TSUpdate',
         main = 'nvim-treesitter.configs',
         config = function()
            require("config.custom_treesitter")
         end,

      },
      {
         "williamboman/mason.nvim",
         dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
         },
         config = function()
            require("config.custom_lsp")
         end,

      },
      {
         "hrsh7th/nvim-cmp",
         dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
         },
         config = function()
            require("config.custom_cmp")
         end,
      },
      -- 5. Sidebar File Explorer
      {
         "nvim-tree/nvim-tree.lua",
         dependencies = { "nvim-tree/nvim-web-devicons" },
         config = function()
            local function my_on_attach(bufnr)
               local api = require("nvim-tree.api")

               api.config.mappings.default_on_attach(bufnr)

               vim.keymap.set('n', 'l', api.node.open.edit,
                  { buffer = bufnr, noremap = true, silent = true, desc = "Open/Expand Directory" })
               vim.keymap.set('n', 'h', api.node.navigate.parent_close,
                  { buffer = bufnr, noremap = true, silent = true, desc = "Close/Collapse Directory" })
            end

            require("nvim-tree").setup({
               on_attach = my_on_attach,
               view = {
                  width = 30,
                  side = "left",
               },
            })
         end,
      },
      {
         "akinsho/bufferline.nvim",
         version = "*",
         dependencies = { "nvim-tree/nvim-web-devicons" },
         config = function()
            require("bufferline").setup({
               options = {
                  mode = "buffers",
                  diagnostics = "nvim_lsp",
                  offsets = {
                     {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "left",
                        separator = true,
                     }
                  },
               },
            })
         end,
      },
      {
         "akinsho/flutter-tools.nvim",
         lazy = false,
         dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim", -- Optional: makes device selection menus look much better
         },
         config = function()
            require("flutter-tools").setup({
               ui = {
                  border = "rounded",
               },
               decorations = {
                  statusline = {
                     app_version = true,
                     device = true,
                  }
               },
               lsp = {
                  settings = {
                     showTodos = true,
                     completeFunctionCalls = true,
                  }
               }
            })
         end,
      },

      {
         "windwp/nvim-autopairs",
         event = "InsertEnter",
         config = function()
            require("nvim-autopairs").setup({
               check_ts = true, -- Enable Treesitter integration for better context awareness
            })

            -- Automatically add `(` after selecting a function or method from nvim-cmp
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
               cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
         end,
      },
      {
         "lewis6991/gitsigns.nvim",
         event = { "BufReadPre", "BufNewFile" },
         config = function()
            require("gitsigns").setup({
               signs = {
                  add          = { text = '┃' },
                  change       = { text = '┃' },
                  delete       = { text = '_' },
                  topdelete    = { text = '‾' },
                  changedelete = { text = '~' },
                  untracked    = { text = '┆' },
               },
               -- Shows who wrote the current line and when (like VS Code's GitLens)
               current_line_blame = true,

               on_attach = function(bufnr)
                  local gs = package.loaded.gitsigns

                  local function map(mode, l, r, opts)
                     opts = opts or {}
                     opts.buffer = bufnr
                     vim.keymap.set(mode, l, r, opts)
                  end

                  -- Navigate between git hunks
                  map('n', ']c', function()
                     if vim.wo.diff then return ']c' end
                     vim.schedule(function() gs.next_hunk() end)
                     return '<Ignore>'
                  end, { expr = true, desc = "Next git hunk" })

                  map('n', '[c', function()
                     if vim.wo.diff then return '[c' end
                     vim.schedule(function() gs.prev_hunk() end)
                     return '<Ignore>'
                  end, { expr = true, desc = "Previous git hunk" })

                  -- Keymaps for interacting with git changes
                  map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview git hunk" })
                  map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Git blame line full" })
                  map('n', '<leader>hd', gs.diffthis, { desc = "Git diff this file" })
               end
            })
         end,
      },
      {
         "nvim-lualine/lualine.nvim",
         dependencies = { "nvim-tree/nvim-web-devicons" },
         config = function()
            require("lualine").setup({
               options = {
                  theme = "gruvbox",   -- Automatically matches your chosen colorscheme
                  globalstatus = true, -- Shows one statusline at the bottom instead of one per split window
                  component_separators = { left = "│", right = "│" },
                  section_separators = { left = "", right = "" },
               },
               sections = {
                  lualine_a = { "mode" },
                  lualine_b = { "branch", "diff", "diagnostics" },
                  lualine_c = { "filename" },
                  -- Shows the active LSP clients attached to the current buffer
                  lualine_x = {
                     {
                        function()
                           local msg = 'No Active Lsp'
                           local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                           -- UPDATED API HERE:
                           local clients = vim.lsp.get_clients({ bufnr = 0 })

                           if next(clients) == nil then return msg end
                           for _, client in ipairs(clients) do
                              local filetypes = client.config.filetypes
                              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                 return client.name
                              end
                           end
                           return msg
                        end,
                        icon = ' LSP:',
                        color = { fg = '#ebdbb2', gui = 'bold' }
                     },
                     "encoding",
                     "fileformat",
                     "filetype"
                  },
                  lualine_y = { "progress" },
                  lualine_z = { "location" }
               },
            })
         end,
      },

      {
         "goolord/alpha-nvim",
         dependencies = { "nvim-tree/nvim-web-devicons" },
         config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- Custom Neovim ASCII art header
            dashboard.section.header.val = {
               "                                                     ",
               "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
               "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
               "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
               "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
               "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
               "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
               "                                                     ",
               "                 Configured by Abhishek              ",
               "                                                     ",
            }

            -- Dashboard menu buttons
            dashboard.section.buttons.val = {
               dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
               dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
               dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
               dashboard.button("g", "󰈭  Find text", ":Telescope live_grep<CR>"),
               dashboard.button("c", "⚙  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
               dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
            }

            -- Add some spacing and subtle highlights
            dashboard.config.layout[1].val = 8 -- margin at the top
            dashboard.section.header.opts.hl = "String"
            dashboard.section.buttons.opts.hl = "Keyword"

            alpha.setup(dashboard.config)
         end,
      },

      {
         "akinsho/toggleterm.nvim",
         version = "*",
         config = function()
            require("toggleterm").setup({
               -- Press Ctrl + \ to open and close the terminal
               open_mapping = [[<c-\>]],
               hide_numbers = true,
               shade_terminals = true,
               shading_factor = 2,
               start_in_insert = true,
               insert_mappings = true, -- allows you to use the open_mapping in insert mode
               terminal_mappings = true,
               direction = "float",
               float_opts = {
                  border = "curved",
                  winblend = 3,
                  title_pos = "center",
               },
            })

            -- Keymap to easily exit terminal mode and go back to normal mode
            vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { desc = "Exit terminal mode fast" })
         end,
      },

      {
         "folke/which-key.nvim",
         event = "VeryLazy",
         init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300 -- Wait 300ms before showing the popup
         end,
         config = function()
            local wk = require("which-key")
            wk.setup()

            -- Let's organize the keybinds you already made so the menu looks clean
            wk.add({
               { "<leader>f", group = "Telescope / Find" },
               { "<leader>h", group = "Git / Hunks" },
               { "<leader>s", group = "Window Splits" },
               { "<leader>m", group = "Formatting" },
            })
         end,
      },

      {
         "ThePrimeagen/harpoon",
         branch = "harpoon2",
         dependencies = { "nvim-lua/plenary.nvim" },
         config = function()
            local harpoon = require("harpoon")

            -- REQUIRED: Initialize harpoon
            harpoon:setup()

            -- Add current file to the Harpoon list
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Add file" })

            -- Toggle the quick menu to see your list of marked files
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
               { desc = "Harpoon Quick Menu" })

            -- Instantly jump to files 1 through 4 in your list
            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
         end,
      },

      {
         "lukas-reineke/indent-blankline.nvim",
         main = "ibl",
         -- Optional: load it only when you open a file to speed up startup
         event = { "BufReadPost", "BufNewFile" },
         config = function()
            require("ibl").setup({
               indent = {
                  char = "│", -- The character for the vertical line
                  tab_char = "│",
               },
               scope = {
                  enabled = true,
                  show_start = false, -- Set to true to draw a line across the top of the scope
                  show_end = false,   -- Set to true to draw a line across the bottom of the scope
               },
               exclude = {
                  filetypes = {
                     "help",
                     "alpha",
                     "dashboard",
                     "neo-tree",
                     "Trouble",
                     "lazy",
                     "mason",
                     "toggleterm",
                  },
               },
            })
         end,
      },
      {
         "folke/trouble.nvim",
         dependencies = { "nvim-tree/nvim-web-devicons" },
         config = function()
            require("trouble").setup()

            -- Keybinds for Trouble
            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",
               { desc = "Toggle Project Diagnostics" })
            vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
               { desc = "Toggle Document Diagnostics" })
            vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Toggle Quickfix List" })
            vim.keymap.set("n", "gr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
               { desc = "LSP References (Trouble)" })
         end,
      },

      {
         "mfussenegger/nvim-dap",
         dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
         },
         config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Automatically open the UI panels when debugging starts, and close them when it ends
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            -- Debugging Keybinds
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate Debugging" })
         end,
      },

      {
         "kylechui/nvim-surround",
         version = "*", -- Use for stability; omit to use `main` branch for the latest features
         event = "VeryLazy",
         config = function()
            require("nvim-surround").setup({
               -- The defaults are perfect, so we just call setup()
            })
         end,
      },
      {
         "mfussenegger/nvim-jdtls",
         ft = "java",
      },

   },

})
