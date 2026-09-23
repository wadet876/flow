-- wade-default: purple/blue accents on near-black, adapted from neilmehra/nvim
dofile(vim.fn.stdpath("config") .. "/lua/wade-theme.lua").apply("wade-default", {
  bg         = "#12111a",
  fg         = "#d6d3e6",  -- plain text
  dim        = "#7c7a98",  -- punctuation, brackets
  mute       = "#6a6d96",  -- line numbers, borders
  comment    = "#7e7e86",  -- comments (neutral grey)
  accent     = "#c77dff",  -- keywords (vivid purple)
  rose       = "#7aa2ff",  -- functions, numbers, members (bright blue)
  deep       = "#56d4ff",  -- types, constants (cyan-blue)
  magenta    = "#a98bff",  -- operators (lavender)
  cream      = "#73dacb",  -- strings, parameters (teal)
  cursorline = "#1c1a20",
  visual     = "#5a4a6e",
  selection  = "#26222c",
  error      = "#d0707e",
})
