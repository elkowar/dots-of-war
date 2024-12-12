data = {
}

device = {
    thinkix = function()
        return SYSTEM.hostname == "thinkix"
    end,
    laptop = function()
        return SYSTEM.hostname == "thinkix" or SYSTEM.hostname == "frissnix"
    end,
}
