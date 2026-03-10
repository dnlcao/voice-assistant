# Voice Assistant Skill
# Complete guide for using the Voice Assistant with Coding Plan API

## Quick Start

### Launch Voice Assistant

**Option 1: PowerShell Script (Recommended)**
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\Win10\voice-assistant\start-voice.ps1"
```

**Option 2: Batch File**
```cmd
C:\Users\Win10\voice-assistant\start-voice.bat
```

**Option 3: Desktop Shortcut**
Double-click `VoiceAssistant.lnk` on Desktop (if created)

**Option 4: Manual Launch**
```powershell
cd C:\Users\Win10\voice-assistant
python voice_assistant_kimi.py --anthropic
```

## Configuration

### Environment Variables (Already Set)
- `ANTHROPIC_AUTH_TOKEN`: sk-sp-295f28f67311443c8d400b9e0fdfda01
- `ANTHROPIC_BASE_URL`: https://coding.dashscope.aliyuncs.com/apps/anthropic
- `ANTHROPIC_MODEL`: kimi-k2.5

### Available Models
- kimi-k2.5 (current)
- qwen3.5-plus
- qwen3-coder-next
- qwen3-coder-plus

## Usage

### Voice Commands
1. Wait for "[MIC] 正在录音..." prompt
2. Speak clearly in Chinese
3. Stay quiet for 2.5 seconds to end recording
4. AI will respond with voice
5. Press Enter to continue, or say "退出"/"再见" to exit

### Available Scripts

| Script | Purpose |
|--------|---------|
| `start-voice.ps1` | Main launcher (PowerShell) |
| `start-voice.bat` | Main launcher (Batch) |
| `setup_coding_plan.ps1` | Configure Coding Plan API |
| `start_coding_plan.ps1` | Start with Coding Plan |
| `debug_api.py` | Test API connection |
| `test_coding_plan_api.py` | Test Coding Plan API |
| `download_vosk_model.py` | Download speech models |

## Troubleshooting

### 401 Error (API Key)
The API key is already configured in the scripts. If you get 401:
1. Check that the correct key is being used (sk-sp-295f28f67...)
2. Run the script directly (not through shortcuts that may cache old keys)

### Encoding Issues
Use `start-voice.ps1` or `start-voice.bat` which have UTF-8 encoding set.

### No Microphone
Ensure microphone is connected and allowed for Python/terminal.

## Features

- 🎤 Offline speech recognition (Vosk)
- 🔊 Text-to-speech (pyttsx3)
- 🧠 AI via Coding Plan API (kimi-k2.5)
- 🌐 Chinese optimized
- 💻 Windows compatible

## File Structure

```
voice-assistant/
├── voice_assistant_kimi.py      # Main application
├── start-voice.ps1              # PowerShell launcher
├── start-voice.bat              # Batch launcher
├── setup_coding_plan.ps1        # Configuration script
├── debug_api.py                 # API test
├── test_coding_plan_api.py      # Coding Plan test
├── download_vosk_model.py       # Model downloader
├── vosk-model-small-cn-0.22/    # Chinese speech model
└── README.md                    # Full documentation
```

## Requirements

```bash
pip install openai pyaudio vosk pyttsx3
```

See `requirements.txt` for full list.

## Links

- Coding Plan Console: https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan
- Documentation: C:\Users\Win10\voice-assistant\README.md
