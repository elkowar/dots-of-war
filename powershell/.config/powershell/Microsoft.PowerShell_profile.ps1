if ($host.Name -eq "ConsoleHost")
{
  Import-Module PSReadline
  Set-PSReadLineKeyHandler -Chord Control+Delete -Function BackwardKillWord
  Set-PSReadLineKeyHandler -Chord Control+Backspace -Function BackwardKillWord
  Set-PSReadLineKeyHandler -Chord Control+RightArrow -Function NextWord
  Set-PSReadLineKeyHandler -Chord Control+LeftArrow -Function BackwardWord

  Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
  Set-PSReadlineKeyHandler –Key DownArrow -Function HistorySearchForward

  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadLineKeyHandler -Chord Control+c -Function RevertLine
  #Set-PSReadlineKeyHandler -Chord Control+C -Function CancelLine

}

function Convert-HexToAnsiiEscape
{
  param ([Parameter(Mandatory)] [string]$hex)
  $nohash = $hex.substring(1)
  $rgb = $nohash -split '(..)' -ne '' | ForEach-Object { [Convert]::ToInt64($_, 16) }
  [char]27 + "$ansi_escape[38;2;{0};{1};{2}m" -f $rgb[0], $rgb[1],$rgb[2]
}

$Colors = @{
  cyan = Convert-HexToAnsiiEscape("#8ec07c")
  white = Convert-HexToAnsiiEscape("#ebdbb2")
  green = Convert-HexToAnsiiEscape("#b8bb26")
}


function prompt_git_status
{
  try
  {
    $branch = (git branch | Select-String -Pattern "\* ") -Replace "\* ",""
    $change_indicator = (git status --short) ?  "*" : ""
    $branch ?  "($($Colors.cyan)$branch$($Colors.white)$change_indicator)" : ""
  } catch
  {
    ""
  }
}

function shorten_string_to
{
  param ([string]$text, [int]$length)
  ($text.length -gt $length) ? $text.substring(0, $length) : $text
}

function shorten_path
{
  param ([string]$path)
  $no_home=($path -Replace "$HOME","~")
  $segments = ($no_home -split "/")
  if ($segments.count -lt 2)
  {
    return $no_home
  }
  $init_part = $segments[0..($segments.count - 2)] 
  $last_part = $segments[($segments.count - 1)]
  $cleaned_init = ($init_part | ForEach-Object { shorten_string_to -text $_ -length 5 }) -join "/"
  return "$cleaned_init/$last_part"
}

function Prompt
{
  $prompt = "╭───$($Colors.cyan)$env:USER"
  $prompt += "$($Colors.white) powershelling in "
  $prompt += "$($Colors.green)$(shorten_path(Get-Location))$($Colors.white) "
  $prompt += prompt_git_status
  $prompt += "`n╰─λ "
  $prompt
}
