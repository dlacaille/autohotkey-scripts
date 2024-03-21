#requires AutoHotkey v2.0
#SingleInstance Force

; Make sure this is run as admin
; (deprecated, use UI Access in AutoHotKey Dash instead)
;full_command_line := DllCall("GetCommandLine", "str")
;if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
;{
;    try
;    {
;        if A_IsCompiled
;            Run '*RunAs "' A_ScriptFullPath '" /restart'
;        else
;            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
;    }
;    ExitApp
;}

; Get numeric BGR value from numeric RGB value or HTML color name
ConvertToBGRfromRGB(RGB) {
  ; HEX values
  BGR := SubStr(RGB, -1, 2) SubStr(RGB, 1, 4)
  Return BGR
}

; Make a window transparent
EnableBlur(hWnd)
{
    padding := A_PtrSize == 8 ? 4 : 0

    AccentPolicy := Buffer(4*4, 0)
    WindowCompositionAttributeData := Buffer(4 + padding + A_PtrSize + 4 + padding, 0)

    ;WindowCompositionAttribute
    WCA_ACCENT_POLICY := 19

    ;AccentState
    ACCENT_DISABLED := 0,
    ACCENT_ENABLE_GRADIENT := 1,
    ACCENT_ENABLE_TRANSPARENTGRADIENT := 2,
    ACCENT_ENABLE_BLURBEHIND := 3,
    ACCENT_ENABLE_ACRYLICBLURBEHIND := 4,
    ACCENT_INVALID_STATE := 4

    NumPut "int", ACCENT_ENABLE_BLURBEHIND, AccentPolicy

    NumPut "int", WCA_ACCENT_POLICY, WindowCompositionAttributeData
    NumPut "ptr", AccentPolicy.ptr, WindowCompositionAttributeData, 4 + padding
    NumPut "uint", AccentPolicy.Size, WindowCompositionAttributeData, 4 + padding + A_PtrSize

    DllCall "user32\SetWindowCompositionAttribute", "ptr", hWnd, "ptr", WindowCompositionAttributeData
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
        Sleep 1000
    }

    ; Show and activate the window
    WinShow
    WinActivate
    Sleep 200

    ; Make it take the top of the screen
    WinMove 0, 0, A_ScreenWidth, Max(Min(A_ScreenHeight/2, 1000), 600)

    ; Make the window have an acrylic blur effect
    ;EnableBlur WinGetID("ahk_pid " QuakeWin)
}
