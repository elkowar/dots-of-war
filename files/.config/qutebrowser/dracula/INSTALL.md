### [qutebrowser](https://www.qutebrowser.org/)

#### Install using Git

If you are a git user, you can install the theme and keep up to date by cloning the repo:

    $ git clone https://github.com/dracula/qutebrowser-dracula-theme.git dracula

#### Install manually

Download using the [GitHub .zip download](https://github.com/dracula/qutebrowser.git) option and unzip.

#### Activating theme

- Find your *[qutebrowser configuration directory](https://www.qutebrowser.org/doc/help/configuring.html#configpy)* (see e.g. `:version` in qutebrowser). This folder should be located at the "config" location listed on qute://version, which is typically ~/.config/qutebrowser/ on Linux, ~/.qutebrowser/ on macOS, and %APPDATA%/qutebrowser/config/ on Windows.
- Move the repository folder to `dracula` inside the configuration directory.
- In your [qutebrowser config.py file](https://www.qutebrowser.org/doc/help/configuring.html#configpy), include the following:

```python
import dracula.draw

# Load existing settings made via :set
config.load_autoconfig()

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})
```
