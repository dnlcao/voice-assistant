# Voice Assistant Quick Launcher Installer
# Run this to add shortcuts to your system

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Voice Assistant Shortcut Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$voiceDir = "C:\Users\Win10\voice-assistant"

# 1. Create Desktop shortcut
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "语音助手.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoExit -Command `"cd '$voiceDir'; python voice_assistant_kimi.py --anthropic`""
$Shortcut.WorkingDirectory = $voiceDir
$Shortcut.IconLocation = "%SystemRoot%\System32\Shell32.dll,13"
$Shortcut.Description = "Launch Voice Assistant (Coding Plan)"
$Shortcut.Save()

Write-Host "Created desktop shortcut: 语音助手.lnk" -ForegroundColor Green

# 2. Create Start Menu shortcut
$startMenuPath = [Environment]::GetFolderPath("StartMenu")
$startShortcutPath = Join-Path $startMenuPath "语音助手.lnk"

$StartShortcut = $WshShell.CreateShortcut($startShortcutPath)
$StartShortcut.TargetPath = "powershell.exe"
$StartShortcut.Arguments = "-NoExit -Command `"cd '$voiceDir'; python voice_assistant_kimi.py --anthropic`""
$StartShortcut.WorkingDirectory = $voiceDir
$StartShortcut.IconLocation = "%SystemRoot%\System32\Shell32.dll,13"
$StartShortcut.Description = "Launch Voice Assistant (Coding Plan)"
$StartShortcut.Save()

Write-Host "Created Start Menu shortcut" -ForegroundColor Green

# 3. Add PowerShell function to profile
$profileLine = 'function voice { $env:ANTHROPIC_AUTH_TOKEN="YOUR API KEY"; $env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"; $env:ANTHROPIC_MODEL="kimi-k2.5"; cd "C:\Users\Win10\voice-assistant"; python voice_assistant_kimi.py --anthropic }'

if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force | Out-Null
    Write-Host "Created PowerShell profile" -ForegroundColor Green
}

if (-not (Select-String -Path $PROFILE -Pattern "function voice" -Quiet)) {
    Add-Content -Path $PROFILE -Value "`n$profileLine"
    Write-Host "Added 'voice' command to PowerShell profile" -ForegroundColor Green
} else {
    Write-Host "'voice' command already exists in profile" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "You can now:" -ForegroundColor Cyan
Write-Host "  1. Double-click '语音助手.lnk' on Desktop" -ForegroundColor White
Write-Host "  2. Search '语音助手' in Start Menu" -ForegroundColor White
Write-Host "  3. Type 'voice' in PowerShell (after restart)" -ForegroundColor White
Write-Host ""

pause
