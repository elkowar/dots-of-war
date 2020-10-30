#! /bin/sh

print_host () {
    [ -z "$HOST" ] && cat "/etc/hostname" || printf "%s\n" "$HOST"
}

print_kernel () {
    kernel="$(uname -r)"
    kernel="${kernel%%_*}"
    kernel="${kernel%%-*}"
    printf "%s\n" "$kernel"
}

print_pkgs () {
    C () { command -v "$@" >"/dev/null" 2>&1 ; }
    if [ -d "/bedrock" ] ; then
        pkgs="N/A"
    elif C dpkg ; then
        pkgs="$(printf "$(dpkg-query -f "${binary:Package}\n" -W | wc -l)")"
    elif C rpm  ; then
        pkgs="$(rpm -qa | wc -l)"
    elif C pacman ; then
        pkgs="$(pacman -Qq | wc -l)"
    elif C xbps-query ; then
        pkgs="$(xbps-query -l | wc -l)"
    elif C kiss l ; then
        pkgs="$(kiss l | wc -l)"
    elif C yum ; then
        pkgs="$(yum list installed | wc -l)"
    elif C bonsai ; then
        pkgs="$(bonsai list | wc -l)"
    elif C guix ; then
        pkgs="$(guix package --list-installed | wc -l)"
    elif C pkg  ; then
        pkgs="$(pkg info -a | wc -l | tr -d ' ')"
    else
        pkgs="N/A"
    fi
    printf "%s\n" "$pkgs"
}

print_shell () {
    shell="${SHELL##*/}"
    printf "%s\n" "$shell"
}

print_os () {
    if [ -e /etc/os-release ] && . /etc/os-release ; then
        printf "%s\n" "$PRETTY_NAME"
    elif [ -d "/bedrock" ] ; then
        cat "/bedrock/etc/bedrock-release"
    else
        uname -s || printf "%s\n" "N/A"
    fi
}

print_wal () {
    wal="$(xrdb -q | grep wallpaper | awk 'NR == 2 {print $2}')"
    printf "%s\n" "$wal"
}

print_colors () {
    colors="$(xrdb -q | grep "#include" | awk '{print $2}')"
    colors="${colors##*/}"
    colors=${colors%\"}
    printf "%s\n" "$colors"
}

print_user () {
    if [ -z "$LOGNAME" ]; then
        printf "%s\n" "N/A"
    else
        printf "%s\n" "$LOGNAME"
    fi
}

print_resolution () {
    printf "\n"
}


set_colors () {
    r="\033[32m"
    re="\033[0m"
    gb="\033[42m"
    bl="\e[7m  \e[0m"
    gb="$g$bl"
    gbs="$gb$gb$gb$gb$gb$gb"

}

print_colors () {
    printf "\n"
    printf " \e[41m    \e[42m    \e[43m    \e[44m    \e[45m    \e[46m    \e[0m\n"
    printf "\n"
}

print_wm () {
    [ "$(command -v xprop >/dev/null 2>&1)" ] && \
        WM="$(xprop -id "$(xprop -root -notype \
        | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}')" -notype -f _NET_WM_NAME 8t \
        | grep -i "WM_NAME" \
        | cut -f2 -d \")" || \
        WM="TTY"

    printf "%s\n" "$WM"
}

set_colors
printf "\n"
printf " $r┌────────────────────────────────────┐$re\n"
printf " $r│ KER:$re %-30s$r│$re\n" "$(print_kernel)"
printf " $r│ PKG:$re %-30s$r│$re\n" "$(print_pkgs)"
printf " $r│ SHE:$re %-30s$r│$re\n" "$(print_shell)"
printf " $r│ DIS:$re %-30s$r│$re\n" "$(print_os)"
printf " $r│ SES:$re %-30s$r│$re\n" "$(print_wm)"
printf " $r│ HOS:$re %-30s$r│$re\n" "$(print_host)"
printf " $r│ USE:$re %-30s$r│$re\n" "$(whoami)"
printf " $r└────────────────────────────────────┘$re\n"
printf "\n"
