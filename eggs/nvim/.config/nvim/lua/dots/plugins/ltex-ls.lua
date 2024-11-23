-- [nfnl] Compiled from fnl/dots/plugins/ltex-ls.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("dots.prelude")
local autoload = _local_1_["autoload"]
local utils = _local_1_["utils"]
local lsp = autoload("lspconfig")
local configs = autoload("lspconfig/configs")
local lsputil = autoload("lspconfig/util")
local function cmds(xs)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, x in ipairs(xs) do
    local val_23_auto = ("\\" .. x .. "{}")
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local latex_command_settings = {dummy = cmds({"texttt", "scripture", "lstref", "figref", "tblref", "secref", "personaltextcite", "personalparencite", "textcite", "parencite", "parencite[]", "game", "acsu", "enquote", "name", "item", "reqref", "gamebtn", "fs", "cs", "appref", "sorty"}), ignore = cmds({"urlfootnote", "caption", "todo"})}
local Dictionary_file = {["de-DE"] = {(vim.fn.getenv("HOME") .. "/.config/ltex-ls/dictionary.txt")}}
local Disabled_rules_file = {["de-DE"] = {(vim.fn.getenv("HOME") .. "/.config/ltex-ls/disable.txt")}}
local False_positives_file = {["de-DE"] = {(vim.fn.getenv("HOME") .. "/.config/ltex-ls/false.txt")}}
local latex_command_settings_formatted
do
  local tbl = {}
  for option, commands in pairs(latex_command_settings) do
    for _, command in ipairs(commands) do
      tbl[command] = option
    end
  end
  latex_command_settings_formatted = tbl
end
local function read_files(files)
  local dict = {}
  for _, file in ipairs(files) do
    local f = io.open(file, "r")
    if (nil ~= f) then
      for l in f:lines() do
        table.insert(dict, l)
      end
    else
    end
  end
  return dict
end
local function find_ltex_lang()
  local buf_clients = vim.lsp.buf_get_clients()
  for _, client in ipairs(buf_clients) do
    if (client.name == "ltex") then
      local ___antifnl_rtn_1___ = client.config.settings.ltex.language
      return ___antifnl_rtn_1___
    else
    end
  end
  return nil
end
local function find_ltex_files(filetype, value)
  if (filetype == "dictionary") then
    return Dictionary_file[(value or find_ltex_lang())]
  elseif (filetype == "disable") then
    return Disabled_rules_file[(value or find_ltex_lang())]
  elseif (filetype == "falsePositive") then
    return False_positives_file[(value or find_ltex_lang())]
  else
    return nil
  end
end
local function update_config(lang, configtype)
  local buf_clients = vim.lsp.buf_get_clients()
  local client = nil
  for _, lsp0 in ipairs(buf_clients) do
    if (lsp0.name == "ltex") then
      client = lsp0
    else
    end
  end
  if client then
    if (configtype == "dictionary") then
      if client.config.settings.ltex.dictionary then
        client.config.settings.ltex.dictionary = {[lang] = read_files(Dictionary_file[lang])}
        return client.notify("workspace/didChangeConfiguration", client.config.settings)
      else
        return vim.notify("Error when reading dictionary config, check it")
      end
    elseif (configtype == "disable") then
      if client.config.settings.ltex.disabledRules then
        client.config.settings.ltex.disabledRules = {[lang] = read_files(Disabled_rules_file[lang])}
        return client.notify("workspace/didChangeConfiguration", client.config.settings)
      else
        return vim.notify("Error when reading disabledRules config, check it")
      end
    elseif (configtype == "falsePositive") then
      if client.config.settings.ltex.hiddenFalsePositives then
        client.config.settings.ltex.hiddenFalsePositives = {[lang] = read_files(False_positives_file[lang])}
        return client.notify("workspace/didChangeConfiguration", client.config.settings)
      else
        return vim.notify("Error when reading hiddenFalsePositives config, check it")
      end
    else
      return nil
    end
  else
    return nil
  end
end
local function add_to_file(filetype, lang, file, value)
  file = io.open(file[(#file - 0)], "a+")
  if file then
    file:write((value .. "\n"))
    file:close()
  else
    local ___antifnl_rtns_1___ = {print("Failed insert %q", value)}
    return (table.unpack or _G.unpack)(___antifnl_rtns_1___)
  end
  if (filetype == "dictionary") then
    return update_config(lang, "dictionary")
  elseif (filetype == "disable") then
    return update_config(lang, "disable")
  elseif (filetype == "falsePositive") then
    return update_config(lang, "falsePositive")
  else
    return nil
  end
end
local function add_to(filetype, lang, file, value)
  local dict = read_files(file)
  for _, v in ipairs(dict) do
    if (v == value) then
      return nil
    else
    end
  end
  return add_to_file(filetype, lang, file, value)
end
local function init()
  local function _15_(filename)
    return lsputil.path.dirname(filename)
  end
  configs.ltex = {default_config = {cmd = {"ltex-ls"}, filetypes = {"tex", "latex", "bib"}, root_dir = _15_}}
  lsp.ltex.setup({settings = {ltex = {enabled = {"latex", "tex", "bib"}, language = "de-DE", checkFrequency = "save", diagnosticSeverity = "information", setenceCacheSize = 5000, additionalRules = {enablePickyRules = true, motherTongue = "de-DE"}, dictionary = utils["map-values"](read_files, Dictionary_file), disabledRules = utils["map-values"](read_files, Disabled_rules_file), hiddenFalsePositives = utils["map-values"](read_files, False_positives_file), latex = {commands = latex_command_settings_formatted}}}})
  lsp.ltex.dictionary_file = Dictionary_file
  lsp.ltex.disabledrules_file = Disabled_rules_file
  lsp.ltex.falsepostivies_file = False_positives_file
  local orig_execute_command = vim.lsp.buf.execute_command
  local function _16_(command)
    if (command.command == "_ltex.addToDictionary") then
      local arg = command.arguments[1].words
      for lang, words in pairs(arg) do
        for _, word in ipairs(words) do
          local filetype = "dictionary"
          add_to(filetype, lang, find_ltex_files(filetype, lang), word)
        end
      end
      return nil
    elseif (command.command == "_ltex.disableRules") then
      local arg = command.arguments[1].ruleIds
      for lang, rules in pairs(arg) do
        for _, rule in ipairs(rules) do
          local filetype = "disable"
          add_to(filetype, lang, find_ltex_files(filetype, lang), rule)
        end
      end
      return nil
    elseif (command.command == "_ltex.hideFalsePositives") then
      local arg = command.arguments[1].falsePositives
      for lang, rules in pairs(arg) do
        for _, rule in ipairs(rules) do
          local filetype = "falsePositive"
          add_to(filetype, lang, find_ltex_files(filetype, lang), rule)
        end
      end
      return nil
    else
      return orig_execute_command(command)
    end
  end
  vim.lsp.buf.execute_command = _16_
  return nil
end
return {}
