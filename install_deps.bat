@echo off
echo ==========================================
echo  Installing Voice Assistant Dependencies
echo ==========================================
echo.

echo [1/4] Installing speechrecognition...
python -m pip install speechrecognition
echo.

echo [2/4] Installing anthropic...
python -m pip install anthropic
echo.

echo [3/4] Installing pyttsx3...
python -m pip install pyttsx3
echo.

echo [4/4] Installing pyaudio (this may take a while)...
python -m pip install pyaudio
echo.

echo ==========================================
echo  Installation Complete!
echo ==========================================
echo.
echo Press any key to test the installation...
pause > nul

echo.
echo Testing imports...
python -c "import speech_recognition; print('speech_recognition: OK')"
python -c "import anthropic; print('anthropic: OK')"
python -c "import pyttsx3; print('pyttsx3: OK')"
python -c "import pyaudio; print('pyaudio: OK')"

echo.
echo All packages installed successfully!
echo.
pause
