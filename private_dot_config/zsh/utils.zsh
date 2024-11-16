# This part is stolen https://github.com/druskus20/dots/blob/master/zsh/.config/zsh/utils/utils.zsh
function do-nothing() {}
zle -N do-nothing do-nothing

# Disable default keybinds
function clear-keybinds() {
  local key keys=(
    "^A"   "^B"   "^D"   "^E"   "^F"   "^N"   "^O"   "^P"   "^Q"   "^S"   "^T"   "^W"   "^F"   "^K"
    "^X*"  "^X="  "^X?"  "^XC"  "^XG"  "^Xa"  "^Xc"  "^Xd"  "^Xe"  "^Xg"  "^Xh"  "^Xm"  "^Xn"
    "^Xr"  "^Xs"  "^Xt"  "^Xu"  "^X~"  "^[ "  "^[!"  "^['"  "^[,"  "^[-"  "^[."  "^[0"  "^[1"
    "^[2"  "^[3"  "^[4"  "^[5"  "^[6"  "^[7"  "^[8"  "^[9"  "^[<"  "^[>"  "^[?"  "^[A"  "^[B"
    "^[C"  "^[D"  "^[F"  "^[G"  "^[L"  "^[M"  "^[N"  "^[P"  "^[Q"  "^[S"  "^[T"  "^[U"  "^[W"
    "^[_"  "^[a"  "^[b"  "^[c"  "^[d"  "^[f"  "^[g"  "^[l"  "^[n"  "^[p"  "^[q"  "^[s"  "^[t"
    "^[u"  "^[w"  "^[y"  "^[z"  "^[|"  "^[~"  "^[^I" "^[^J" "^[^_" "^[\"" "^[\$" "^X^B"
    "^X^F" "^X^J" "^X^K" "^X^N" "^X^O" "^X^R" "^X^U" "^X^X" "^[^D" "^[^G")
  for key in $keys; do
    bindkey -r $key 
  done
}
zle -N clear-keybinds clear-keybinds
