@echo off
chcp 65001 >nul
echo ========================================
echo   Voice Assistant Launcher
echo ========================================
echo.

REM Set the correct API key
set "ANTHROPIC_AUTH_TOKEN=YOUR API KEY"
set "ANTHROPIC_BASE_URL=https://coding.dashscope.aliyuncs.com/apps/anthropic"
set "ANTHROPIC_MODEL=kimi-k2.5"

cd /d "C:\Users\Win10\voice-assistant"

echo Starting Voice Assistant...
echo.
python voice_assistant_kimi.py --anthropic

echo.
pause
