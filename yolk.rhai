
export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    desktop: SYSTEM.hostname == "fedora.fritz.box",
    laptop: SYSTEM.hostname == "thinkix" || SYSTEM.hostname == "frissnix",
    macbook: false,
};


export let eggs = #{
    "alacritty": #{ enabled: true, targets: "~/.config/alacritty" },
    "eww": #{ enabled: true, targets: "~" },
    "eww-bar": #{ enabled: true, targets: "~" },
    "foot": #{ enabled: true, targets: "~", templates: [".config/foot/foot.ini"] },
    "git": #{ enabled: true, targets: "~", templates: [".gitconfig"] },
    "niri": #{ enabled: true, targets: "~/.config/niri", templates: ["**/*.kdl"] },
    "nvim": #{ enabled: true, targets: "~", main_file: ".config/nvim/fnl/main.fnl" },
    "profile": #{ enabled: true, targets: "~" },
    "starship": #{ enabled: true, targets: "~" },
    "sway": #{ enabled: true, targets: "~" },
    "zed": #{ enabled: true, targets: "~" },
    "zsh": #{ enabled: true, targets: "~" },
    "rofi": #{ enabled: true, targets: "~" },
    "gtk": #{ enabled: true, targets: "~" },
    "scripts": #{ enabled: true, targets: "~/scripts" },

    "hyprlock": #{ enabled: device.laptop, targets: "~" },
    "kanata": #{ enabled: device.laptop, targets: "~" },
    "waybar": #{ enabled: device.laptop, targets: "~" },

    "karabiner": #{ enabled: device.macbook, targets: "~" },

    "powershell": #{ enabled: false, targets: "~" },
    "sioyek": #{ enabled: false, targets: "~" },
    "zathura": #{ enabled: false, targets: "~" },
    "eww-laptop": #{ enabled: false, targets: "~" },
    "hyprland": #{ enabled: false, targets: "~" },
    "kakoune": #{ enabled: false, targets: "~" },
    "tmux": #{ enabled: false, targets: "~" },

    // This is just random files that should be in the dotfiles, but shouldn't ever be deployed
    "other-dotfiles-stuff": #{ enabled: false, targets: "~" },
}
