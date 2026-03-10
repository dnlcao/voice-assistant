#!/bin/bash
# Setup script for Voice Assistant on macOS/Linux

set -e

echo "========================================="
echo " Voice Assistant Setup"
echo "========================================="
echo

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo "Please install Python 3.8+ from https://python.org"
    exit 1
fi

echo "[1/3] Python found: $(python3 --version)"

# Install system dependencies for PyAudio
echo "[2/3] Installing system dependencies..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        brew install portaudio
    else
        echo "WARNING: Homebrew not found. Please install portaudio manually."
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3-pyaudio portaudio19-dev
    elif command -v yum &> /dev/null; then
        sudo yum install -y portaudio-devel
    elif command -v pacman &> /dev/null; then
        sudo pacman -S portaudio
    fi
fi

# Install Python dependencies
echo "[3/3] Installing Python dependencies..."
pip3 install -r requirements.txt

echo
echo "========================================="
echo " Setup Complete!"
echo "========================================="
echo
echo "Next steps:"
echo "1. Copy .env.example to .env"
echo "   cp .env.example .env"
echo "2. Add your ANTHROPIC_API_KEY to .env"
echo "3. Run: python3 voice_assistant.py"
echo
