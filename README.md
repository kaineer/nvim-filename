# nvim-filename

Shows the current buffer basename at the bottom of the window on every normal-mode keypress, then hides it after one second.

Useful when `laststatus=0` (no statusline).

## Install

### vim.pack (Neovim 0.12+)

```lua
vim.pack.add({
  "https://github.com/kaineer/nvim-filename",
})
```

With options:

```lua
vim.pack.add({
  "https://github.com/kaineer/nvim-filename",
})

require("nvim-filename").setup({
  timeout = 1000,      -- ms before hide
  highlight = "Comment", -- float text highlight
})
```

Local checkout:

```lua
vim.pack.add({
  { src = "~/devel/kaineer/nvim-filename", name = "nvim-filename" },
})
```

### lazy.nvim

```lua
{
  "kaineer/nvim-filename",
  config = true,
}
```

Or with options:

```lua
{
  "kaineer/nvim-filename",
  opts = {
    timeout = 1000,      -- ms before hide
    highlight = "Comment", -- float text highlight
  },
}
```

## Behaviour

- Triggers on keypresses in normal mode
- Draws a one-line floating window at the bottom of the current window
- Re-shows and resets the timer on each keypress
- Auto-loads via `plugin/nvim-filename.lua` (or call `require("nvim-filename").setup()`)
