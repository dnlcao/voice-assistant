# Coding Plan API 配置脚本
# 阿里云百炼 Coding Plan - 配置3项必需参数
# 文档: https://help.aliyun.com/zh/model-studio/coding-plan

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Coding Plan API 配置" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Coding Plan 是阿里云百炼推出的 Claude Code 兼容服务" -ForegroundColor Gray
Write-Host ""

# 检查现有配置
$existingKey = [Environment]::GetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "User")
$existingUrl = [Environment]::GetEnvironmentVariable("ANTHROPIC_BASE_URL", "User")
$existingModel = [Environment]::GetEnvironmentVariable("ANTHROPIC_MODEL", "User")

if ($existingKey) {
    Write-Host "发现现有配置:" -ForegroundColor Yellow
    Write-Host "  ANTHROPIC_AUTH_TOKEN: $($existingKey.Substring(0, [Math]::Min(20, $existingKey.Length)))..."
    if ($existingUrl) {
        Write-Host "  ANTHROPIC_BASE_URL: $existingUrl"
    }
    if ($existingModel) {
        Write-Host "  ANTHROPIC_MODEL: $existingModel"
    }
    Write-Host ""
    $useExisting = Read-Host "是否更新配置? (y/N)"
    if ($useExisting -ne "y" -and $useExisting -ne "Y") {
        Write-Host "保持现有配置，退出。" -ForegroundColor Green
        exit 0
    }
}

Write-Host "请从阿里云百炼控制台获取 API Key:" -ForegroundColor Yellow
Write-Host "  https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan" -ForegroundColor Blue
Write-Host ""
Write-Host "API Key 格式: sk-xxxxxx" -ForegroundColor Gray
Write-Host ""

# 输入 API Key
$apiKey = Read-Host "请输入您的 Coding Plan API Key"

if (-not $apiKey) {
    Write-Host "[错误] 未提供 API Key" -ForegroundColor Red
    exit 1
}

# 验证 Key 格式
if (-not ($apiKey.StartsWith("sk-") -or $apiKey.StartsWith("sk-sp-"))) {
    Write-Host "[警告] Key 格式可能不正确" -ForegroundColor Yellow
    $continue = Read-Host "是否继续? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

# 输入 Base URL（使用默认值）
Write-Host ""
Write-Host "说明: Coding Plan 提供两个端点" -ForegroundColor Gray
Write-Host "  - Anthropic 兼容: https://coding.dashscope.aliyuncs.com/apps/anthropic" -ForegroundColor Gray
Write-Host "  - OpenAI 兼容: https://coding.dashscope.aliyuncs.com/v1" -ForegroundColor Gray
Write-Host ""
$baseUrl = Read-Host "请输入 Base URL (直接按Enter使用默认值)"

if (-not $baseUrl) {
    # 使用 OpenAI 兼容端点（因为代码使用 OpenAI SDK）
    $baseUrl = "https://coding.dashscope.aliyuncs.com/v1"
}

# 选择模型
Write-Host ""
Write-Host "请选择模型:" -ForegroundColor Cyan
Write-Host "  1. qwen3.5-plus (默认推荐)"
Write-Host "  2. qwen3-coder-next"
Write-Host "  3. qwen3-coder-plus"
Write-Host "  4. 其他 (自定义输入)"
Write-Host ""

$modelChoice = Read-Host "请选择 (1-4, 默认 1)"

switch ($modelChoice) {
    "2" { $model = "qwen3-coder-next" }
    "3" { $model = "qwen3-coder-plus" }
    "4" { $model = Read-Host "请输入模型名称" }
    default { $model = "qwen3.5-plus" }
}

if (-not $model) {
    $model = "qwen3.5-plus"
}

Write-Host ""
Write-Host "配置确认:" -ForegroundColor Green
Write-Host "  ANTHROPIC_AUTH_TOKEN: $($apiKey.Substring(0, [Math]::Min(20, $apiKey.Length)))..."
Write-Host "  ANTHROPIC_BASE_URL: $baseUrl"
Write-Host "  ANTHROPIC_MODEL: $model"
Write-Host ""

$confirm = Read-Host "确认保存? (Y/n)"
if ($confirm -eq "n" -or $confirm -eq "N") {
    Write-Host "已取消，退出。" -ForegroundColor Yellow
    exit 0
}

# 设置用户环境变量（永久）
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $apiKey, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $baseUrl, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", $model, "User")
# 默认使用 OpenAI SDK（Coding Plan 兼容更好）
[Environment]::SetEnvironmentVariable("USE_ANTHROPIC_SDK", "0", "User")

# 设置当前会话环境变量
$env:ANTHROPIC_AUTH_TOKEN = $apiKey
$env:ANTHROPIC_BASE_URL = $baseUrl
$env:ANTHROPIC_MODEL = $model
$env:USE_ANTHROPIC_SDK = "0"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  配置已保存!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "已设置的环境变量:" -ForegroundColor Cyan
Write-Host "  ✓ ANTHROPIC_AUTH_TOKEN"
Write-Host "  ✓ ANTHROPIC_BASE_URL = $baseUrl"
Write-Host "  ✓ ANTHROPIC_MODEL = $model"
Write-Host "  ✓ USE_ANTHROPIC_SDK = 0 (使用 OpenAI SDK，推荐)"
Write-Host ""

# 测试连接
Write-Host "测试 API 连接..." -ForegroundColor Cyan
Write-Host ""

$testScript = @"
import os
from openai import OpenAI

api_key = os.environ.get('ANTHROPIC_AUTH_TOKEN')
base_url = os.environ.get('ANTHROPIC_BASE_URL')
model = os.environ.get('ANTHROPIC_MODEL')

print(f'API Key: {api_key[:15]}...')
print(f'Base URL: {base_url}')
print(f'Model: {model}')
print('')

try:
    client = OpenAI(api_key=api_key, base_url=base_url)
    response = client.chat.completions.create(
        model=model,
        messages=[{'role': 'user', 'content': 'Hello, reply with OK'}],
        max_tokens=10
    )
    print(f'✓ API 连接成功!')
    print(f'  Response: {response.choices[0].message.content}')
    exit(0)
except Exception as e:
    print(f'✗ API 连接失败: {e}')
    exit(1)
"@

python -c $testScript

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  配置成功!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "启动语音助手:" -ForegroundColor Cyan
    Write-Host "  .\start_coding_plan.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "或手动运行:" -ForegroundColor Cyan
    Write-Host "  python voice_assistant_kimi.py --anthropic" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[警告] API 连接测试失败" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "  1. API Key 是否正确"
    Write-Host "  2. 模型名称是否正确"
    Write-Host "  3. 网络连接是否正常"
    Write-Host ""
    Write-Host "文档: https://help.aliyun.com/zh/model-studio/coding-plan"
    Write-Host ""
}
