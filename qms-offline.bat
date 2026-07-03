@echo off

:: 1. Launch Chrome immediately in a separate process.
:: The START command is what lets the script continue running.
START "" "C:\Program Files\Google\Chrome\Application\chrome.exe" ^
  --user-data-dir="C:\ChromeKiosk" ^
  --kiosk ^
  --autoplay-policy=no-user-gesture-required ^
  --no-first-run ^
  --window-position=1920,0 ^
  --disable-infobars ^
  --disable-session-crashed-bubble ^
  "http://localhost:5000/display?kiosk=true"

:: 2. Clear the screen and display the loading animation.
CLS
ECHO.
ECHO  Starting up QMS OPD Display in Kiosk Mode..
<nul set /p "=  Status: ["

:: This loop pauses for 1 second, 3 times.
FOR /L %%i IN (1,1,3) DO (
    <nul set /p "=###"
    TIMEOUT /T 1 /NOBREAK >nul
)

:: 3. Finish the animation and close the window.
ECHO ] Successfully loaded QMS Display!

REM === Step 3: Open Chrome with URL ===

set "chromePath=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "url=http://localhost:5000/"

REM Launch Chrome and immediately close this window
start "" "%chromePath%" "%url%"
ECHO ] Successfully loaded QMS Panel!
ECHO.
ECHO  This command window will now close!
TIMEOUT /T 1 >nul

