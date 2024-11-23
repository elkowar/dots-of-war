-- [nfnl] Compiled from fnl/dots/plugins/copilot.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("dots.utils")
return {utils.plugin("zbirenbaum/copilot.lua", {cmd = "Copilot", event = "InsertEnter", opts = {panel = {enabled = false}, suggestion = {enabled = true, auto_trigger = "true", keymap = {accept = "<tab>", next = "<C-l><C-n>"}}}})}
