export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    desktop: SYSTEM.hostname == "fedora.fritz.box" ||SYSTEM.hostname == "fedora",
    laptop: SYSTEM.hostname == "thinkix" || SYSTEM.hostname == "frissnix",

    linux: SYSTEM.platform == "Linux",
    windows: SYSTEM.platform == "Windows",

    macbook: "Matthiass-MacBook-Pro" in SYSTEM.hostname,
    kenbun: "Matthiass-MacBook-Pro" in SYSTEM.hostname,
};



private fn merge_into_home(enabled, templates) {
    #{ enabled: enabled, targets: "~", strategy: "merge", templates: templates }
}

export let eggs = #{
    "alacritty": #{ enabled: !device.windows, targets: "~/.config/alacritty" },
    "eww": merge_into_home(device.linux && device.desktop, []),
    "eww-bar": merge_into_home(device.linux && device.desktop, []),
    "foot": #{ enabled: device.linux, targets: "~/.config/foot", templates: ["foot.ini"] },
    "git": merge_into_home(true, [".gitconfig"]),
    "niri": #{ enabled: device.linux, targets: "~/.config/niri", templates: ["**/*.kdl"] },
    "nvim": #{ strategy: "put", targets: "~/.config/nvim", main_file: "init.lua" },
    "profile": #{ enabled: device.linux, strategy: "merge", targets: "~" },
    "starship": merge_into_home(true, []),

    "sway": merge_into_home(device.desktop && device.linux, []),
    "zed": #{ enabled: !device.windows, strategy: "put", targets: "~/.config/zed" },
    "zsh": merge_into_home(!device.windows, []),
    "rofi": merge_into_home(device.linux, []),
    "gtk": merge_into_home(device.linux, []),
    "scripts": #{ enabled: device.linux, targets: "~/scripts", strategy: "merge" },

    "hyprlock": merge_into_home(device.laptop && device.linux, []),
    "kanata": merge_into_home(device.laptop && device.linux, []),
    "waybar": merge_into_home(device.laptop && device.linux, []),

    "karabiner": merge_into_home(device.macbook, []),
    "sioyek": merge_into_home(device.linux, []),

    "powershell": #{ enabled: device.windows, targets: if device.windows { "~/Documents/PowerShell" } else { "~/.config/powershell" } },
    "zathura": merge_into_home(false, []),
    "eww-laptop": merge_into_home(false, []),
    "hyprland": merge_into_home(false, []),
    "kakoune": merge_into_home(false, []),
    "tmux": merge_into_home(false, []),

    // This is just random files that should be in the dotfiles, but shouldn't ever be deployed
    "other-dotfiles-stuff": #{ enabled: false, targets: "~/this-shouldnt-exist" },
}
