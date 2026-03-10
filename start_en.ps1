# 语音助手启动脚本 (英文)
# Voice Assistant Launcher (English)

# 设置 API 基础 URL（去掉 /v1）
$env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"

# 切换到脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# 启动语音助手（英文模式）
python voice_assistant_kimi.py --key --anthropic --en

# 暂停查看结果
Write-Host "`n按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
