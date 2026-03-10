# Recreate shortcut with English name
$voiceDir = "C:\Users\Win10\voice-assistant"
$batPath = "$voiceDir\语音助手.bat"

# Create Desktop shortcut with English name
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "VoiceAssistant.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $batPath
$Shortcut.WorkingDirectory = $voiceDir
$Shortcut.IconLocation = "%SystemRoot%\System32\Shell32.dll,13"
$Shortcut.Description = "Voice Assistant (Coding Plan)"
$Shortcut.Save()

Write-Host "Created desktop shortcut: VoiceAssistant.lnk" -ForegroundColor Green
Write-Host "You can rename it to '语音助手' after creation" -ForegroundColor Yellow

pause
