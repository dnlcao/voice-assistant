@echo off
echo ==========================================
echo  Launching Voice Assistant with Kimi
echo ==========================================
echo.

cd /d "C:\Users\Win10\voice-assistant"

REM 检查 API Key
if "%KIMI_API_KEY%"=="" (
    echo ❌ Error: KIMI_API_KEY not set!
    echo.
    echo Please run this command first:
    echo    set KIMI_API_KEY=your_api_key_here
    echo.
    pause
    exit /b 1
)

echo ✅ API Key found
echo 🎙️  Starting Voice Assistant...
echo    Say 'exit' or '再见' to stop
echo.

python voice_assistant_kimi.py

echo.
echo Voice Assistant stopped.
pause
