@echo off
REM === Step 3: Open Chrome with URL ===

set "chromePath=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "url=https://hsegamat2.moh.gov.my/qms/"

REM Launch Chrome and immediately close this window
start "" "%chromePath%" "%url%"
ECHO ] Successfully loaded QMS Panel!
ECHO.
ECHO  This command window will now close!
TIMEOUT /T 1 >nul