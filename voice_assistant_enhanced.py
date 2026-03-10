#!/usr/bin/env python3
"""
Enhanced Voice Assistant with Claude
Supports multiple TTS engines including ElevenLabs for high-quality voice.
"""

import os
import sys
import json
import tempfile
import subprocess
from datetime import datetime
from typing import Optional

# Load environment variables from .env file if available
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# Audio processing
import pyaudio
import speech_recognition as sr
from anthropic import Anthropic

# TTS options
TTS_ENGINE = os.environ.get("TTS_ENGINE", "pyttsx3").lower()

# Try to import optional TTS libraries
try:
    import pyttsx3
    PYTTSX3_AVAILABLE = True
except ImportError:
    PYTTSX3_AVAILABLE = False

try:
    from elevenlabs import play, stream
    from elevenlabs.client import ElevenLabs
    ELEVENLABS_AVAILABLE = True
except ImportError:
    ELEVENLABS_AVAILABLE = False

try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False


class EnhancedVoiceAssistant:
    def __init__(self, api_key: Optional[str] = None):
        """Initialize the enhanced voice assistant."""
        self.api_key = api_key or os.environ.get("ANTHROPIC_API_KEY")
        if not self.api_key:
            raise ValueError("Anthropic API key required. Set ANTHROPIC_API_KEY env var.")

        self.client = Anthropic(api_key=self.api_key)
        self.recognizer = sr.Recognizer()
        self.microphone = sr.Microphone()

        # Conversation history
        self.messages = []

        # Initialize TTS
        self._init_tts()

        # Calibrate for ambient noise
        print("Calibrating for ambient noise... (please wait)")
        with self.microphone as source:
            self.recognizer.adjust_for_ambient_noise(source, duration=2)
        print("Calibration complete!")

    def _init_tts(self):
        """Initialize text-to-speech engine based on configuration."""
        self.tts_engine = None
        self.elevenlabs_client = None

        if TTS_ENGINE == "elevenlabs" and ELEVENLABS_AVAILABLE:
            api_key = os.environ.get("ELEVENLABS_API_KEY")
            if api_key:
                self.elevenlabs_client = ElevenLabs(api_key=api_key)
                print("Using ElevenLabs for text-to-speech")
            else:
                print("ElevenLabs API key not found, falling back to pyttsx3")
                self._init_pyttsx3()
        elif TTS_ENGINE == "openai" and OPENAI_AVAILABLE:
            api_key = os.environ.get("OPENAI_API_KEY")
            if api_key:
                self.openai_client = OpenAI(api_key=api_key)
                print("Using OpenAI for text-to-speech")
            else:
                print("OpenAI API key not found, falling back to pyttsx3")
                self._init_pyttsx3()
        else:
            self._init_pyttsx3()

    def _init_pyttsx3(self):
        """Initialize local pyttsx3 TTS engine."""
        if PYTTSX3_AVAILABLE:
            try:
                self.tts_engine = pyttsx3.init()
                self.tts_engine.setProperty('rate', 180)
                self.tts_engine.setProperty('volume', 0.9)
                print("Using pyttsx3 for text-to-speech")
            except Exception as e:
                print(f"pyttsx3 initialization failed: {e}")
        else:
            print("No TTS engine available. Responses will be text-only.")

    def listen(self, timeout: int = 10, phrase_time_limit: int = 30) -> Optional[str]:
        """Record audio from microphone and transcribe to text."""
        print("\n🎤 Listening... (speak now)")

        try:
            with self.microphone as source:
                audio = self.recognizer.listen(source, timeout=timeout, phrase_time_limit=phrase_time_limit)

            print("📝 Transcribing...")

            # Try Google's speech recognition first
            try:
                text = self.recognizer.recognize_google(audio)
                print(f"You said: {text}")
                return text
            except sr.UnknownValueError:
                print("Could not understand audio")
                return None
            except sr.RequestError as e:
                print(f"Google Speech Recognition error: {e}")
                return self._transcribe_with_whisper(audio)

        except sr.WaitTimeoutError:
            print("No speech detected within timeout period")
            return None
        except Exception as e:
            print(f"Error during listening: {e}")
            return None

    def _transcribe_with_whisper(self, audio) -> Optional[str]:
        """Transcribe using OpenAI Whisper."""
        if not OPENAI_AVAILABLE:
            print("OpenAI not installed. Install with: pip install openai")
            return None

        try:
            openai_api_key = os.environ.get("OPENAI_API_KEY")
            if not openai_api_key:
                print("OpenAI API key not available")
                return None

            # Save audio to temporary file
            with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
                f.write(audio.get_wav_data())
                temp_path = f.name

            client = OpenAI(api_key=openai_api_key)
            with open(temp_path, "rb") as audio_file:
                transcript = client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file
                )

            os.unlink(temp_path)

            text = transcript.text
            print(f"You said (Whisper): {text}")
            return text

        except Exception as e:
            print(f"Whisper transcription failed: {e}")
            return None

    def get_claude_response(self, user_message: str) -> str:
        """Send message to Claude and get response."""
        self.messages.append({"role": "user", "content": user_message})

        try:
            response = self.client.messages.create(
                model="claude-sonnet-4-6-20251001",
                max_tokens=4096,
                messages=self.messages
            )

            assistant_message = response.content[0].text
            self.messages.append({"role": "assistant", "content": assistant_message})

            # Keep last 20 messages
            if len(self.messages) > 20:
                self.messages = self.messages[-20:]

            return assistant_message

        except Exception as e:
            print(f"Error getting Claude response: {e}")
            return f"Sorry, I encountered an error: {e}"

    def speak(self, text: str):
        """Convert text to speech using configured engine."""
        print(f"\n🤖 Assistant: {text}\n")

        if TTS_ENGINE == "elevenlabs" and self.elevenlabs_client:
            self._speak_elevenlabs(text)
        elif TTS_ENGINE == "openai" and hasattr(self, 'openai_client'):
            self._speak_openai(text)
        elif self.tts_engine:
            try:
                self.tts_engine.say(text)
                self.tts_engine.runAndWait()
            except Exception as e:
                print(f"TTS error: {e}")
        else:
            self._system_speak(text)

    def _speak_elevenlabs(self, text: str):
        """Use ElevenLabs for high-quality TTS."""
        try:
            voice_id = os.environ.get("ELEVENLABS_VOICE_ID", "XB0fDUnXU5powFXDhCwa")
            audio = self.elevenlabs_client.generate(
                text=text,
                voice=voice_id,
                model="eleven_multilingual_v2"
            )
            play(audio)
        except Exception as e:
            print(f"ElevenLabs TTS error: {e}, falling back to pyttsx3")
            if self.tts_engine:
                self.tts_engine.say(text)
                self.tts_engine.runAndWait()

    def _speak_openai(self, text: str):
        """Use OpenAI for TTS."""
        try:
            response = self.openai_client.audio.speech.create(
                model="tts-1",
                voice="alloy",
                input=text
            )
            # Play the audio
            with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as f:
                response.stream_to_file(f.name)
                temp_path = f.name

            # Play based on platform
            if sys.platform == "darwin":
                subprocess.run(["afplay", temp_path], check=False)
            elif sys.platform == "win32":
                os.startfile(temp_path)
            else:
                subprocess.run(["mpg123", temp_path], check=False)

        except Exception as e:
            print(f"OpenAI TTS error: {e}, falling back to pyttsx3")
            if self.tts_engine:
                self.tts_engine.say(text)
                self.tts_engine.runAndWait()

    def _system_speak(self, text: str):
        """Fallback system TTS."""
        if sys.platform == "darwin":
            subprocess.run(["say", text], check=False)
        elif sys.platform == "win32":
            try:
                import win32com.client
                speaker = win32com.client.Dispatch("SAPI.SpVoice")
                speaker.Speak(text)
            except:
                pass
        elif sys.platform == "linux":
            subprocess.run(["espeak", text], check=False)

    def run_conversation(self):
        """Run a single conversation turn."""
        user_input = self.listen()

        if not user_input:
            return True

        if user_input.lower() in ["exit", "quit", "goodbye", "bye"]:
            self.speak("Goodbye! Have a great day!")
            return False

        response = self.get_claude_response(user_input)
        self.speak(response)

        return True

    def run(self):
        """Main loop for the voice assistant."""
        print("=" * 50)
        print("🎙️  Enhanced Voice Assistant with Claude")
        print("=" * 50)
        print(f"TTS Engine: {TTS_ENGINE}")
        print("\nCommands:")
        print("  - Speak to interact with Claude")
        print("  - Say 'exit', 'quit', or 'goodbye' to stop")
        print("  - Press Ctrl+C to interrupt\n")

        self.speak("Hello! I'm your voice assistant. How can I help you today?")

        try:
            while True:
                if not self.run_conversation():
                    break
        except KeyboardInterrupt:
            print("\n\nInterrupted by user")
            self.speak("Goodbye!")


def main():
    """Entry point."""
    api_key = os.environ.get("ANTHROPIC_API_KEY")

    if not api_key:
        print("Error: ANTHROPIC_API_KEY environment variable not set")
        print("\nPlease set your API key:")
        print("  Windows: set ANTHROPIC_API_KEY=your_key_here")
        print("  macOS/Linux: export ANTHROPIC_API_KEY=your_key_here")
        print("\nOr create a .env file with your API key.")
        sys.exit(1)

    try:
        assistant = EnhancedVoiceAssistant(api_key=api_key)
        assistant.run()
    except Exception as e:
        print(f"Failed to start assistant: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
