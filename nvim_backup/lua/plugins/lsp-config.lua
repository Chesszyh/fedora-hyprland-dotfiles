return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- 确保在 nvim-lspconfig 之前加载
    dependencies = { "neovim/nvim-lspconfig" },

    config = function()
      local servers = {
        "lua_ls",
        "clangd",
        "cmake",
        "marksman",   
        "html",
        "cssls",
        "ts_ls",  -- TypeScript 和 JavaScript
        "bashls",
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 定义一个通用的 on_attach 函数，用于设置快捷键和自动格式化
      local on_attach = function(client, bufnr)
        -- 设置LSP快捷键
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to References" })
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })

        -- 设置保存时自动格式化
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- 循环遍历 servers 列表，为每个 LSP 自动调用 setup
      for _, server_name in ipairs(servers) do
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },
}