#Requires AutoHotkey v2.0+

; === Step 1: Run server locally ===
batFile1 := A_ScriptDir "\server.bat"
Run(batFile1)
Sleep 2000  ; wait for server to start

; === Step 2: Run patient display and staff panel ===
batFile2 := A_ScriptDir "\qms-offline.bat"
Run(batFile2)
Sleep 2000  ; wait for server to start

