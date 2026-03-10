# PowerShell Profile Extension for Voice Assistant
# Add this to your PowerShell profile: $PROFILE

function voice {
    <#
    .SYNOPSIS
        Launch the voice assistant
    .DESCRIPTION
        Starts the voice assistant with Coding Plan API in a new window
    #>
    $env:ANTHROPIC_AUTH_TOKEN = "sk-sp-295f28f67311443c8d400b9e0fdfda01"
    $env:ANTHROPIC_BASE_URL = "https://coding.dashscope.aliyuncs.com/apps/anthropic"
    $env:ANTHROPIC_MODEL = "kimi-k2.5"

    $voicePath = "C:\Users\Win10\voice-assistant"

    if (-not (Test-Path $voicePath)) {
        Write-Host "[ERROR] Voice assistant not found at: $voicePath" -ForegroundColor Red
        return
    }

    Write-Host "🎙️ 启动语音助手..." -ForegroundColor Cyan
    Write-Host "   模型: kimi-k2.5" -ForegroundColor Gray
    Write-Host "   API: Coding Plan (阿里云)" -ForegroundColor Gray
    Write-Host ""

    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-Command",
        "cd '$voicePath'; python voice_assistant_kimi.py --anthropic"
    ) -WindowStyle Normal
}

# Export the function
Export-ModuleMember -Function voice
