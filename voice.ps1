#!/usr/bin/env pwsh
# Voice Assistant Quick Launcher
# Usage: voice

# Set environment variables
$env:ANTHROPIC_AUTH_TOKEN = "sk-sp-your API KEY"
$env:ANTHROPIC_BASE_URL = "https://coding.dashscope.aliyuncs.com/apps/anthropic"
$env:ANTHROPIC_MODEL = "kimi-k2.5"

# Change to voice-assistant directory
Set-Location -Path "C:\Users\Win10\voice-assistant"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Voice Assistant Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is available
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Python not found. Please install Python first." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting Voice Assistant..." -ForegroundColor Yellow
Write-Host ""

# Launch voice assistant
python voice_assistant_kimi.py --anthropic
