-- Base spec and <leader>cn keymap come from the coding.neogen extra
return {
  "danymat/neogen",
  opts = {
    languages = {
      python = {
        template = {
          annotation_convention = "numpydoc",
        },
      },
    },
  },
}
