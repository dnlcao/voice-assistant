#!/usr/bin/env pwsh
# Voice Assistant Launcher
# Fixed encoding for Chinese display

# Set console to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$Host.UI.RawUI.WindowTitle = "Voice Assistant - Coding Plan"

# Set environment variables
$env:ANTHROPIC_AUTH_TOKEN = "sk-sp-295f28f67311443c8d400b9e0fdfda01"
$env:ANTHROPIC_BASE_URL = "https://coding.dashscope.aliyuncs.com/apps/anthropic"
$env:ANTHROPIC_MODEL = "kimi-k2.5"

$voiceDir = "C:\Users\Win10\voice-assistant"

Write-Output "========================================"
Write-Output "  Voice Assistant - Coding Plan"
Write-Output "========================================"
Write-Output ""
Write-Output "Model: kimi-k2.5"
Write-Output "API: Coding Plan (Aliyun)"
Write-Output ""

Set-Location $voiceDir

Write-Output "Starting..."
Write-Output ""

python voice_assistant_kimi.py --anthropic
