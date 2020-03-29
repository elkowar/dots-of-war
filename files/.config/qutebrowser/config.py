import dracula.draw

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 4,
        'horizontal': 8
    }
})

config.load_autoconfig()
c.backend = 'webengine'

config.unbind("<Ctrl-tab>")
config.bind("<Ctrl-Tab>", "tab-next")
config.bind("<Ctrl-Shift-Tab>", "tab-prev")
config.bind("<Ctrl-L>", "set-cmd-text -s :open")

config.bind(",y", "hint links spawn mpv {hint-url}")
config.bind(",Y", "spawn mpv {url}")

c.tabs.show = "always"
c.tabs.show_switching_delay = 1000

c.statusbar.hide = False
c.fonts.statusbar = "default_size Iosevka"

c.editor.command  = ["alacritty", "-e", "vim", "{file}"]


c.statusbar.padding = {"bottom": 1, "left": 8, "right": 8, "top": 1}
