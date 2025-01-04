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


Invoke-Expression (&starship init powershell)