# Recreate shortcuts with correct API key
$voiceDir = "C:\Users\Win10\voice-assistant"
$batPath = "$voiceDir\语音助手.bat"

# Create Desktop shortcut
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktopPath "语音助手.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $batPath
$Shortcut.WorkingDirectory = $voiceDir
$Shortcut.IconLocation = "%SystemRoot%\System32\Shell32.dll,13"
$Shortcut.Description = "Launch Voice Assistant (Coding Plan)"
$Shortcut.Save()

Write-Host "Created desktop shortcut" -ForegroundColor Green

# Create Start Menu shortcut
$startMenuPath = [Environment]::GetFolderPath("StartMenu")
$startShortcutPath = Join-Path $startMenuPath "语音助手.lnk"

$StartShortcut = $WshShell.CreateShortcut($startShortcutPath)
$StartShortcut.TargetPath = $batPath
$StartShortcut.WorkingDirectory = $voiceDir
$StartShortcut.IconLocation = "%SystemRoot%\System32\Shell32.dll,13"
$StartShortcut.Description = "Launch Voice Assistant (Coding Plan)"
$StartShortcut.Save()

Write-Host "Created Start Menu shortcut" -ForegroundColor Green

pause
