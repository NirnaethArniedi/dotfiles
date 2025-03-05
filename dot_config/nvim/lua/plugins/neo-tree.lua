return {
  -- This configuration ensures that when opening a file, it reuses existing windows
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.mappings = opts.window.mappings or {}
      opts.window.mappings["<cr>"] = "open_drop"
      opts.open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline", "edgy", "toggleterm" }
      return opts
    end,
  },
}
