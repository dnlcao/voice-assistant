# 更新日志 (CHANGELOG)

## 2024-03-09 更新

### 修复问题

1. **Windows 编码问题** ✅
   - 添加 `safe_print()` 函数处理 `UnicodeEncodeError`
   - 所有中文输出现在自动转为 ASCII，避免编码崩溃

2. **API URL 格式** ✅
   - 修复 Coding Plan URL 末尾 `/v1` 导致 404 错误
   - 正确格式: `https://coding.dashscope.aliyuncs.com/apps/anthropic` (无 `/v1`)

3. **英文语音识别** ✅
   - 添加 `--en` / `--english` 参数支持英文 Vosk 模型
   - 添加 `--model PATH` 参数指定自定义模型路径
   - 中文模型和英文模型可切换使用

4. **下载脚本编码** ✅
   - 修复 `download_vosk_model.py` 中的 emoji 导致的编码错误
   - 替换为 ASCII 字符

### 新增功能

1. **双语支持**
   - 中文语音识别: `python voice_assistant_kimi.py --key --anthropic`
   - 英文语音识别: `python voice_assistant_kimi.py --key --anthropic --en`

2. **启动脚本**
   - `start_cn.ps1` - 中文模式一键启动
   - `start_en.ps1` - 英文模式一键启动

3. **改进的命令行选项**
   ```
   --key, -k       : 按键触发模式 (按 Enter 开始/停止录音)
   --text, -t      : 文本输入模式 (打字代替语音)
   --en, --english : 使用英文 Vosk 模型
   --anthropic     : 强制使用 Anthropic API
   --kimi          : 强制使用 Kimi API
   --model PATH    : 指定自定义模型路径
   ```

### 测试状态

| 功能 | 中文 | 英文 |
|------|------|------|
| 语音识别 | ✅ 正常 | ✅ 正常 |
| API 连接 | ✅ 正常 | ✅ 正常 |
| AI 回复 | ✅ 正常 | ✅ 正常 |
| TTS 播放 | ✅ 正常 | ✅ 正常 |
| 按键录音 | ✅ 正常 | ✅ 正常 |

### 已知限制

1. **环境变量**: `[Environment]::SetEnvironmentVariable` 设置的永久变量在当前窗口不生效，需要:
   - 关闭 PowerShell 重新打开，或
   - 使用 `$env:` 临时设置，或
   - 使用提供的 `start_*.ps1` 启动脚本

2. **模型切换**: 需要手动加 `--en` 参数切换英文模型

### 使用建议

**推荐启动方式:**
```powershell
# 中文模式
.\start_cn.ps1

# 英文模式
.\start_en.ps1

# 或者手动
$env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"
python voice_assistant_kimi.py --key --anthropic
```

### 文件更新

- `voice_assistant_kimi.py` - 主程序 (添加 safe_print, --en 参数, 语言选择)
- `download_vosk_model.py` - 修复编码问题
- `start_cn.ps1` / `start_en.ps1` - 新增启动脚本
- `README.md` - 更新文档
- `CHANGELOG.md` - 本文件

---

## 2024-03-07 初始版本

- 基础语音助手功能
- Vosk 离线语音识别
- Kimi API 支持
- 基础 TTS
