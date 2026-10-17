@echo off
rem Uconnect 8.4AN emulator: fake vehicle backend (port 4400) + stock HMI in Adobe AIR.
cd /d "%~dp0"
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":4400 .*LISTENING"') do taskkill /F /PID %%p >nul 2>&1
start "Uconnect backend" /min python backend.py
timeout /t 1 /nobreak >nul
rem Hardware panel (volume/tune knobs, faceplate keys, reverse gear) in the default browser.
start "" http://127.0.0.1:4401/
"%~dp0..\tools\airsdk\bin\adl.exe" -profile extendedDesktop hmi\emulator-app.xml hmi
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":4400 .*LISTENING"') do taskkill /F /PID %%p >nul 2>&1
