local M = {}

local timer = nil
local float_win = nil
local float_buf = nil
local ns = vim.api.nvim_create_namespace("nvim-filename")
local enabled = false

local defaults = {
  timeout = 1000,
  highlight = "Comment",
}

local config = vim.deepcopy(defaults)

local function close_float()
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    pcall(vim.api.nvim_win_close, float_win, true)
  end
  float_win = nil
  float_buf = nil
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function basename()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return "[No Name]"
  end
  return vim.fn.fnamemodify(name, ":t")
end

--- Take a prefix of `str` whose display width is at most `max_width`.
local function display_prefix(str, max_width)
  if max_width <= 0 then
    return ""
  end
  if vim.fn.strdisplaywidth(str) <= max_width then
    return str
  end

  local result = ""
  for i = 0, vim.fn.strchars(str) - 1 do
    local ch = vim.fn.strcharpart(str, i, 1)
    if vim.fn.strdisplaywidth(result .. ch) > max_width then
      break
    end
    result = result .. ch
  end
  return result
end

local function format_line(name, width)
  local ellipsis = "…"
  local text = " " .. name

  if vim.fn.strdisplaywidth(text) > width then
    text = display_prefix(text, width - vim.fn.strdisplaywidth(ellipsis)) .. ellipsis
  end

  local pad = width - vim.fn.strdisplaywidth(text)
  if pad > 0 then
    text = text .. string.rep(" ", pad)
  end

  return text
end

local function show()
  if vim.fn.mode() ~= "n" then
    return
  end

  stop_timer()
  close_float()

  local win = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)

  if height < 1 or width < 1 then
    return
  end

  local text = format_line(basename(), width)

  float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })
  vim.bo[float_buf].modifiable = false
  vim.bo[float_buf].bufhidden = "wipe"

  float_win = vim.api.nvim_open_win(float_buf, false, {
    relative = "win",
    win = win,
    row = height - 1,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    border = "none",
    focusable = false,
    zindex = 50,
    noautocmd = true,
  })

  vim.wo[float_win].winhighlight = "Normal:" .. config.highlight

  timer = vim.uv.new_timer()
  timer:start(
    config.timeout,
    0,
    vim.schedule_wrap(function()
      stop_timer()
      close_float()
    end)
  )
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})

  if enabled then
    return
  end
  enabled = true

  vim.on_key(function()
    if vim.fn.mode() ~= "n" then
      return
    end
    vim.schedule(show)
  end, ns)
end

return M
