#requires AutoHotkey v2.0
#SingleInstance Force

; Will hold the ID of the quake window
QuakeWin := ""
LastActiveWin := ""
Home := EnvGet("USERPROFILE")
QuakeWinIni := Home "/.quakewin"

; When pressing the key Win+`
#`::
{

    ; Use the global variable
    global QuakeWinIni
    global LastActiveWin

    ; Try to find the last used quake window pid
    if FileExist(QuakeWinIni)
    {
        ; Use the global variable
        global QuakeWin

        Pid := IniRead(QuakeWinIni, "process", "pid")

        ; Check that the Pid exists and has the same name
        try {
            if ProcessGetName(Pid) == "wezterm-gui.exe"
                QuakeWin := Pid
        }
    }

    global QuakeWin

    ; Do not detect hidden windows when checking for WinActive
    DetectHiddenWindows False

    ; If the window is already focused, hide it
    if WinActive("ahk_pid " QuakeWin)
    {
        WinMoveBottom
        WinHide

        return
    }

    ; Detect windows hidden by WinHide when checking if it exists
    DetectHiddenWindows True

    ; If the window does not exist, create it
    if not WinExist("ahk_pid " QuakeWin)
    {
        Run "wezterm-gui.exe --config window_decorations='NONE' --config prefer_egl=true --config hide_tab_bar_if_only_one_tab=true --config window_frame={border_bottom_height='1px',border_bottom_color='#45475a'}",,, &QuakeWin
        WinWait "ahk_pid " QuakeWin ; Wait for the window to be created
        WinSetExStyle "^0x80", "ahk_pid " QuakeWin ; Hide the window from taskbar

        ; Save the Pid in ini file
        IniWrite(QuakeWin, QuakeWinIni, "process", "pid")
    }
    else
    {
        ; Show and activate the window
        WinShow
        WinActivate
    }

    ; Make it take the top of the screen
    WinMove 0, 0, A_ScreenWidth, Max(Min(A_ScreenHeight/2, 1000), 600)
}
