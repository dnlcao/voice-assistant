# Alternative download method using PowerShell
$url = "https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip"
$output = "vosk-model-small-cn-0.22.zip"

Write-Host "Downloading Vosk Chinese model..." -ForegroundColor Green
Write-Host "URL: $url"
Write-Host ""

try {
    $ProgressPreference = 'Continue'
    Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing

    if (Test-Path $output) {
        $size = (Get-Item $output).Length / 1MB
        Write-Host ""
        Write-Host "Downloaded: $([math]::Round($size, 2)) MB" -ForegroundColor Green

        # Extract
        Write-Host "Extracting..."
        Expand-Archive -Path $output -DestinationPath "." -Force

        # Cleanup
        Remove-Item $output
        Write-Host "✅ Done! Model extracted to: vosk-model-small-cn-0.22" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

pause
