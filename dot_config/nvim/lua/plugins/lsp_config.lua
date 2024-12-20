if true then
  return {}
end

return {
  -- change nvim-lspconfig options
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
  },

  config = function()
    local lspconfig = require("lspconfig")
    local mason = require("mason")

    mason.setup()

    lspconfig.pyright.setup({
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { "*" },
          },
        },
      },
    })

    -- ...
  end,

  setup = function()
    -- Other LSP setup code here...

    -- Add the Ruff-specific configuration
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end
        if client.name == "ruff" then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end,
      desc = "LSP: Disable hover capability from Ruff",
    })

    -- Other LSP configurations...
  end,
}
