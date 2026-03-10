# Voice Assistant - Complete Summary

## Overview
Voice Assistant with Coding Plan API (kimi-k2.5) - Chinese speech recognition and text-to-speech.

## Quick Launch

### Recommended Way
```powershell
# PowerShell (recommended)
powershell -ExecutionPolicy Bypass -File "C:\Users\Win10\voice-assistant\start-voice.ps1"
```

### Alternative Ways
```cmd
:: Batch file
C:\Users\Win10\voice-assistant\start-voice.bat

:: Python directly
cd C:\Users\Win10\voice-assistant
python voice_assistant_kimi.py --anthropic
```

## What Was Updated

### 1. API Configuration
- **Base URL**: `https://coding.dashscope.aliyuncs.com/apps/anthropic`
- **Model**: `kimi-k2.5`
- **SDK**: OpenAI SDK (auto-converts /apps/anthropic to /v1)

### 2. Key Fixes
- ✅ API key priority (ANTHROPIC_AUTH_TOKEN first)
- ✅ Empty string handling in `_init_coding_plan()`
- ✅ UTF-8 encoding for Chinese display
- ✅ Recording parameters optimized

### 3. New Scripts Created

| Script | Description |
|--------|-------------|
| `start-voice.ps1` | PowerShell launcher with UTF-8 encoding |
| `start-voice.bat` | Batch file launcher |
| `setup_coding_plan.ps1` | Configure Coding Plan settings |
| `debug_api.py` | Debug API connection |
| `test_coding_plan_api.py` | Test Coding Plan API |
| `test_init.py` | Test VoiceAssistant initialization |
| `install-shortcuts.ps1` | Create desktop shortcuts |

### 4. Configuration Files

**Claude Code Settings** (`C:\Users\Win10\.claude\settings.json`):
```json
{
    "env": {
        "ANTHROPIC_AUTH_TOKEN": "sk-sp-295f28f67311443c8d400b9e0fdfda01",
        "ANTHROPIC_BASE_URL": "https://coding.dashscope.aliyuncs.com/apps/anthropic",
        "ANTHROPIC_MODEL": "kimi-k2.5"
    },
    "voiceEnabled": true
}
```

## Usage

1. **Launch**: Run `start-voice.ps1` in PowerShell
2. **Speak**: Wait for "[MIC] 正在录音..." and speak
3. **Listen**: AI responds with voice
4. **Continue**: Press Enter for next round
5. **Exit**: Say "退出" or "再见"

## Troubleshooting

### 401 Error
- API key is embedded in scripts
- If error occurs, check `$env:ANTHROPIC_AUTH_TOKEN`
- Correct key: `sk-sp-295f28f67...`

### Encoding Issues
- Use `start-voice.ps1` (UTF-8 enabled)
- Or `start-voice.bat` (chcp 65001)
- Avoid running directly in bash/Claude Code terminal

### No Speech Recognition
- Check microphone permissions
- Ensure `vosk-model-small-cn-0.22` folder exists
- Try downloading larger model for better accuracy

## File Locations

- **Main App**: `C:\Users\Win10\voice-assistant\voice_assistant_kimi.py`
- **Launchers**: `start-voice.ps1`, `start-voice.bat`
- **Docs**: `C:\Users\Win10\voice-assistant\README.md`
- **Skills**: `C:\Users\Win10\.claude\skills\voice-assistant.md`

## Models Available

- `kimi-k2.5` (default)
- `qwen3.5-plus`
- `qwen3-coder-next`
- `qwen3-coder-plus`

Change model: `$env:ANTHROPIC_MODEL="qwen3.5-plus"`

## Links

- **Coding Plan Console**: https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan
- **Documentation**: https://help.aliyun.com/zh/model-studio/coding-plan

---
*Last Updated: 2025-03-10*
