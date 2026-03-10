# GitHub Upload Instructions for dnlcao/voice-assistant

## Repository: https://github.com/dnlcao/voice-assistant

### Quick Upload Steps

#### Step 1: Create Repository on GitHub
1. Go to https://github.com/new
2. Repository name: `voice-assistant`
3. Description: `Voice Assistant with Coding Plan API - Chinese speech recognition and TTS`
4. Visibility: Public (or Private)
5. **DO NOT** initialize with README (we have our own)
6. Click "Create repository"

#### Step 2: Upload via Web Interface
1. In your new repository, click "uploading an existing file" link
2. Or go to: https://github.com/dnlcao/voice-assistant/upload
3. Drag and drop all files from `C:\Users\Win10\voice-assistant\`
4. **Exclude:**
   - `.git/` folder
   - `vosk-model-small-cn-0.22/` (large model files)
   - `vosk-model-small-en-us-0.15/` (large model files)
   - `__pycache__/` folder
5. Add commit message: "Initial commit: Voice Assistant with Coding Plan"
6. Click "Commit changes"

#### Step 3: Add Model Files (Optional)
The Vosk models are large (~40MB each). You can:
- Option A: Include them in the repo (if under 100MB total)
- Option B: Add download instructions and exclude from upload

For Option B, add to README:
```bash
# Download models separately
python download_vosk_model.py cn
python download_vosk_model.py en
```

### Alternative: Command Line (if network allows)

```bash
cd C:\Users\Win10\voice-assistant

# Set remote
git remote add origin https://github.com/dnlcao/voice-assistant.git

# Push
git push -u origin master
```

### Files to Upload

**Core Files (Required):**
- voice_assistant_kimi.py
- voice_assistant.py
- voice_assistant_enhanced.py
- requirements.txt
- README.md
- .gitignore

**Launch Scripts:**
- start-voice.ps1
- start-voice.bat
- setup_coding_plan.ps1
- start_coding_plan.ps1
- All other .bat and .ps1 files

**Test & Debug:**
- debug_api.py
- test_coding_plan_api.py
- test_init.py
- test_main.py
- test_kimi_api.py

**Documentation:**
- CHANGELOG.md
- skills/SUMMARY.md
- skills/voice-assistant.md

**Config:**
- .env.example
- setup.sh

**Exclude (Large Files):**
- vosk-model-small-cn-0.22/ (40MB)
- vosk-model-small-en-us-0.15/ (40MB)
- __pycache__/ (cached Python files)
- .git/ (git history, optional)

### After Upload

Your repository will be available at:
https://github.com/dnlcao/voice-assistant

### Clone Command for Others

```bash
git clone https://github.com/dnlcao/voice-assistant.git
cd voice-assistant
pip install -r requirements.txt
python download_vosk_model.py cn
python voice_assistant_kimi.py --anthropic
```

### Skills Directory

The `skills/` folder contains Claude Code documentation:
- `SUMMARY.md` - Project summary
- `voice-assistant.md` - Usage guide

These can be copied to `~/.claude/skills/` for Claude Code integration.

---

## Need Help?

If you encounter issues:
1. Check GitHub's file size limits (100MB per file, 2GB per repo recommended)
2. Use GitHub Desktop for easier upload: https://desktop.github.com/
3. Or use GitHub's web interface for small uploads
