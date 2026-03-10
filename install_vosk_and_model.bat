@echo off
cd /d C:\Users\Win10\voice-assistant
echo Installing vosk...
python -m pip install vosk
echo.
echo Downloading Chinese model...
python download_vosk_model.py cn
echo.
pause
