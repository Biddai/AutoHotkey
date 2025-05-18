#Requires AutoHotkey v2.0
; Opens VS code. If Code is already open, it will bring it to front. 
; If the vs code window is already in front, it will open a new vs code window.
^!v:: {  ; Ctrl+Alt+V
    SetTitleMatchMode 2   ; allow partial title matches

    ; 1) Loop through all VS Code windows
    for hwnd in WinGetList("ahk_exe Code.exe") {
        title := WinGetTitle(hwnd)
        if InStr(title, "Visual Studio Code") {
            state := WinGetMinMax("ahk_id " hwnd)
            if (state = -1) {
                ; minimized: restore and activate
                WinRestore("ahk_id " hwnd)
                WinActivate("ahk_id " hwnd)
            } else {
                ; already active: bring to front and open a new window
                WinActivate("ahk_id " hwnd)
                Send("^+n")  ; Ctrl+Shift+N to open new window
            }
            return
        }
    }

    ; 2) Not running → launch VS Code GUI directly (no console)
    local appData := EnvGet("LocalAppData")
    local exePath := appData . "\Programs\Microsoft VS Code\Code.exe"
    Run('"' exePath '"')
}

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
