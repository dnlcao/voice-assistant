@echo off
echo ==========================================
echo  Voice Assistant - Virtual Environment
echo ==========================================
echo.

cd /d "%~dp0"

REM 检查 Python
echo [1/5] Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found! Please install Python first.
    pause
    exit /b 1
)
echo     Python found!
echo.

REM 创建虚拟环境
echo [2/5] Creating virtual environment...
if exist "venv" (
    echo     venv already exists, skipping...
) else (
    python -m venv venv
    echo     Virtual environment created!
)
echo.

REM 激活虚拟环境并安装依赖
echo [3/5] Activating virtual environment...
call venv\Scripts\activate.bat
echo     Activated!
echo.

echo [4/5] Upgrading pip...
python -m pip install --upgrade pip
echo.

echo [5/5] Installing dependencies...
echo     - Installing speechrecognition...
python -m pip install speechrecognition

echo     - Installing anthropic...
python -m pip install anthropic

echo     - Installing pyttsx3...
python -m pip install pyttsx3

echo     - Installing pyaudio (this may take a moment)...
python -m pip install pyaudio
if errorlevel 1 (
    echo     WARNING: pyaudio installation failed.
    echo     Downloading pre-built wheel...
    python -m pip install pipwin
    pipwin install pyaudio
)
echo.

echo ==========================================
echo  Installation Complete!
echo ==========================================
echo.
echo Testing installation...
python -c "import speech_recognition; print('  [OK] speech_recognition')"
python -c "import anthropic; print('  [OK] anthropic')"
python -c "import pyttsx3; print('  [OK] pyttsx3')"
python -c "import pyaudio; print('  [OK] pyaudio')"
echo.

echo You can now run the voice assistant with:
echo   start_voice.bat
echo.
pause
