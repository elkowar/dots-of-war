device = {
    thinkix = function()
        return SYSTEM.hostname == "thinkix"
    end,
    desktop = function()
        return SYSTEM.hostname == "fedora.fritz.box"
    end,
    laptop = function()
        return SYSTEM.hostname == "thinkix" or SYSTEM.hostname == "frissnix"
    end,
}
