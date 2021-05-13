export EDITOR="nvim"
export PATH="/home/leon/.local/bin/scripts:$PATH:/home/leon/.emacs.d/bin/"
export PATH="$HOME/.npm-global/bin:$HOME/intelliJInstall/bin:$PATH:$HOME/.cargo/bin"
export PATH="$HOME/.nix-profile/share/applications/:$PATH"
export PATH="/home/leon/.nix-profile/bin/:$PATH"
export PATH="/home/leon/.cpm/bin:$PATH"
export PATH="/home/leon/.local/bin:$PATH"
export PATH="/home/leon/.nimble/bin:$PATH"
export _JAVA_AWT_WM_NONREPARENTING=1

export RANGER_LOAD_DEFAULT_RC=FALSE

export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --null | xargs -0 dirname | sort -u"

export LESSHISTFILE="/dev/null"


export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"

export NNN_PLUG='F:fzopen;S:suedit'

[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || export QT_QPA_PLATFORMTHEME="qt5ct"

export FREETYPE_PROPERTIES='truetype:interpreter-version=40'
export _JAVA_OPTIONS='-Dswing.aatext=true -Dawt.useSystemAAFontSettings=lcd'
if [ -e /home/leon/.nix-profile/etc/profile.d/nix.sh ]; then 
  . /home/leon/.nix-profile/etc/profile.d/nix.sh; 
fi # added by Nix installer

export XDG_DATA_DIRS="$HOME/.nix-profile/share/applications:$HOME/.local/share/applications:/usr/local/share:/usr/share"
export LOCALE_ARCHIVE=$(nix-build '<nixpkgs>' --no-out-link -A glibcLocales)/lib/locale/locale-archive

export _JAVA_AWT_WM_NONREPARENTING=1

