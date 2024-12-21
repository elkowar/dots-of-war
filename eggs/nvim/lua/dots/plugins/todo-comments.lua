-- [nfnl] Compiled from fnl/dots/plugins/todo-comments.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("dots.utils")
return {utils.plugin("folke/todo-comments.nvim", {lazy = true, event = "VeryLazy", opts = {keywords = {TODO = {icon = "\239\128\140 "}, WARN = {icon = "\239\129\177 ", alt = {"WARNING", "XXX", "!!!"}}, NOTE = {icon = "\239\137\137 ", alt = {"INFO"}}, FIX = {icon = "\239\134\136 ", alt = {"FIXME", "BUG", "FIXIT", "ISSUE", "PHIX"}}, PERF = {icon = "\239\128\151 ", alt = {"OPTIM", "PERFORMANCE", "OPTIMIZE"}}, HACK = {icon = "\239\146\144 "}}}})}
