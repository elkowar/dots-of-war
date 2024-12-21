import "foo" as stuff;

// stuff::stuff();

export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    desktop: SYSTEM.hostname == "fedora.fritz.box" ||SYSTEM.hostname == "fedora",
    laptop: SYSTEM.hostname == "thinkix" || SYSTEM.hostname == "frissnix",
    macbook: false,
};


private fn merge_into_home(enabled, templates) {
    #{ enabled: enabled, targets: "~", strategy: "merge", templates: templates }
}

export let eggs = #{
    "alacritty": #{ targets: "~/.config/alacritty" },
    "eww": merge_into_home(device.desktop, []),
    "eww-bar": merge_into_home(device.desktop, []),
    "foot": #{ targets: "~/.config/foot", templates: ["foot.ini"] },
    "git": merge_into_home(true, [".gitconfig"]),
    "niri": #{ targets: "~/.config/niri", templates: ["**/*.kdl"] },
    "nvim": #{ strategy: "put", targets: "~/.config/nvim", main_file: "fnl/main.fnl" },
    "profile": #{ strategy: "merge", targets: "~" },
    "starship": merge_into_home(true, []),

    "sway": merge_into_home(device.desktop, []),
    "zed": #{ strategy: "put", targets: "~/.config/zed" },
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
