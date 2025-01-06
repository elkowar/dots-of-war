-- [nfnl] Compiled from fnl/dots/help-thingy.fnl by https://github.com/Olical/nfnl, do not edit.
local function help_thingy_kram()
  local _local_1_ = require("nfnl.module")
  local autoload = _local_1_["autoload"]
  local utils = autoload("dots.utils")
  local a = autoload("aniseed.core")
  local str = autoload("aniseed.string")
  local popup = autoload("popup")
  local ts = autoload("nvim-treesitter")
  local width = 20
  for _, line in ipairs(text) do
    width = math.max(width, #line)
  end
  local function _2_()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(bufnr, "filetype", ft)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, text)
    return popup.create(bufnr, {padding = {1, 1, 1, 1}, width = width})
  end
  defn(pop, {text, ft}, "Open a popup with the given text and filetype", nil, nil, _2_())
  local function _3_()
    local col = (vim.api.nvim_win_get_cursor(0))[2]
    local line = vim.api.nvim_get_current_line()
    return (vim.fn.matchstr(line:sub(1, (col + 1)), "\\k*$") .. string.sub(vim.fn.matchstr(line:sub((col + 1)), "^\\k*"), 2))
  end
  defn(__fnl_global__get_2dcurrent_2dword, {}, "Return the word the cursor is currently hovering over", _3_())
  def(__fnl_global__helpfiles_2dpath, str.join("/", a.butlast(str.split(vim.o.helpfile, "/"))))
  local entries = {}
  for line, _ in io.lines((__fnl_global__helpfiles_2dpath .. "/tags")) do
    local _let_4_ = str.split(line, "\9")
    local key = _let_4_[1]
    local file = _let_4_[2]
    local address = _let_4_[3]
    entries[key] = {file = (__fnl_global__helpfiles_2dpath .. "/" .. file), address = address}
  end
  def(tags, nil, nil, entries)
  defn(__fnl_global__find_2dhelp_2dtag_2dfor, {topic}, (tags[topic] or tags[(topic .. "()")] or tags[(string.gsub(topic, "vim%.api%.", "") .. "()")] or tags[(string.gsub(topic, "vim%.fn%.", "") .. "()")] or tags[(string.gsub(topic, "fn%.", "") .. "()")] or tags[(string.gsub(topic, "vim%.o%.", "") .. "()")] or tags[(string.gsub(topic, "vim%.b%.", "") .. "()")] or tags[(string.gsub(topic, "vim%.g%.", "") .. "()")]))
  local data = nil
  for line, _ in io.lines(tag.file) do
    if (nil == data) then
      if (-1 ~= vim.fn.match(line, (tag.address):sub(2))) then
        data = {line}
      else
      end
    else
      if ((2 > #data) or ("" == line) or (" " == line:sub(1, 1)) or ("\9" == line:sub(1, 1)) or ("<" == line:sub(1, 1))) then
        table.insert(data, line)
      else
        return data
      end
    end
  end
  defn(__fnl_global__help_2dfor_2dtag, {tag}, nil, nil)
  _G.get_help = function()
    return __fnl_global__if_2dlet({__fnl_global__help_2dtag, __fnl_global__find_2dhelp_2dtag_2dfor(__fnl_global__get_2dcurrent_2dword())}, pop(__fnl_global__help_2dfor_2dtag(__fnl_global__help_2dtag), "help"))
  end
  return utils.keymap("n", "ML", ":call v:lua.get_help()<CR>")
end
return {}
