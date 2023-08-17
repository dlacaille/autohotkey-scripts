#requires AutoHotkey v2.0
#SingleInstance Force

; Make sure this is run as admin
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}

; Will hold the ID of the quake window
QuakeWin := ""
LastActiveWin := ""

; When pressing the key Win+`
#`::
{
    ; Use the global variable
    global QuakeWin
    global LastActiveWin

    ; Do not detect hidden windows when checking for WinActive
    DetectHiddenWindows False

    ; If the window is already focused, hide it
    if WinActive("ahk_pid " QuakeWin)
    {
        WinMoveBottom
        WinHide

        ; If the last active window still exists, switch to it
        if WinExist("ahk_pid " LastActiveWin)
            WinActivate 

        return
    }

    ; Get the ID of the currently active window
    Try LastActiveWin := WinGetPID("A")

    ; Detect windows hidden by WinHide when checking if it exists
    DetectHiddenWindows True

    ; If the window does not exist, create it
    if not WinExist("ahk_pid " QuakeWin)
    {
        Run "wezterm-gui.exe --config window_decorations='NONE' --config hide_tab_bar_if_only_one_tab=true",,, &QuakeWin
        WinWait "ahk_pid " QuakeWin
    }

    ; Show and activate the window
    WinShow
    WinActivate

    ; Make it take the top of the screen
    WinMove 0, 0, A_ScreenWidth, 1000
}
