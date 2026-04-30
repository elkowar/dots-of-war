export const themes = #{
    gruvbox: #{ bg: "#1d2021", fg: "#ebdbb2" }
};
export const theme = themes.gruvbox;



// device config
export const device = #{
    linux: SYSTEM.platform == "Linux",
    windows: SYSTEM.platform == "Windows",

    thinkix: SYSTEM.hostname == "thinkix",
    crabbix: SYSTEM.hostname == "crabbix",
    frissnix: SYSTEM.hostname == "frissnix",
    kenbun_dell: SYSTEM.hostname in ["kenbun-laptop-leon", "kenbun-old-matze"],
    fedora_desktop: SYSTEM.hostname in ["fedora.fritz.box", "fedora"],
    matthiass_mac: SYSTEM.device_name == "Matthiass MacBook Pro",
    kenbun_mac: SYSTEM.device_name == "Leons-MacBook-Pro.local",

};
device.desktop = device.fedora_desktop;
device.laptop = device.thinkix || device.crabbix || device.frissnix || device.kenbun_dell || device.matthiass_mac || device.kenbun_mac;
device.macbook = device.matthiass_mac || device.kenbun_mac;
device.kenbun = device.matthiass_mac || device.kenbun_dell || device.kenbun_mac;

device.linux_laptop = device.laptop && device.linux;


export const settings = #{
    use_noctalia: device.laptop && device.kenbun && device.linux
};



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
    "nushell": #{ enabled: device.linux, strategy: "put", targets: "~/.config/nushell" },

    "noctalia": #{ enabled: settings.use_noctalia, strategy: "put", targets: "~/.config/noctalia", templates: [] },

    "sway": merge_into_home(device.desktop && device.linux, []),
    "zed": #{ enabled: !device.windows, strategy: "put", targets: "~/.config/zed" },
    "zsh": merge_into_home(!device.windows, []),
    "rofi": #{ enabled: device.linux, targets: "~/.config/rofi" },
    "gtk": merge_into_home(device.linux, []),
    "scripts": #{ enabled: device.linux, targets: "~/scripts", strategy: "merge" },

    "hyprlock": merge_into_home(device.laptop && device.linux, []),
    "kanata": #{ enabled: device.linux, targets: "~/.config/kanata" },
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
