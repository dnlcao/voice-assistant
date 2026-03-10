@echo off
echo ==========================================
echo  PyAudio Installer for Windows
echo ==========================================
echo.

python -c "import sys; v=f'{sys.version_info.major}{sys.version_info.minor}'; print(f'Python version: {v}')"
echo.
echo Downloading PyAudio for your Python version...
echo.

REM Python 3.9
python -c "import sys; exit(0 if sys.version_info[:2]==(3,9) else 1)" 2>nul
if %errorlevel%==0 (
    echo Downloading for Python 3.9 (64-bit)...
    curl -L -o pyaudio.whl "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp39-cp39-win_amd64.whl" 2>nul
    if exist pyaudio.whl goto install
)

REM Python 3.10
python -c "import sys; exit(0 if sys.version_info[:2]==(3,10) else 1)" 2>nul
if %errorlevel%==0 (
    echo Downloading for Python 3.10 (64-bit)...
    curl -L -o pyaudio.whl "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp310-cp310-win_amd64.whl" 2>nul
    if exist pyaudio.whl goto install
)

REM Python 3.11
python -c "import sys; exit(0 if sys.version_info[:2]==(3,11) else 1)" 2>nul
if %errorlevel%==0 (
    echo Downloading for Python 3.11 (64-bit)...
    curl -L -o pyaudio.whl "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp311-cp311-win_amd64.whl" 2>nul
    if exist pyaudio.whl goto install
)

REM Python 3.12
python -c "import sys; exit(0 if sys.version_info[:2]==(3,12) else 1)" 2>nul
if %errorlevel%==0 (
    echo Downloading for Python 3.12 (64-bit)...
    curl -L -o pyaudio.whl "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp312-cp312-win_amd64.whl" 2>nul
    if exist pyaudio.whl goto install
)

:install
if exist pyaudio.whl (
    echo.
    echo Installing PyAudio...
    python -m pip install pyaudio.whl
    echo.
    echo Cleaning up...
    del pyaudio.whl
    echo.
    echo PyAudio installed successfully!
) else (
    echo.
    echo ERROR: Could not download PyAudio
    echo.
    echo Please manually download from:
    echo https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio
    echo.
    echo Look for a file like: PyAudio-0.2.11-cpXX-cpXX-win_amd64.whl
    echo Where XX is your Python version (e.g., 39 for Python 3.9)
    echo.
    echo Then install with:
    echo   python -m pip install PyAudio-0.2.11-cpXX-cpXX-win_amd64.whl
)

echo.
pause
