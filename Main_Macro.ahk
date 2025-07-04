#Requires AutoHotkey v2.0
; Currently contains macros for opening VS Code and ChatGPT
; More to come...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Opens VS code. If Code is already open, it will bring it to front. 
; If the vs code window is already in front, it will open a new vs code window.
^!+v:: {  ; Ctrl+Alt+V
    SetTitleMatchMode 2   ; allow partial title matches
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
            comspec := EnvGet("ComSpec")
            cmd := comspec . ' /c code --new-window "' folder '"'
            Run(cmd, "", "Hide")
        }
        return
    }

    ; 2) Loop through all VS Code windows
    if(MinimizeOrRestoreWrapper("ahk_exe Code.exe")) {
        return
    }

    ; 3) Not running → launch VS Code GUI directly (no console)
    local appData := EnvGet("LocalAppData")
    local exePath := appData . "\Programs\Microsoft VS Code\Code.exe"
    Run('"' exePath '"')
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0
; CHATGPT MACRO
^!+x:: {  ; Ctrl+Alt+X
    SetTitleMatchMode 2   ; allow partial title matches

    ; 1) Loop through all Chrome/Electron windows
    if(MinimizeOrRestoreWrapper("ahk_class Chrome_WidgetWin_1", "ChatGPT")) {
        return
    }

    ; 4) Not running? Use Windows Search to launch it
    Run("ChatGPT")
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0
; OBSIDIAN MACRO
^!+c:: {  ; Ctrl+Alt+C
    SetTitleMatchMode 2   ; allow partial title matches

    ; 1) Loop through all Chrome/Electron windows
    if(MinimizeOrRestoreWrapper("ahk_exe Obsidian.exe")) {
        return
    }

    ; 4) Not running? Use Windows Search to launch it
    Run("obsidian")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0
; Discord MACRO
^!+d:: {  ; Ctrl+Alt+d
    SetTitleMatchMode 2   ; allow partial title matches

    ; 1) Loop through all Chrome/Electron windows
    if(MinimizeOrRestoreWrapper("ahk_exe DiscordPTB.exe")) {
        return
    }

    ; 4) Not running? Use Windows Search to launch it
    Run("discord")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0
; Spotify MACRO
^!+s:: {  ; Ctrl+Alt+s
    SetTitleMatchMode 2   ; allow partial title matches
    ; 1) Loop through all Chrome/Electron windows
    if(MinimizeOrRestoreWrapper("ahk_exe Spotify.exe")) {
        return
    }
    ; 4) Not running? Use Windows Search to launch it
    Run("spotify")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0
; Explorer MACRO
^!+e:: {  ; Ctrl+Alt+e
    SetTitleMatchMode 2   ; allow partial title matches
    ; 1) Loop through all Chrome/Electron windows
    if(MinimizeOrRestoreWrapper("ahk_exe explorer.exe", "File Explorer")) {
        return
    }
    ; 4) Not running? Use Windows Search to launch it
    Run("explorer")
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0
; Brave MACRO
; Note - make sure not to restore chatgpt
^!+b:: {  ; Ctrl+Alt+b
    SetTitleMatchMode 2   ; allow partial title matches

    if(MinimizeOrRestoreWrapper("ahk_exe brave.exe","brave")) {
        return
    }
    ; 4) Not running? Use Windows Search to launch it
    Run("brave")
}
;;;;;;;;;;;;;;;;;
; Utilities
MinimizeOrRestore(hwnd) {
    ; 2) Check if minimized (-1 = iconic/minimized)
    state := WinGetMinMax("ahk_id " hwnd)
    if (WinActive("ahk_id " hwnd))
        WinMinimize("ahk_id " hwnd) ; If active, minimize it
    else 
        WinActivate("ahk_id " hwnd) 
}

MinimizeOrRestoreWrapper(exe,req_title := "") {
    for hwnd in WinGetList(exe) {
        title := WinGetTitle(hwnd)
        if(req_title != "" && !InStr(title, req_title))
            continue  ; Skip if the title doesn't match the required substring
        MinimizeOrRestore(hwnd)
        return true
    }
    return false
}
