
export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    desktop: SYSTEM.hostname == "fedora.fritz.box",
    laptop: SYSTEM.hostname == "thinkix" || SYSTEM.hostname == "frissnix",
    macbook: false,
};


private fn merge_into_home(enabled, templates) {
    #{ enabled: enabled, targets: "~", strategy: "merge", templates: templates }
}

export let eggs = #{
    "alacritty": #{ targets: "~/.config/alacritty" },
    "eww": merge_into_home(true, []),
    "eww-bar": merge_into_home(true, []),
    "foot": #{ strategy: "merge", targets: "~", templates: [".config/foot/foot.ini"] },
    "git": merge_into_home(true, [".gitconfig"]),
    "niri": #{ targets: "~/.config/niri", templates: ["**/*.kdl"] },
    "nvim": #{ strategy: "merge", targets: "~", main_file: ".config/nvim/fnl/main.fnl" },
    "profile": merge_into_home(true, []),
    "starship": merge_into_home(true, []),
    "sway": merge_into_home(true, []),
    "zed": merge_into_home(true, []),
    "zsh": merge_into_home(true, []),
    "rofi": merge_into_home(true, []),
    "gtk": merge_into_home(true, []),
    "scripts": #{ targets: "~/scripts", strategy: "merge" },

    "hyprlock": merge_into_home(device.laptop, []),
    "kanata": merge_into_home(device.laptop, []),
    "waybar": merge_into_home(device.laptop, []),

    "karabiner": merge_into_home(device.macbook, []),

    "powershell": merge_into_home(false, []),
    "sioyek": merge_into_home(false, []),
    "zathura": merge_into_home(false, []),
    "eww-laptop": merge_into_home(false, []),
    "hyprland": merge_into_home(false, []),
    "kakoune": merge_into_home(false, []),
    "tmux": merge_into_home(false, []),

    // This is just random files that should be in the dotfiles, but shouldn't ever be deployed
    "other-dotfiles-stuff": #{ enabled: false, targets: "~/this-shouldnt-exist" },
}
