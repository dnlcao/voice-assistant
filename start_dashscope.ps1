# 语音助手启动脚本 (阿里云 DashScope)
# 支持通义千问和 Claude 模型

# 设置 API 配置
$env:ANTHROPIC_AUTH_TOKEN = [Environment]::GetEnvironmentVariable("DASHSCOPE_API_KEY", "User")
$env:ANTHROPIC_BASE_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1"

# 切换到脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# 检查 API Key
if (-not $env:ANTHROPIC_AUTH_TOKEN) {
    Write-Host "错误: 未设置 DASHSCOPE_API_KEY" -ForegroundColor Red
    Write-Host "请先运行: .\setup_dashscope.ps1"
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  语音助手 - 阿里云 DashScope 模式" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "API: $($env:ANTHROPIC_BASE_URL)"
Write-Host "Key: $($env:ANTHROPIC_AUTH_TOKEN.Substring(0, 20))..."
Write-Host ""

# 选择模型模式
Write-Host "请选择模型:"
Write-Host "  1. 通义千问 (qwen-plus) - 推荐中文"
Write-Host "  2. 通义千问 (qwen-turbo) - 快速"
Write-Host "  3. 通义千问 (qwen-max) - 最强"
Write-Host "  4. Claude 3.5 Sonnet"
Write-Host ""

$choice = Read-Host "请输入选项 (1-4, 默认 1)"

switch ($choice) {
    "2" { $env:ANTHROPIC_MODEL = "qwen-turbo" }
    "3" { $env:ANTHROPIC_MODEL = "qwen-max" }
    "4" { $env:ANTHROPIC_MODEL = "claude-3-5-sonnet-20241022" }
    default { $env:ANTHROPIC_MODEL = "qwen-plus" }
}

Write-Host ""
Write-Host "使用模型: $($env:ANTHROPIC_MODEL)" -ForegroundColor Green
Write-Host ""

# 启动语音助手
python voice_assistant_kimi.py --anthropic

Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
