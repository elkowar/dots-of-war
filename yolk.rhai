
const themes = #{
    gruv: "a",
    nord: "b",
};


export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    desktop: SYSTEM.hostname == "fedora.fritz.box",
    laptop: SYSTEM.hostname == "thinkix" || SYSTEM.hostname == "frissnix",
    gruv: if LOCAL { themes.gruv } else { themes.nord }
};


export let eggs = #{};
eggs["alacritty"] = #{ enabled: true, targets: "~" };
eggs["eww"] = #{ enabled: true, targets: "~" };
eggs["eww-bar"] = #{ enabled: true, targets: "~" };
eggs["foot"] = #{ enabled: true, targets: "~", templates: [".config/foot/foot.ini"] };
eggs["git"] = #{ enabled: true, targets: "~", templates: [".gitconfig"] };
eggs["niri"] = #{ enabled: true, targets: "~", templates: [".config/niri/*"] };
eggs["nvim"] = #{ enabled: true, targets: "~" };
eggs["other-dotfiles-stuff"] = #{ enabled: true, targets: "~" };
eggs["profile"] = #{ enabled: true, targets: "~" };
eggs["starship"] = #{ enabled: true, targets: "~" };
eggs["sway"] = #{ enabled: true, targets: "~" };
eggs["tmux"] = #{ enabled: true, targets: "~" };
eggs["zed"] = #{ enabled: true, targets: "~" };
eggs["zsh"] = #{ enabled: true, targets: "~" };
eggs["rofi"] = #{ enabled: true, targets: "~" };
eggs["gtk"] = #{ enabled: true, targets: "~" };

eggs["powershell"] = #{ enabled: false, targets: "~" };
eggs["scripts"] = #{ enabled: true, targets: "~" };
eggs["sioyek"] = #{ enabled: false, targets: "~" };
eggs["waybar"] = #{ enabled: false, targets: "~" };
eggs["zathura"] = #{ enabled: false, targets: "~" };
eggs["eww-laptop"] = #{ enabled: false, targets: "~" };
eggs["hyprland"] = #{ enabled: false, targets: "~" };
eggs["hyprlock"] = #{ enabled: false, targets: "~" };
eggs["kakoune"] = #{ enabled: false, targets: "~" };
eggs["kanata"] = #{ enabled: false, targets: "~" };
eggs["karabiner"] = #{ enabled: false, targets: "~" };
