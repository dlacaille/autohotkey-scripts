#HotIf WinActive("ahk_exe ms-teams.exe")
XButton2::^+o
XButton1::^+m
#HotIf

#HotIf WinActive("ahk_exe Zoom.exe")
XButton2::!v
XButton1::!a
#HotIf

#HotIf WinActive("ahk_exe slack.exe")
XButton1:: {
  Send("!{Left}")
  Send("^!{Space}")
}
#HotIf
