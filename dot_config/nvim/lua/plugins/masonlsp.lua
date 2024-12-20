if true then
  return {}
end
return {
  "williamboman/mason-lspconfig.nvim",

  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "ruff_lsp" },
    })
  end,
}
