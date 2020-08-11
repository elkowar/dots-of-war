function __fish_vi_mode_prompt_real
  set -l turquoise (set_color 5fdfff)
  set -l orange (set_color df5f00)
  switch $fish_bind_mode
    case insert
      echo -n "─"
    case default
      echo -n $turquoise'N'
    case visual
      echo -n $orange'V'
    case replace_one
      echo -n $turquoise'R'
  end
end


# Cache exit status
set -l last_status $status

# Gruvboxy
set -l normal    ( set_color normal)
set -l white     ( set_color ebdbb2)
set -l turquoise ( set_color 83a598)
set -l orange    ( set_color fe8019)
set -l aqua      ( set_color 8ec07c)
set -l blue      ( set_color 83a598)
set -l limegreen ( set_color b8bb26)
set -l purple    ( set_color d3869b)


# Configure __fish_git_prompt
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_color 5fdfff
set -g __fish_git_prompt_color_flags df5f00
set -g __fish_git_prompt_color_prefix white
set -g __fish_git_prompt_color_suffix white
set -g __fish_git_prompt_showdirtystate true
set -g __fish_git_prompt_showuntrackedfiles true
set -g __fish_git_prompt_showstashstate true
set -g __fish_git_prompt_show_informative_status true 

set -l current_user (whoami)
set -l vi_mode (__fish_vi_mode_prompt_real)
set -l git_prompt (__fish_git_prompt " (%s)")
#(pwd|sed "s=$HOME=~=")

set -g fish_prompt_pwd_dir_length 1

echo -n $white'╭─'$vi_mode
echo -n $white'─'$aqua$current_user$white' in '$limegreen(prompt_pwd)
echo -n $turquoise$git_prompt
if test $last_status -gt 0
  echo -n ' '$orange$last_status
end
echo

echo -n $white'╰─λ '
echo -n $normal
