

function fish_prompt
  # Cache exit status
  set -l last_status $status

  set -l normal (set_color normal)
  set -l white (set_color FFFFFF)
  set -l turquoise (set_color 5fdfff)
  set -l orange (set_color df5f00)
  set -l hotpink (set_color df005f)
  set -l blue (set_color blue)
  set -l limegreen (set_color 87ff00)
  set -l purple (set_color af5fff)

 
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
  echo -n $white'─'$hotpink$current_user$white' in '$limegreen(prompt_pwd)
  echo -n $turquoise$git_prompt
  if test $last_status -gt 0
    echo -n ' '$hotpink$last_status
  end
  echo

  echo -n $white'╰─λ '
  echo -n $normal
end

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


# needed so fish doesn't draw it by itself
function fish_mode_prompt
end

# ⌁
