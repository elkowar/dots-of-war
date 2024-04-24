-- [nfnl] Compiled from fnl/dots/smart-compe-conjure.fnl by https://github.com/Olical/nfnl, do not edit.
al(utils, dots.utils)
al(a, aniseed.core)
al(str, aniseed.string)
al(view, aniseed.view)
al(popup, popup)
al(compe, compe)
local function _1_()
  return setmetatable({}, {__index = my_source})
end
my_source.new = _1_
my_source.determine = fuck.determine
my_source.get_metadata = fuck.get_metadata
my_source.complete = fuck.complete
my_source.abort = fuck.abort
local function _2_(self, args)
  a.println(view.serialise(args))
  local function _3_()
    local help_tag = help["find-help-tag-for"](args.completed_item.word)
    if help_tag then
      local lines = {"```help"}
      for _, line in ipairs(help["help-for-tag"](help_tag)) do
        table.insert(lines, line)
      end
      table.insert(lines, "```")
      return lines
    else
      return nil
    end
  end
  return args.callback(_3_())
end
my_source.documentation = _2_
defn(setup, {}, def(fuck, require("compe_conjure")), def(my_source, {}), nil, nil, nil, nil, nil, nil, compe.register_source("epic", my_source.new()), compe.setup({enabled = true, min_length = 1, preselect = "enable", throttle_time = 80, source_timeout = 200, incomplete_delay = 400, max_abbr_width = 100, max_kind_width = 100, max_menu_width = 100, documentation = true, source = {path = true, buffer = true, calc = true, nvim_lsp = true, nvim_lua = true, epic = true, vsnip = false}, debug = false, autocomplete = false}))
return {}
