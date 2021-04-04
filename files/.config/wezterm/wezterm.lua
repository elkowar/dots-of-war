local fennel = require("./fennel")
fennel.path = fennel.path .. ";.config/wezterm/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)

return require("config")
