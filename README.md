# Voice Assistant with Coding Plan

[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A complete offline-capable voice assistant supporting Coding Plan (Aliyun) and Kimi APIs with Chinese speech recognition.

## Features

- 🎤 **Offline Speech Recognition** - Uses Vosk (no internet needed for speech-to-text)
- 🧠 **Multi-API Support** - Coding Plan (kimi-k2.5, qwen3.5-plus) + Kimi (Moonshot AI)
- 🔊 **Text-to-Speech** - Cross-platform TTS with pyttsx3
- 🌐 **Chinese Optimized** - Includes Chinese Vosk model
- 💻 **Windows Compatible** - Handles encoding issues properly
- 🔧 **Easy Setup** - One-command installation

## Quick Start

### Prerequisites

- Python 3.8 or higher
- Microphone
- Windows 10/11 (with WSL or Git Bash for Linux/Mac)

### Installation

```bash
# Clone the repository
git clone https://github.com/dnlcao/voice-assistant.git
cd voice-assistant

# Install dependencies
pip install -r requirements.txt

# Download Chinese speech model
python download_vosk_model.py cn
```

### Configuration

Set your Coding Plan API key (optional - already configured):

```powershell
$env:ANTHROPIC_AUTH_TOKEN="your-api-key"
$env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"
$env:ANTHROPIC_MODEL="kimi-k2.5"
```

### Usage

**Option 1: PowerShell Script (Recommended)**
```powershell
.\start-voice.ps1
```

**Option 2: Batch File**
```cmd
start-voice.bat
```

**Option 3: Python Direct**
```bash
python voice_assistant_kimi.py --anthropic
```

## How to Use

1. **Launch** the assistant using one of the methods above
2. **Wait** for "[MIC] 正在录音..." prompt
3. **Speak** clearly in Chinese
4. **Stay quiet** for 2.5 seconds to end recording
5. **Listen** as the AI responds with voice
6. **Press Enter** to continue, or say "退出"/"再见" to exit

## Available Models

| Model | Provider | Features |
|-------|----------|----------|
| `kimi-k2.5` | Moonshot AI | Text generation, deep thinking, vision |
| `qwen3.5-plus` | Alibaba | Text generation, deep thinking, vision |
| `qwen3-coder-next` | Alibaba | Text generation (coding optimized) |
| `qwen3-coder-plus` | Alibaba | Text generation |

Change model by setting environment variable:
```powershell
$env:ANTHROPIC_MODEL="qwen3.5-plus"
```

## Project Structure

```
voice-assistant/
├── voice_assistant_kimi.py      # Main application
├── start-voice.ps1              # PowerShell launcher
├── start-voice.bat              # Batch launcher
├── setup_coding_plan.ps1        # Configuration script
├── requirements.txt             # Python dependencies
├── download_vosk_model.py       # Model downloader
├── README.md                    # Documentation
├── skills/                      # Claude Code skills
│   ├── voice-assistant.md
│   └── SUMMARY.md
└── vosk-model-small-cn-0.22/    # Chinese speech model
```

## API Configuration

### Coding Plan (Recommended)

Get API Key: https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan

```powershell
$env:ANTHROPIC_AUTH_TOKEN="sk-your-key"
$env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"
$env:ANTHROPIC_MODEL="kimi-k2.5"
```

### Kimi (Alternative)

Get API Key: https://platform.moonshot.cn/

```powershell
$env:KIMI_API_KEY="sk-your-key"
python voice_assistant_kimi.py --kimi
```

## Troubleshooting

### 401 Error (API Key)
The API key is embedded in the scripts. If you get 401:
- Check that the correct key is being used
- Run the script directly (not through shortcuts that may cache old keys)

### Encoding Issues
Use `start-voice.ps1` which has UTF-8 encoding set properly.

### No Microphone
Ensure microphone is connected and allowed for Python/terminal.

### Model Not Found
Download the Vosk model:
```bash
python download_vosk_model.py cn
```

## Claude Code Integration

This project includes Claude Code skills for easy access:

### Skills Location
`C:\Users\Win10\.claude\skills\` (Windows)
`~/.claude/skills/` (Linux/Mac)

### Available Skills
- `voice-assistant.md` - Complete usage guide
- `SUMMARY.md` - Project summary and updates

## Dependencies

- `openai` - OpenAI SDK for API calls
- `vosk` - Offline speech recognition
- `pyaudio` - Audio recording
- `pyttsx3` - Text-to-speech
- `anthropic` - Anthropic SDK (optional)

See `requirements.txt` for complete list.

## License

MIT License - Feel free to modify and distribute.

## Credits

- Vosk: https://alphacephei.com/vosk/
- Coding Plan (Aliyun): https://bailian.console.aliyun.com/
- Kimi (Moonshot AI): https://platform.moonshot.cn/

## Contributing

Contributions welcome! Please feel free to submit issues or pull requests.

---

**Last Updated**: 2025-03-10
