@echo off
rem Uconnect 8.4AN emulator: fake vehicle backend (port 4400) + boot splash + stock HMI in Adobe AIR.
rem The backend owns the head-unit window (so the panel can restart it) and exits when you close it.
cd /d "%~dp0"
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":4400 .*LISTENING"') do taskkill /F /PID %%p >nul 2>&1
start "Uconnect backend" /min python backend.py --hmi
timeout /t 1 /nobreak >nul
rem Hardware panel (knobs, faceplate keys, theme/splash, reverse gear) in the default browser.
start "" http://127.0.0.1:4401/
