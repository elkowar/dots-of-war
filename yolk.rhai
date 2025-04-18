export const themes = #{
    gruvbox: #{
        bg: "#1d2021",
        fg: "#ebdbb2",
    }
};
export const theme = themes.gruvbox;

export const device = #{
    thinkix: SYSTEM.hostname == "thinkix",
    crabbix: SYSTEM.hostname == "crabbix",
    desktop: SYSTEM.hostname == "fedora.fritz.box" || SYSTEM.hostname == "fedora",
    laptop: SYSTEM.hostname == "thinkix"
        || SYSTEM.hostname == "frissnix"
        || SYSTEM.device_name == "Matthiass MacBook Pro"
        || SYSTEM.hostname == "kenbun-laptop-leon"
        || SYSTEM.hostname == "crabbix",

    linux: SYSTEM.platform == "Linux",
    windows: SYSTEM.platform == "Windows",

    macbook: SYSTEM.device_name == "Matthiass MacBook Pro",
    kenbun:  SYSTEM.device_name == "Matthiass MacBook Pro" || SYSTEM.hostname == "kenbun-laptop-leon",
};

device.linux_laptop = device.laptop && device.linux;


private fn merge_into_home(enabled, templates) {
    #{ enabled: enabled, targets: "~", strategy: "merge", templates: templates }
}


export let eggs = #{
    "nvim-old": #{ enabled: false },
    "wallpapers": #{ targets: "~/.config/wallpapers" },
    "alacritty": #{ enabled: !device.windows, targets: "~/.config/alacritty" },
    "eww": merge_into_home(device.linux && device.desktop || device.thinkix, []),
    "eww-bar": merge_into_home(device.linux && device.desktop, []),
    "foot": #{ enabled: device.linux, targets: "~/.config/foot", templates: ["foot.ini"] },
    "git": merge_into_home(true, [".gitconfig"]),
    "niri": #{ enabled: device.linux, targets: "~/.config/niri", templates: ["**/*.kdl"], main_file: "config.kdl" },
    "nvim": #{ enabled: true, strategy: "put", targets: "~/.config/nvim", main_file: "init.lua" },
    "profile": #{ enabled: device.linux, strategy: "merge", targets: "~" },
    "starship": merge_into_home(true, []),
    "bat": #{ enabled: device.linux || device.macbook, strategy: "put", targets: "~/.config/bat", templates: ["config"]},

    "sway": merge_into_home(device.desktop && device.linux, []),
    "zed": #{ enabled: !device.windows, strategy: "put", targets: "~/.config/zed" },
    "zsh": merge_into_home(!device.windows, []),
    "rofi": merge_into_home(device.linux, []),
    "gtk": merge_into_home(device.linux, []),
    "scripts": #{ enabled: device.linux, targets: "~/scripts", strategy: "merge" },

    "hyprlock": merge_into_home(device.laptop && device.linux, []),
    "kanata": merge_into_home(device.laptop, []),
    "waybar": merge_into_home(device.laptop && device.linux, ["*"]),
    "kanshi": #{ enabled: device.laptop && device.linux, targets: "~/.config/kanshi" },

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
