@echo off
chcp 65001 >nul
echo ============================================
echo  Vosk Model Downloader for Voice Assistant
echo ============================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python not found! Please install Python first.
    pause
    exit /b 1
)

REM Check if model already exists
if exist "vosk-model-small-cn-0.22" (
    echo ✅ Chinese model already exists!
    goto :run
)

if exist "vosk-model-small-en-us-0.15" (
    echo ✅ English model already exists!
    goto :run
)

echo.
echo Which model do you want to download?
echo   [1] Chinese Small (39MB) - Recommended for Chinese users
echo   [2] English US Small (40MB)
echo.
set /p choice="Enter choice (1 or 2): "

if "%choice%"=="1" (
    echo.
    echo 📦 Downloading Chinese model...
    python download_vosk_model.py cn
) else if "%choice%"=="2" (
    echo.
    echo 📦 Downloading English model...
    python download_vosk_model.py en
) else (
    echo ❌ Invalid choice
    pause
    exit /b 1
)

:run
echo.
echo ============================================
echo  Starting Voice Assistant...
echo ============================================
echo.

REM Check for API key
if "%KIMI_API_KEY%"=="" (
    echo ⚠️  Warning: KIMI_API_KEY not set!
    echo.
    echo Please set your API key first:
    echo   set KIMI_API_KEY=your_key_here
    echo.
    echo Get your API key from: https://platform.moonshot.cn/
    echo.
    pause
    exit /b 1
)

python voice_assistant_kimi.py
pause
