@echo off
:: Set UTF-8 encoding
chcp 65001 >nul 2>&1

title Voice Assistant - Coding Plan
cd /d "C:\Users\Win10\voice-assistant"

:: Set API keys
set "ANTHROPIC_AUTH_TOKEN=sk-sp-295f28f67311443c8d400b9e0fdfda01"
set "ANTHROPIC_BASE_URL=https://coding.dashscope.aliyuncs.com/apps/anthropic"
set "ANTHROPIC_MODEL=kimi-k2.5"

echo ========================================
echo   Voice Assistant - Coding Plan
echo ========================================
echo.
echo Starting...
echo.

python voice_assistant_kimi.py --anthropic

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to start. Press any key to exit...
    pause >nul
)
