#Requires AutoHotkey v2.0+

; === Step 1: Run patient display and staff panel ===
batFile2 := A_ScriptDir "\qms.bat"
Run(batFile2)
Sleep 2000  ; wait for server to start

