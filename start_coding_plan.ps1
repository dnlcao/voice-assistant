# 语音助手启动脚本 (Coding Plan)
# 阿里云百炼 Coding Plan - 最新配置
# 文档: https://help.aliyun.com/zh/model-studio/coding-plan

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  语音助手 - Coding Plan 模式" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查环境变量
$apiKey = $env:ANTHROPIC_AUTH_TOKEN
$baseUrl = $env:ANTHROPIC_BASE_URL
$model = $env:ANTHROPIC_MODEL

# 如果未设置，尝试从用户环境变量获取
if (-not $apiKey) {
    $apiKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "User")
}
if (-not $baseUrl) {
    $baseUrl = [Environment]::GetEnvironmentVariable("ANTHROPIC_BASE_URL", "User")
}
if (-not $model) {
    $model = [Environment]::GetEnvironmentVariable("ANTHROPIC_MODEL", "User")
}

# 设置默认值
if (-not $baseUrl) {
    $baseUrl = "https://coding.dashscope.aliyuncs.com/apps/anthropic"
}
if (-not $model) {
    $model = "qwen3.5-plus"
}

# 检查 API Key
if (-not $apiKey) {
    Write-Host "[错误] 未找到 ANTHROPIC_AUTH_TOKEN" -ForegroundColor Red
    Write-Host ""
    Write-Host "请从阿里云百炼控制台获取 Coding Plan API Key:" -ForegroundColor Yellow
    Write-Host "  https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan" -ForegroundColor Blue
    Write-Host ""
    Write-Host "设置环境变量:" -ForegroundColor Yellow
    Write-Host '  [Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "sk-xxxx", "User")' -ForegroundColor Gray
    Write-Host '  [Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://coding.dashscope.aliyuncs.com/apps/anthropic", "User")' -ForegroundColor Gray
    Write-Host '  [Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "qwen3.5-plus", "User")' -ForegroundColor Gray
    Write-Host ""
    exit 1
}

# 设置当前会话环境变量
$env:ANTHROPIC_AUTH_TOKEN = $apiKey
$env:ANTHROPIC_BASE_URL = $baseUrl
$env:ANTHROPIC_MODEL = $model
# 默认使用 OpenAI SDK（Coding Plan 兼容更好）
if (-not $env:USE_ANTHROPIC_SDK) {
    $env:USE_ANTHROPIC_SDK = "0"
}

# 切换到脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "配置信息:" -ForegroundColor Green
Write-Host "  Base URL: $baseUrl"
Write-Host "  Model: $model"
Write-Host "  API Key: $($apiKey.Substring(0, [Math]::Min(20, $apiKey.Length)))..."
Write-Host "  SDK: $(if ($env:USE_ANTHROPIC_SDK -eq '1') { 'Anthropic SDK' } else { 'OpenAI SDK' })"
Write-Host ""

# 测试 API 连接
Write-Host "测试 Coding Plan API 连接..." -ForegroundColor Cyan

$testScript = @"
import os
from openai import OpenAI

api_key = os.environ.get('ANTHROPIC_AUTH_TOKEN')
base_url = os.environ.get('ANTHROPIC_BASE_URL')
model = os.environ.get('ANTHROPIC_MODEL', 'qwen3.5-plus')

# Convert to OpenAI-compatible URL for testing
if '/apps/anthropic' in base_url:
    base_url = base_url.replace('/apps/anthropic', '/v1')

print(f'Connecting to: {base_url}')
print(f'Model: {model}')

try:
    client = OpenAI(api_key=api_key, base_url=base_url)
    response = client.chat.completions.create(
        model=model,
        messages=[{'role': 'user', 'content': 'Hello, reply with OK'}],
        max_tokens=10
    )
    print(f'OK: API connection successful')
    print(f'Response: {response.choices[0].message.content}')
except Exception as e:
    print(f'FAIL: {e}')
"@

$testResult = python -c $testScript 2>&1

if ($testResult -match "OK") {
    Write-Host "OK - API 连接成功" -ForegroundColor Green
    Write-Host $testResult -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "FAIL - API 连接失败" -ForegroundColor Red
    Write-Host $testResult -ForegroundColor Red
    Write-Host ""
    Write-Host "可能原因:" -ForegroundColor Yellow
    Write-Host "  1. API Key 不正确或已过期"
    Write-Host "  2. 模型名称不正确"
    Write-Host "  3. 网络连接问题"
    Write-Host ""
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "  - API Key: https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan"
    Write-Host "  - 模型列表: https://help.aliyun.com/zh/model-studio/coding-plan"
    Write-Host ""
    exit 1
}

# 选择模型（可选）
Write-Host "当前模型: $model" -ForegroundColor Green
Write-Host ""
Write-Host "支持的模型:" -ForegroundColor Cyan
Write-Host "  1. qwen3.5-plus (默认)"
Write-Host "  2. qwen3-coder-next"
Write-Host "  3. qwen3-coder-plus"
Write-Host "  4. 自定义输入"
Write-Host ""

$choice = Read-Host "切换模型? (1-4 或直接按Enter保持当前)"

switch ($choice) {
    "1" { $env:ANTHROPIC_MODEL = "qwen3.5-plus" }
    "2" { $env:ANTHROPIC_MODEL = "qwen3-coder-next" }
    "3" { $env:ANTHROPIC_MODEL = "qwen3-coder-plus" }
    "4" {
        $customModel = Read-Host "请输入模型名称"
        if ($customModel) {
            $env:ANTHROPIC_MODEL = $customModel
        }
    }
}

if ($env:ANTHROPIC_MODEL -ne $model) {
    Write-Host "已切换到模型: $($env:ANTHROPIC_MODEL)" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  启动语音助手..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "提示:" -ForegroundColor Yellow
Write-Host "  - 首次使用请先运行: python download_vosk_model.py cn"
Write-Host "  - 说'退出'或'再见'结束对话"
Write-Host "  - 按Ctrl+C中断"
Write-Host ""

# 启动语音助手
python voice_assistant_kimi.py --anthropic

Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
