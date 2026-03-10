@echo off
echo ==========================================
echo    Voice Assistant with Kimi (Moonshot AI)
echo ==========================================
echo.

cd /d "%~dp0"

REM 检查 API Key
if "%KIMI_API_KEY%"=="" (
    echo.
    echo WARNING: KIMI_API_KEY not set!
    echo.
    echo Please set your API key first:
    echo   set KIMI_API_KEY=your_key_here
    echo   PowerShell: $env:KIMI_API_KEY="your_key_here"
    echo.
    echo Get your API key from: https://platform.moonshot.cn/
    echo.
    pause
    exit /b 1
)

echo Starting Voice Assistant with Kimi...
echo.
echo Commands:
echo   - Speak to talk with Kimi (supports Chinese)
echo   - Say 'exit', 'quit', 'goodbye' or '再见' to stop
echo   - Press Ctrl+C to interrupt
echo.
echo ==========================================
echo.

python voice_assistant_kimi.py

if errorlevel 1 (
    echo.
    echo ERROR: Voice assistant failed to start
    pause
)
