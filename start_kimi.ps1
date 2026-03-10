# Voice Assistant Launcher (Kimi API)
# Kimi (Moonshot AI) - Recommended for Chinese

# Check Kimi API Key
$kimiKey = $env:KIMI_API_KEY
if (-not $kimiKey) {
    $kimiKey = [Environment]::GetEnvironmentVariable("KIMI_API_KEY", "User")
}

if (-not $kimiKey) {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  Error: KIMI_API_KEY not found" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Get API Key from: https://platform.moonshot.cn/console/api-keys"
    Write-Host ""
    Write-Host "Set temporarily:" -ForegroundColor Yellow
    Write-Host '  $env:KIMI_API_KEY="sk-sp-xxxxxx"'
    Write-Host ""
    Write-Host "Set permanently:" -ForegroundColor Yellow
    Write-Host '  [Environment]::SetEnvironmentVariable("KIMI_API_KEY", "sk-sp-xxxxxx", "User")'
    Write-Host ""
    exit 1
}

# Set for current session
$env:KIMI_API_KEY = $kimiKey

# Change to script directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Voice Assistant - Kimi (Moonshot AI)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "API: https://api.moonshot.cn/v1"
Write-Host "Model: kimi-k2.5"
Write-Host "Key: $($kimiKey.Substring(0, 20))..."
Write-Host ""

# Test API connection
Write-Host "Testing API connection..." -ForegroundColor Cyan
$testResult = python test_kimi_api.py 2>&1

if ($testResult -match "OK") {
    Write-Host "OK - API connection successful" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "FAIL - API connection failed" -ForegroundColor Red
    Write-Host $testResult -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible causes:" -ForegroundColor Yellow
    Write-Host "  1. API Key is incorrect or expired"
    Write-Host "  2. Key is disabled"
    Write-Host "  3. Network connection issue"
    Write-Host ""
    Write-Host "Check: https://platform.moonshot.cn/console/api-keys"
    Write-Host ""
    exit 1
}

# Start voice assistant
Write-Host "Starting voice assistant..." -ForegroundColor Cyan
Write-Host ""
python voice_assistant_kimi.py --kimi

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
