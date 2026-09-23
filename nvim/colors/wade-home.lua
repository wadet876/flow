-- wade-home: wade-default lifted for an HDR display, which crushes near-black
-- and dim greys; dark grey background with a faint purple tint, pastel purple/blue text
dofile(vim.fn.stdpath("config") .. "/lua/wade-theme.lua").apply("wade-home", {
  bg         = "#484652",  -- dark grey, faint purple
  fg         = "#f8f6ff",  -- plain text, near white
  dim        = "#c9c3ea",  -- punctuation, brackets
  mute       = "#c3bedd",  -- line numbers, borders
  comment    = "#9c9ba4",  -- comments (neutral grey)
  accent     = "#e2b8ff",  -- keywords (light purple)
  rose       = "#b8ccff",  -- functions, numbers, members (light periwinkle)
  deep       = "#a6ecff",  -- types, constants (light cyan)
  magenta    = "#d3c4ff",  -- operators (pale lavender)
  cream      = "#b0f2e6",  -- strings, parameters (pale teal)
  cursorline = "#53515e",
  visual     = "#6c6590",
  selection  = "#57556a",
  error      = "#ffa3ad",
})
