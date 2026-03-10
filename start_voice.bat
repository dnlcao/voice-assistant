@echo off
echo ==========================================
echo    Voice Assistant with Claude
echo ==========================================
echo.

cd /d "%~dp0"

REM 检查虚拟环境
if not exist "venv\Scripts\activate.bat" (
    echo ERROR: Virtual environment not found!
    echo Please run setup_venv.bat first.
    pause
    exit /b 1
)

REM 激活虚拟环境
call venv\Scripts\activate.bat

REM 检查 API Key
if "%ANTHROPIC_API_KEY%"=="" (
    echo.
    echo WARNING: ANTHROPIC_API_KEY not set!
    echo.
    echo Please set your API key:
    echo   set ANTHROPIC_API_KEY=your_key_here
    echo.
    echo Get your API key from: https://console.anthropic.com/
    echo.
    set /p apikey="Enter your API key (or press Enter to exit): "
    if "!apikey!"=="" exit /b 1
    set ANTHROPIC_API_KEY=!apikey!
)

echo.
echo Starting Voice Assistant...
echo.
echo Commands:
echo   - Speak to talk with Claude
echo   - Say 'exit' or 'quit' to stop
echo   - Press Ctrl+C to interrupt
echo.
echo ==========================================
echo.

python voice_assistant.py

if errorlevel 1 (
    echo.
    echo ERROR: Voice assistant failed to start
    pause
)
