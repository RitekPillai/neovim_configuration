-- If nvim-jdtls isn't found, stop running
local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
   return
end

local home = os.getenv("HOME")
local mason_registry = require("mason-registry")
local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

-- 1. Calculate a unique workspace directory for this specific project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

-- 2. Locate the specific Equinox launcher jar
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
-- Locate the debug and test bundles downloaded by Mason
local bundles = {
   vim.fn.glob(
      mason_registry.get_package("java-debug-adapter"):get_install_path() ..
      "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
}
vim.list_extend(bundles,
   vim.split(vim.fn.glob(mason_registry.get_package("java-test"):get_install_path() .. "/extension/server/*.jar", true),
      "\n"))


-- 3. Define the massive command required to boot Eclipse JDTLS headless
local cmd = {
   "java",
   "-Declipse.application=org.eclipse.jdt.ls.core.id1",
   "-Dosgi.bundles.defaultStartLevel=4",
   "-Declipse.product=org.eclipse.jdt.ls.core.product",
   "-Dlog.protocol=true",
   "-Dlog.level=ALL",
   "-Xmx1g",
   "--add-modules=ALL-SYSTEM",
   "--add-opens", "java.base/java.util=ALL-UNNAMED",
   "--add-opens", "java.base/java.lang=ALL-UNNAMED",

   -- MANDATORY FOR SPRING BOOT: Tells Java to load Lombok before analyzing code
   "-javaagent:" .. jdtls_path .. "/lombok.jar",

   "-jar", launcher_jar,

   -- Uses the Linux specific configuration directory
   "-configuration", jdtls_path .. "/config_linux",
   "-data", workspace_dir,
}

local config = {
   cmd = cmd,
   -- Tells JDTLS where your project actually starts
   root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

   init_options = {
      bundles = bundles,
   },

   settings = {
      java = {
         signatureHelp = { enabled = true },
         eclipse = { downloadSources = true },
         maven = { downloadSources = true },
         referencesCodeLens = { enabled = true },
         inlayHints = {
            parameterNames = { enabled = "all" }
         },
         format = {
            enabled = false -- We leave formatting to conform.nvim (google-java-format)
         }
      }
   },

   -- Connect your existing cmp/lsp keybinds to this server
   on_attach = function(client, bufnr)
      -- Enable inline hints (requires Neovim 0.10+)
      if client.server_capabilities.inlayHintProvider then
         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- Specific Java commands you can map to shortcuts
      vim.keymap.set("n", "<leader>jo", "<cmd>lua require('jdtls').organize_imports()<CR>",
         { desc = "Organize Java Imports", buffer = bufnr })
      vim.keymap.set("n", "<leader>jv", "<cmd>lua require('jdtls').extract_variable()<CR>",
         { desc = "Extract Variable", buffer = bufnr })
      vim.keymap.set("v", "<leader>jm", "<esc><cmd>lua require('jdtls').extract_method(true)<CR>",
         { desc = "Extract Method", buffer = bufnr })
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
      require("jdtls.dap").setup_dap_main_class_configs()
   end,
}

-- Start the server!
jdtls.start_or_attach(config)
