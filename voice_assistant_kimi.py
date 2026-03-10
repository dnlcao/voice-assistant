#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Voice Assistant with Kimi (Moonshot AI) - Chinese Only Version
Records audio, transcribes to text, gets AI response, and speaks it back.
Uses Vosk for offline speech recognition (Chinese only).
"""

import os
import sys
import json
import math
import pyaudio
from datetime import datetime
from typing import Optional

# Vosk for offline speech recognition
try:
    from vosk import Model, KaldiRecognizer
    VOSK_AVAILABLE = True
except ImportError:
    VOSK_AVAILABLE = False
    print("Warning: vosk not installed. Run: pip install vosk")

# OpenAI SDK for Kimi and Coding Plan
try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False

# Anthropic SDK for Coding Plan
try:
    import anthropic
    ANTHROPIC_AVAILABLE = True
except ImportError:
    ANTHROPIC_AVAILABLE = False


def safe_print(text, **kwargs):
    """Print text safely handling encoding issues on Windows."""
    try:
        print(text, **kwargs)
    except UnicodeEncodeError:
        safe_text = text.encode('ascii', 'ignore').decode('ascii')
        print(safe_text, **kwargs)


class VoiceAssistant:
    def __init__(self, api_key: Optional[str] = None, api_provider: str = "auto"):
        """Initialize the voice assistant (Chinese only)."""
        self.api_provider = api_provider
        self.client = None
        self.model = None
        self.messages = []

        # Try to detect API provider from environment
        if api_provider == "auto":
            if os.environ.get("KIMI_API_KEY"):
                self.api_provider = "kimi"
            elif os.environ.get("ANTHROPIC_AUTH_TOKEN") or os.environ.get("ANTHROPIC_API_KEY"):
                self.api_provider = "anthropic"

        # Initialize based on provider
        if self.api_provider == "anthropic":
            self._init_coding_plan(api_key)
        else:
            self._init_kimi(api_key)

        # Initialize Vosk model for Chinese speech recognition
        self.vosk_model = None
        self._init_vosk_model()

        # Audio settings - optimized for better recognition
        self.sample_rate = 16000  # Vosk models are trained on 16kHz
        self.chunk_size = 2048    # Chunk size for audio processing
        self.silence_threshold = 2.5     # Seconds of silence to stop
        self.min_speech_duration = 0.5   # Minimum speech to process (seconds)
        self.max_recording_time = 15.0   # Maximum recording time (seconds)

        # Initialize TTS engine
        self._init_tts()

    def _init_coding_plan(self, api_key: Optional[str] = None):
        """Initialize Coding Plan client using OpenAI SDK."""
        # Use passed api_key first, then fall back to environment variables
        self.api_key = api_key if api_key else os.environ.get("ANTHROPIC_AUTH_TOKEN") or os.environ.get("ANTHROPIC_API_KEY") or os.environ.get("DASHSCOPE_API_KEY")
        if not self.api_key:
            raise ValueError("API key required. Set ANTHROPIC_AUTH_TOKEN or DASHSCOPE_API_KEY env var.")

        # Get base URL from environment
        base_url = os.environ.get("ANTHROPIC_BASE_URL", "https://coding.dashscope.aliyuncs.com/apps/anthropic")

        # For OpenAI SDK, use the /v1 endpoint
        if '/apps/anthropic' in base_url:
            openai_base_url = base_url.replace('/apps/anthropic', '/v1')
        elif base_url.endswith('/v1'):
            openai_base_url = base_url
        else:
            openai_base_url = base_url.rstrip('/') + '/v1'

        # Detect provider from URL
        if 'coding.dashscope' in base_url.lower():
            provider_name = "Coding Plan (Aliyun)"
            default_model = "qwen3.5-plus"
        elif 'dashscope' in base_url.lower():
            provider_name = "DashScope (Aliyun)"
            default_model = "qwen-plus"
        else:
            provider_name = "Anthropic Compatible"
            default_model = "claude-3-5-sonnet-20241022"

        safe_print(f"[INFO] Connecting to {provider_name}")
        safe_print(f"[INFO] OpenAI Endpoint: {openai_base_url}")
        safe_print(f"[DEBUG] API Key: {self.api_key[:15]}...")

        if not OPENAI_AVAILABLE:
            raise ImportError("openai SDK not installed. Run: pip install openai")

        # Always use OpenAI SDK for Coding Plan
        self.client = OpenAI(api_key=self.api_key, base_url=openai_base_url)
        self.use_anthropic_sdk = False
        safe_print("[OK] Using OpenAI SDK")

        # Set model from environment or use default
        self.model = os.environ.get("ANTHROPIC_MODEL", default_model)
        safe_print(f"[OK] Using model: {self.model}")

        # Set model from environment or use default
        self.model = os.environ.get("ANTHROPIC_MODEL", default_model)
        safe_print(f"[OK] Using model: {self.model}")

        # Show available models for this provider
        if 'coding.dashscope' in base_url.lower():
            safe_print("[TIP] Available Coding Plan models: qwen3.5-plus, qwen3-coder-next, qwen3-coder-plus, kimi-k2.5")
        elif 'dashscope' in base_url.lower():
            safe_print("[TIP] Available DashScope models: qwen-plus, qwen-turbo, qwen-max, claude-3-5-sonnet-20241022")

    def _init_kimi(self, api_key: Optional[str] = None):
        """Initialize Kimi client."""
        self.api_key = api_key if api_key else os.environ.get("KIMI_API_KEY")
        if not self.api_key:
            raise ValueError("Kimi API key required. Set KIMI_API_KEY env var.")

        if not OPENAI_AVAILABLE:
            raise ImportError("openai SDK not installed. Run: pip install openai")

        self.client = OpenAI(
            api_key=self.api_key,
            base_url="https://api.moonshot.cn/v1"
        )
        self.model = "kimi-k2.5"
        safe_print(f"[OK] Kimi client initialized (model: {self.model})")

    def _init_vosk_model(self):
        """Initialize Vosk model for Chinese speech recognition."""
        if not VOSK_AVAILABLE:
            safe_print("[X] Vosk not available. Please install: pip install vosk")
            return

        possible_paths = [
            "./vosk-model-small-cn-0.22",
            "./vosk-model-cn-0.22",
        ]

        for path in possible_paths:
            if path and os.path.exists(path):
                try:
                    safe_print(f"Loading Chinese Vosk model from: {path}")
                    self.vosk_model = Model(path)
                    safe_print("[OK] Chinese Vosk model loaded!")
                    return
                except Exception as e:
                    safe_print(f"Failed to load model from {path}: {e}")

        safe_print("\n[!] Chinese Vosk model not found!")
        safe_print("Please download: python download_vosk_model.py cn")

    def _init_tts(self):
        """Initialize text-to-speech engine."""
        safe_print("Initializing TTS engine...")
        self.tts_engine = None
        try:
            import pyttsx3
            self.tts_engine = pyttsx3.init()
            self.tts_engine.setProperty('rate', 180)
            self.tts_engine.setProperty('volume', 0.9)
            safe_print("[OK] TTS engine initialized")
        except Exception as e:
            safe_print(f"TTS initialization failed: {e}")

    def _calculate_energy(self, data: bytes) -> float:
        """Calculate audio energy level."""
        # Convert bytes to array of 16-bit integers
        import array
        audio_data = array.array('h', data)
        if len(audio_data) == 0:
            return 0.0
        # Calculate RMS (Root Mean Square) energy
        sum_squares = sum(x * x for x in audio_data)
        rms = (sum_squares / len(audio_data)) ** 0.5
        return rms

    def listen(self) -> Optional[str]:
        """Record audio and transcribe to text (Chinese only)."""
        if not self.vosk_model:
            safe_print("[X] Vosk model not loaded.")
            return None

        safe_print("\n[MIC] 正在录音... (请说话，安静2.5秒后自动结束)")
        safe_print("[TIP] 建议：说话清晰，语速适中，避免背景噪音")

        p = pyaudio.PyAudio()

        # Configure audio stream
        stream = p.open(
            format=pyaudio.paInt16,
            channels=1,
            rate=self.sample_rate,
            input=True,
            frames_per_buffer=self.chunk_size
        )

        recognizer = KaldiRecognizer(self.vosk_model, self.sample_rate)
        recognizer.SetWords(True)

        # Recording parameters
        silence_frames = 0
        speech_frames = 0
        has_speech = False
        max_silence = int(self.sample_rate / self.chunk_size * self.silence_threshold)
        min_speech = int(self.sample_rate / self.chunk_size * self.min_speech_duration)
        max_frames = int(self.sample_rate / self.chunk_size * self.max_recording_time)
        last_result_text = ""
        total_frames = 0
        energy_threshold = 500  # Minimum audio energy to consider as speech

        try:
            while True:
                # Read audio data
                data = stream.read(self.chunk_size, exception_on_overflow=False)
                total_frames += 1

                # Calculate audio energy
                audio_level = self._calculate_energy(data)

                result_text = ""
                if recognizer.AcceptWaveform(data):
                    result = json.loads(recognizer.Result())
                    result_text = result.get("text", "").strip()
                    if result_text:
                        last_result_text = result_text
                else:
                    partial = json.loads(recognizer.PartialResult())
                    result_text = partial.get("partial", "").strip()

                # Detect speech (by Vosk result or audio energy)
                if result_text or audio_level > energy_threshold:
                    has_speech = True
                    if result_text:
                        speech_frames += 1
                    silence_frames = 0
                    if result_text:
                        safe_print(f"\r  ... {result_text}", end="", flush=True)
                else:
                    silence_frames += 1

                # Stop conditions
                if has_speech and silence_frames > max_silence and speech_frames > min_speech:
                    safe_print("\n[OK] 检测到语音结束，处理中...")
                    break

                # Safety: max recording time
                if total_frames > max_frames:
                    safe_print("\n[INFO] 达到最大录音时长，处理中...")
                    break

        except KeyboardInterrupt:
            safe_print("\n[STOP] 已停止")
        except Exception as e:
            safe_print(f"\n[ERROR] 录音出错: {e}")
        finally:
            stream.stop_stream()
            stream.close()
            p.terminate()

        # Get final result
        result = json.loads(recognizer.FinalResult())
        text = result.get("text", "").strip()

        # Fallback to last partial result if final is empty
        if not text and last_result_text:
            text = last_result_text

        if not text:
            safe_print("[X] 未能识别语音，请重试")
            return None

        # Clean up the text (remove extra spaces)
        text = " ".join(text.split())
        safe_print(f"[OK] 识别结果: {text}")
        return text
        return text

    def get_response(self, user_message: str) -> str:
        """Get AI response using OpenAI SDK."""
        user_message = user_message.encode('utf-8', errors='ignore').decode('utf-8')
        self.messages.append({"role": "user", "content": user_message})

        try:
            response = self.client.chat.completions.create(
                model=self.model,
                max_tokens=4096,
                messages=self.messages
            )

            assistant_message = response.choices[0].message.content
            assistant_message = assistant_message.encode('utf-8', errors='ignore').decode('utf-8')

            self.messages.append({"role": "assistant", "content": assistant_message})

            if len(self.messages) > 20:
                self.messages = self.messages[-20:]

            return assistant_message

        except Exception as e:
            error_msg = str(e)
            if "404" in error_msg:
                safe_print(f"\n{'='*60}")
                safe_print(f"Error: Model '{self.model}' not found (404)")
                safe_print(f"{'='*60}")
                safe_print("\n建议改用 Kimi API:")
                safe_print('  $env:KIMI_API_KEY="sk-your-key"')
                safe_print('  python voice_assistant_kimi.py --kimi')
                safe_print(f"{'='*60}")
                return "[错误] 模型未找到"
            elif "401" in error_msg or "invalid_api_key" in error_msg or "Unauthorized" in error_msg:
                safe_print(f"\n{'='*60}")
                safe_print("Error: API Key 不正确 (401)")
                safe_print(f"{'='*60}")
                safe_print("\n解决方案 1 - 使用 Coding Plan (推荐):")
                safe_print("  1. 获取 Coding Plan API Key:")
                safe_print("     https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan")
                safe_print("\n  2. 设置环境变量 (使用 OpenAI SDK，推荐):")
                safe_print('     $env:ANTHROPIC_AUTH_TOKEN="sk-your-key"')
                safe_print('     $env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"')
                safe_print('     $env:ANTHROPIC_MODEL="qwen3.5-plus"')
                safe_print("\n  注意: 代码会自动将 /apps/anthropic 转换为 /v1 (OpenAI 端点)")
                safe_print("\n解决方案 2 - 使用 Kimi (Moonshot AI):")
                safe_print('  $env:KIMI_API_KEY="sk-your-key"')
                safe_print('  python voice_assistant_kimi.py --kimi')
                safe_print(f"{'='*60}")
                return "[错误] API Key 不正确"
            safe_print(f"Error: {e}")
            return f"抱歉，出现了错误: {e}"

    def speak(self, text: str):
        """Convert text to speech."""
        safe_print(f"\n[助手] {text}\n")

        if self.tts_engine:
            try:
                self.tts_engine.say(text)
                self.tts_engine.runAndWait()
            except Exception as e:
                safe_print(f"TTS error: {e}")

    def run(self):
        """Main loop."""
        safe_print("=" * 50)
        safe_print("中文语音助手")
        safe_print("=" * 50)
        safe_print("\n命令:")
        safe_print("  - 说话与AI交流")
        safe_print("  - 说'退出'或'再见'结束")
        safe_print("  - 按Ctrl+C中断")

        self.speak("你好！我是你的语音助手。有什么可以帮您的？")

        try:
            while True:
                user_input = self.listen()

                if not user_input:
                    # No speech detected, wait for user to continue
                    safe_print("\n[按Enter重试，或Ctrl+C退出...]")
                    try:
                        input()
                    except KeyboardInterrupt:
                        break
                    continue

                if user_input.lower() in ["exit", "quit", "goodbye", "bye", "再见", "退出"]:
                    self.speak("再见！祝你有美好的一天！")
                    break

                response = self.get_response(user_input)
                self.speak(response)

                safe_print("\n[按Enter继续，或Ctrl+C退出...]")
                try:
                    input()
                except KeyboardInterrupt:
                    break

        except KeyboardInterrupt:
            safe_print("\n\n再见！")
            self.speak("再见！")


def main():
    """Entry point."""
    # Check for API keys - prioritize ANTHROPIC_AUTH_TOKEN
    anthropic_key = os.environ.get("ANTHROPIC_AUTH_TOKEN")
    if not anthropic_key:
        anthropic_key = os.environ.get("ANTHROPIC_API_KEY")

    kimi_key = os.environ.get("KIMI_API_KEY")

    safe_print(f"[DEBUG] Env ANTHROPIC_AUTH_TOKEN: {(os.environ.get('ANTHROPIC_AUTH_TOKEN') or 'NOT SET')[:20]}...")
    safe_print(f"[DEBUG] Env ANTHROPIC_API_KEY: {(os.environ.get('ANTHROPIC_API_KEY') or 'NOT SET')[:20]}...")
    safe_print(f"[DEBUG] Selected anthropic_key: {anthropic_key[:20]}..." if anthropic_key else "[DEBUG] Selected anthropic_key: NOT SET")

    api_provider = "auto"
    api_key = None

    if "--anthropic" in sys.argv:
        api_provider = "anthropic"
        api_key = anthropic_key
        safe_print(f"[DEBUG] Using --anthropic, passing api_key: {api_key[:20]}..." if api_key else "[DEBUG] Using --anthropic, api_key is None")
    elif "--kimi" in sys.argv:
        api_provider = "kimi"
        api_key = kimi_key
    else:
        if anthropic_key:
            api_provider = "anthropic"
            api_key = anthropic_key
        elif kimi_key:
            api_provider = "kimi"
            api_key = kimi_key

    if not api_key:
        safe_print("=" * 60)
        safe_print("[X] 错误: 未找到API密钥")
        safe_print("=" * 60)
        safe_print("\n方案 1 - 使用 Coding Plan (推荐中文):")
        safe_print("  1. 获取 API Key:")
        safe_print("     https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan")
        safe_print("\n  2. 设置环境变量:")
        safe_print('     $env:ANTHROPIC_AUTH_TOKEN="sk-your-key"')
        safe_print('     $env:ANTHROPIC_BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"')
        safe_print('     $env:ANTHROPIC_MODEL="qwen3.5-plus"')
        safe_print('     python voice_assistant_kimi.py --anthropic')
        safe_print("\n方案 2 - 使用 Kimi (Moonshot AI):")
        safe_print('    $env:KIMI_API_KEY="sk-your-key"')
        safe_print('    python voice_assistant_kimi.py --kimi')
        safe_print("=" * 60)
        sys.exit(1)

    try:
        assistant = VoiceAssistant(api_key=api_key, api_provider=api_provider)

        if not assistant.vosk_model:
            safe_print("\n[!] 无法启动: 未找到Vosk模型")
            safe_print("请下载: python download_vosk_model.py cn")
            sys.exit(1)

        assistant.run()
    except Exception as e:
        safe_print(f"启动失败: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
