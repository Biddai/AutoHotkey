#Requires AutoHotkey v2.0

^!x:: {  ; Ctrl+Alt+X
    SetTitleMatchMode 2   ; allow partial title matches

    ; 1) Loop through all Chrome/Electron windows
    for hwnd in WinGetList("ahk_class Chrome_WidgetWin_1") {
        title := WinGetTitle(hwnd)
        if InStr(title, "ChatGPT") {
            ; 2) Check if minimized (-1 = iconic/minimized)
            state := WinGetMinMax("ahk_id " hwnd)
            if (state = -1)
                WinRestore("ahk_id " hwnd)
            ; 3) Activate it
            WinActivate("ahk_id " hwnd)
            return
        }
    }

    ; 4) Not running? Use Windows Search to launch it
    Send("{LWin down}s{LWin up}")
    Sleep 200
    Send("ChatGPT")
    Sleep 300
    Send("{Enter}")
}
