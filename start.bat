@echo off
echo ==========================================
echo    Voice Assistant with Claude
echo ==========================================
echo.

REM Check for API key
if "%ANTHROPIC_API_KEY%"=="" (
    echo WARNING: ANTHROPIC_API_KEY not set!
    echo.
    echo Please set your API key first:
    echo   set ANTHROPIC_API_KEY=your_key_here
    echo.
    echo Get your API key from: https://console.anthropic.com/
    echo.
    pause
    exit /b 1
)

echo Starting Voice Assistant...
echo.
echo Commands:
echo   - Speak to talk with Claude
echo   - Say 'exit' or 'quit' to stop
echo   - Press Ctrl+C to interrupt
echo.

python voice_assistant.py

if errorlevel 1 (
    echo.
    echo ERROR: Voice assistant failed to start
    echo.
    echo Make sure all dependencies are installed:
    echo   python -m pip install speechrecognition anthropic pyttsx3 pyaudio
    echo.
    pause
)
