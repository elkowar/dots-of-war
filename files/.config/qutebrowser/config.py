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

config.bind("<Alt-j>", "scroll-px 0 40")
config.bind("<Alt-k>", "scroll-px 0 -40")

c.tabs.show = "multiple"
c.tabs.show_switching_delay = 1000

c.statusbar.hide = False
c.fonts.statusbar = "default_size Iosevka"
c.fonts.default_family = ["JetBrainsMono"]

c.editor.command  = ["alacritty", "-e", "vim", "{file}"]


c.auto_save.session = True

c.url.searchengines = { 
    "DEFAULT": "https://duckduckgo.com/?q={}", 
    "wa": "https://wiki.archlinux.org/?search={}", 
    "y": "https://youtube.com/results?search_query={}", 
    "g": "https://google.com/search?q={}",
    "h": "https://hoogle.haskell.org/?hoogle={}",
    "w": "https://wikipedia.org/wiki/Special:Search/{}"
}


c.colors.webpage.prefers_color_scheme_dark = True
c.statusbar.padding = {"bottom": 1, "left": 8, "right": 8, "top": 1}
