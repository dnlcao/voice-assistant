# 阿里云 DashScope API 配置脚本
# 在 PowerShell 中运行: .\setup_dashscope.ps1

Write-Host "========================================"
Write-Host "阿里云 DashScope API 配置"
Write-Host "========================================"
Write-Host ""

# 检查是否已有 DashScope Key
$existingKey = [Environment]::GetEnvironmentVariable("DASHSCOPE_API_KEY", "User")
if (-not $existingKey) {
    $existingKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "User")
}

if ($existingKey -and $existingKey.StartsWith("sk-") -and -not $existingKey.StartsWith("sk-sp-")) {
    Write-Host "发现现有的 DashScope Key: $($existingKey.Substring(0, 20))..."
    $useExisting = Read-Host "是否使用此 Key? (Y/n)"
    if ($useExisting -ne "n" -and $useExisting -ne "N") {
        $dashscopeKey = $existingKey
    }
}

if (-not $dashscopeKey) {
    Write-Host "请从 https://dashscope.aliyun.com/ 获取 API Key"
    Write-Host "Key 格式: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    Write-Host ""
    $dashscopeKey = Read-Host "请输入您的 DashScope API Key"
}

if (-not $dashscopeKey) {
    Write-Host "错误: 未提供 API Key" -ForegroundColor Red
    exit 1
}

# 验证 Key 格式
if (-not $dashscopeKey.StartsWith("sk-")) {
    Write-Host "警告: Key 格式不正确，DashScope Key 应以 'sk-' 开头" -ForegroundColor Yellow
    $continue = Read-Host "是否继续? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

# 设置环境变量（永久）
[Environment]::SetEnvironmentVariable("DASHSCOPE_API_KEY", $dashscopeKey, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $dashscopeKey, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1", "User")

# 设置当前会话的环境变量
$env:DASHSCOPE_API_KEY = $dashscopeKey
$env:ANTHROPIC_AUTH_TOKEN = $dashscopeKey
$env:ANTHROPIC_BASE_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1"

Write-Host ""
Write-Host "✓ 环境变量已设置:" -ForegroundColor Green
Write-Host "  DASHSCOPE_API_KEY = $($dashscopeKey.Substring(0, 20))..."
Write-Host "  ANTHROPIC_BASE_URL = https://dashscope.aliyuncs.com/compatible-mode/v1"
Write-Host ""
Write-Host "测试 API 连接..."
Write-Host ""

# 测试连接
$testScript = @"
import os
from openai import OpenAI

api_key = os.environ.get('ANTHROPIC_AUTH_TOKEN')
base_url = os.environ.get('ANTHROPIC_BASE_URL')

client = OpenAI(api_key=api_key, base_url=base_url)

# 测试支持的模型
models = ['qwen-turbo', 'qwen-plus', 'qwen-max', 'claude-3-5-sonnet-20241022']

for model in models:
    try:
        response = client.chat.completions.create(
            model=model,
            messages=[{'role': 'user', 'content': 'Hello'}],
            max_tokens=10
        )
        print(f'OK: {model} - 连接成功')
        break
    except Exception as e:
        error = str(e)
        if 'model' in error.lower():
            print(f'FAIL: {model} - 模型不可用')
        elif '401' in error or 'auth' in error.lower():
            print(f'FAIL: {model} - 认证失败，请检查 API Key')
            break
        else:
            print(f'FAIL: {model} - {error[:50]}')
"@

python -c $testScript

Write-Host ""
Write-Host "========================================"
Write-Host "配置完成!"
Write-Host "========================================"
Write-Host ""
Write-Host "启动语音助手:" -ForegroundColor Cyan
Write-Host "  .\start_dashscope.ps1"
Write-Host ""
Write-Host "或手动启动:" -ForegroundColor Cyan
Write-Host "  python voice_assistant_kimi.py --anthropic"
Write-Host ""
