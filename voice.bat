@echo off
chcp 65001 >nul
echo ========================================
echo   Voice Assistant Launcher
echo ========================================
echo.

REM Set environment variables
set "ANTHROPIC_AUTH_TOKEN=YOUR API KEY"
set "ANTHROPIC_BASE_URL=https://coding.dashscope.aliyuncs.com/apps/anthropic"
set "ANTHROPIC_MODEL=kimi-k2.5"

REM Change to voice-assistant directory
cd /d "C:\Users\Win10\voice-assistant"

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python first.
    pause
    exit /b 1
)

REM Launch voice assistant
echo Starting Voice Assistant...
echo.
python voice_assistant_kimi.py --anthropic

REM Pause before exit
echo.
pause
