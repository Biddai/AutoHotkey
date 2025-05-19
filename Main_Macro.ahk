#Requires AutoHotkey v2.0
; Currently contains macros for opening VS Code and ChatGPT
; More to come...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Opens VS code. If Code is already open, it will bring it to front. 
; If the vs code window is already in front, it will open a new vs code window.
^!v:: {  ; Ctrl+Alt+V
    SetTitleMatchMode 2   ; allow partial title matches
    ; 0) If active window is a folder, open it in VS Code

    active := WinExist("A")
    cls    := WinGetClass("ahk_id " active)

    ; ——————————————————————————
    ; 1) If Explorer is active, open that folder in Code via CLI
    ; ——————————————————————————
    if (cls = "CabinetWClass" || cls = "ExplorerWClass") {
        shell := ComObject("Shell.Application")
        folder := ""
        for window in shell.Windows() {
            if (window.HWND = active) {
                folder := window.Document.Folder.Self.Path
                break
            }
        }
        if (folder) {
            comspec := EnvGet("ComSpec")                    ; usually C:\Windows\System32\cmd.exe
            cmd := comspec . ' /c code --new-window "' folder '"'
            Run(cmd, "", "Hide")
        }
        return
    }

    ; 2) Loop through all VS Code windows
    for hwnd in WinGetList("ahk_exe Code.exe") {
        title := WinGetTitle(hwnd)
        if InStr(title, "Visual Studio Code") {
            state := WinGetMinMax("ahk_id " hwnd)
            if (state = -1) {
                ; minimized: restore and activate
                WinRestore("ahk_id " hwnd)
                WinActivate("ahk_id " hwnd)
            } else {
                ; already active:
                if(WinActive("ahk_exe Code.exe")){
                    Send("^+n")  ; Ctrl+Shift+N to open new window
                }
                else{
                    WinActivate("ahk_id " hwnd)
                }
                
                
            }
            return
        }
    }

    ; 3) Not running → launch VS Code GUI directly (no console)
    local appData := EnvGet("LocalAppData")
    local exePath := appData . "\Programs\Microsoft VS Code\Code.exe"
    Run('"' exePath '"')
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

^!z::{
    if WinActive("ahk_exe Code.exe") {
    ; VS Code is the frontmost window
    MsgBox("VS Code is active")
} else {
    MsgBox("VS Code is NOT active")
}
}