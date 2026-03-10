# Voice Assistant Launcher for Kimi
$env:KIMI_API_KEY = Read-Host "Enter your Kimi API Key"

if ([string]::IsNullOrWhiteSpace($env:KIMI_API_KEY)) {
    Write-Host "❌ API Key cannot be empty!" -ForegroundColor Red
    exit 1
}

Write-Host "🎙️ Starting Voice Assistant with Kimi..." -ForegroundColor Green
Write-Host "Say 'exit' or '再见' to stop" -ForegroundColor Yellow
Write-Host ""

cd C:\Users\Win10\voice-assistant
python voice_assistant_kimi.py

Write-Host ""
Write-Host "Voice Assistant stopped." -ForegroundColor Cyan
pause
