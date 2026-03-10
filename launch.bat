@echo off
chcp 65001 >nul
echo ============================================
echo  Voice Assistant Launcher
echo ============================================
echo.

REM Check for API key
if "%KIMI_API_KEY%"=="" (
    echo ❌ KIMI_API_KEY not set!
    echo.
    echo Please set your API key first:
    echo   set KIMI_API_KEY=your_key_here
    echo.
    echo Or get one from: https://platform.moonshot.cn/
    pause
    exit /b 1
)

echo Choose mode:
echo   [1] Auto mode - speak and pause to stop (default)
echo   [2] Key mode - press Enter to start/stop recording
echo   [3] Text mode - type your messages (for testing)
echo.
set /p choice="Enter choice (1-3): "

if "%choice%"=="2" (
    echo.
    echo Starting in KEY mode...
    python voice_assistant_kimi.py --key
) else if "%choice%"=="3" (
    echo.
    echo Starting in TEXT mode...
    python voice_assistant_kimi.py --text
) else (
    echo.
    echo Starting in AUTO mode...
    python voice_assistant_kimi.py
)

pause
