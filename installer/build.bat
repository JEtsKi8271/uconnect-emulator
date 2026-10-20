@echo off
rem Builds UconnectEmulatorSetup.exe (one file, console) from setup_uconnect.py. Needs: pip install pyinstaller
cd /d "%~dp0"
python -m PyInstaller --onefile --console --name UconnectEmulatorSetup --distpath dist --workpath build --specpath build setup_uconnect.py
