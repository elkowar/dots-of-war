
export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    desktop: SYSTEM.hostname == "fedora.fritz.box",
    laptop: SYSTEM.hostname == "thinkix" || SYSTEM.hostname == "frissnix",
};


export let eggs = #{
    "alacritty": #{ enabled: true, targets: "~" },
    "eww": #{ enabled: true, targets: "~" },
    "eww-bar": #{ enabled: true, targets: "~" },
    "foot": #{ enabled: true, targets: "~", templates: [".config/foot/foot.ini"] },
    "git": #{ enabled: true, targets: "~", templates: [".gitconfig"] },
    "niri": #{ enabled: true, targets: "~/.config/niri", templates: ["**/*.kdl"] },
    "nvim": #{ enabled: true, targets: "~" },
    "other-dotfiles-stuff": #{ enabled: true, targets: "~" },
    "profile": #{ enabled: true, targets: "~" },
    "starship": #{ enabled: true, targets: "~" },
    "sway": #{ enabled: true, targets: "~" },
    "tmux": #{ enabled: !device.laptop, targets: "~" },
    "zed": #{ enabled: true, targets: "~" },
    "zsh": #{ enabled: true, targets: "~" },
    "rofi": #{ enabled: true, targets: "~" },
    "gtk": #{ enabled: true, targets: "~" },
    "scripts": #{ enabled: true, targets: "~/scripts" },

    "powershell": #{ enabled: false, targets: "~" },
    "sioyek": #{ enabled: false, targets: "~" },
    "waybar": #{ enabled: false, targets: "~" },
    "zathura": #{ enabled: false, targets: "~" },
    "eww-laptop": #{ enabled: false, targets: "~" },
    "hyprland": #{ enabled: false, targets: "~" },
    "hyprlock": #{ enabled: false, targets: "~" },
    "kakoune": #{ enabled: false, targets: "~" },
    "kanata": #{ enabled: false, targets: "~" },
    "karabiner": #{ enabled: false, targets: "~" },
}
