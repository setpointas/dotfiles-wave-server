return {
  "folke/which-key.nvim",
  config = function()
    local which_key = require("which-key")
    which_key.setup {
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      window = {
        border = "rounded",
        position = "bottom",
        padding = { 2, 2, 2, 2 },
      },
      ignore_missing = false,
      show_help = true,
      show_keys = true,
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        n= { "d"  },
      },
    }
  end
}
