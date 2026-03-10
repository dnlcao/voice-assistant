@echo off
REM Setup script for Voice Assistant on Windows

echo =========================================
echo  Voice Assistant Setup
echo =========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8+ from https://python.org
    exit /b 1
)

echo [1/4] Python found
echo.

REM Install pipwin for PyAudio
echo [2/4] Installing pipwin (for PyAudio)...
pip install pipwin

REM Install PyAudio using pipwin
echo [3/4] Installing PyAudio...
pipwin install pyaudio

REM Install other requirements
echo [4/4] Installing other dependencies...
pip install -r requirements.txt

echo.
echo =========================================
echo  Setup Complete!
echo =========================================
echo.
echo Next steps:
echo 1. Copy .env.example to .env
echo 2. Add your ANTHROPIC_API_KEY to .env
echo 3. Run: python voice_assistant.py
echo.
pause
