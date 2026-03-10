@echo off
echo ==========================================
echo  Voice Assistant Dependencies Installer
echo ==========================================
echo.

echo Python version:
python --version
echo.

echo [1/4] Installing speechrecognition...
python -m pip install speechrecognition
echo.

echo [2/4] Installing anthropic...
python -m pip install anthropic
echo.

echo [3/4] Installing pyttsx3...
python -m pip install pyttsx3
echo.

echo [4/4] Installing pyaudio...
echo Trying pre-built wheel first...
python -m pip install pyaudio

if errorlevel 1 (
    echo.
    echo Pre-built wheel failed. Trying to build from source...
    python -m pip install --upgrade setuptools wheel
    python -m pip install --no-binary :all: pyaudio
)

echo.
echo ==========================================
echo  Installation Complete!
echo ==========================================
echo.
echo Testing imports...
python -c "import speech_recognition; print('[OK] speech_recognition')"
python -c "import anthropic; print('[OK] anthropic')"
python -c "import pyttsx3; print('[OK] pyttsx3')"
python -c "import pyaudio; print('[OK] pyaudio')"

echo.
echo Done!
pause
