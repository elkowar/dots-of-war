local fennel = require("./fennel")
local home = os.getenv("HOME")
return fennel.dofile(home .. "/.config/wezterm/config.fnl")
--fennel.path = fennel.path .. ".config/wezterm/?.fnl"
--table.insert(package.loaders or package.searchers, fennel.searcher)

--return require("./config")
