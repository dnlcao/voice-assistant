#!/usr/bin/env python3
"""
Voice Assistant with Claude
Records audio, transcribes to text, gets Claude's response, and speaks it back.
"""

import os
import sys
import json
import wave
import tempfile
import subprocess
from datetime import datetime
from typing import Optional

# Audio processing
import pyaudio
import speech_recognition as sr
from anthropic import Anthropic

# Text-to-speech - cross platform options
try:
    import pyttsx3
    PYTTSX3_AVAILABLE = True
except ImportError:
    PYTTSX3_AVAILABLE = False


class VoiceAssistant:
    def __init__(self, api_key: Optional[str] = None):
        """Initialize the voice assistant."""
        self.api_key = api_key or os.environ.get("ANTHROPIC_API_KEY")
        if not self.api_key:
            raise ValueError("Anthropic API key required. Set ANTHROPIC_API_KEY env var.")

        self.client = Anthropic(api_key=self.api_key)
        self.recognizer = sr.Recognizer()
        self.microphone = sr.Microphone()

        # Conversation history
        self.messages = []

        # Initialize TTS engine
        self.tts_engine = None
        if PYTTSX3_AVAILABLE:
            try:
                self.tts_engine = pyttsx3.init()
                # Set properties for better voice
                self.tts_engine.setProperty('rate', 180)  # Speed
                self.tts_engine.setProperty('volume', 0.9)  # Volume
            except Exception as e:
                print(f"TTS initialization failed: {e}")

        # Calibrate for ambient noise
        print("Calibrating for ambient noise... (please wait)")
        with self.microphone as source:
            self.recognizer.adjust_for_ambient_noise(source, duration=2)
        print("Calibration complete!")

    def listen(self, timeout: int = 10, phrase_time_limit: int = 30) -> Optional[str]:
        """Record audio from microphone and transcribe to text."""
        print("\n🎤 Listening... (speak now)")

        try:
            with self.microphone as source:
                # Listen for audio
                audio = self.recognizer.listen(source, timeout=timeout, phrase_time_limit=phrase_time_limit)

            print("📝 Transcribing...")

            # Try using Google's speech recognition (free, requires internet)
            try:
                text = self.recognizer.recognize_google(audio)
                print(f"You said: {text}")
                return text
            except sr.UnknownValueError:
                print("Could not understand audio")
                return None
            except sr.RequestError as e:
                print(f"Google Speech Recognition error: {e}")
                # Fallback to whisper if available
                return self._transcribe_with_whisper(audio)

        except sr.WaitTimeoutError:
            print("No speech detected within timeout period")
            return None
        except Exception as e:
            print(f"Error during listening: {e}")
            return None

    def _transcribe_with_whisper(self, audio) -> Optional[str]:
        """Fallback transcription using OpenAI Whisper."""
        try:
            import openai
            openai_api_key = os.environ.get("OPENAI_API_KEY")
            if not openai_api_key:
                print("OpenAI API key not available for Whisper fallback")
                return None

            # Save audio to temporary file
            with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
                f.write(audio.get_wav_data())
                temp_path = f.name

            # Transcribe with Whisper
            client = openai.OpenAI(api_key=openai_api_key)
            with open(temp_path, "rb") as audio_file:
                transcript = client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file
                )

            # Clean up
            os.unlink(temp_path)

            text = transcript.text
            print(f"You said (Whisper): {text}")
            return text

        except Exception as e:
            print(f"Whisper transcription failed: {e}")
            return None

    def get_claude_response(self, user_message: str) -> str:
        """Send message to Claude and get response."""
        # Add user message to history
        self.messages.append({"role": "user", "content": user_message})

        try:
            response = self.client.messages.create(
                model="claude-sonnet-4-6-20251001",
                max_tokens=4096,
                messages=self.messages
            )

            assistant_message = response.content[0].text

            # Add assistant response to history
            self.messages.append({"role": "assistant", "content": assistant_message})

            # Keep conversation history manageable (last 20 messages)
            if len(self.messages) > 20:
                self.messages = self.messages[-20:]

            return assistant_message

        except Exception as e:
            print(f"Error getting Claude response: {e}")
            return f"Sorry, I encountered an error: {e}"

    def speak(self, text: str):
        """Convert text to speech."""
        print(f"\n🤖 Assistant: {text}\n")

        if self.tts_engine:
            try:
                self.tts_engine.say(text)
                self.tts_engine.runAndWait()
            except Exception as e:
                print(f"TTS error: {e}")
                # Fallback to system TTS
                self._system_speak(text)
        else:
            self._system_speak(text)

    def _system_speak(self, text: str):
        """Fallback text-to-speech using system commands."""
        if sys.platform == "darwin":  # macOS
            subprocess.run(["say", text], check=False)
        elif sys.platform == "win32":  # Windows
            try:
                import win32com.client
                speaker = win32com.client.Dispatch("SAPI.SpVoice")
                speaker.Speak(text)
            except:
                pass
        elif sys.platform == "linux":  # Linux
            subprocess.run(["espeak", text], check=False)

    def run_conversation(self):
        """Run a single conversation turn."""
        # Listen for user input
        user_input = self.listen()

        if not user_input:
            return True  # Continue loop

        # Check for exit commands
        if user_input.lower() in ["exit", "quit", "goodbye", "bye"]:
            self.speak("Goodbye! Have a great day!")
            return False

        # Get Claude's response
        response = self.get_claude_response(user_input)

        # Speak the response
        self.speak(response)

        return True

    def run(self):
        """Main loop for the voice assistant."""
        print("=" * 50)
        print("🎙️  Voice Assistant with Claude")
        print("=" * 50)
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
    # Check for API key
    api_key = os.environ.get("ANTHROPIC_API_KEY")

    if not api_key:
        print("Error: ANTHROPIC_API_KEY environment variable not set")
        print("\nPlease set your API key:")
        print("  Windows: set ANTHROPIC_API_KEY=your_key_here")
        print("  macOS/Linux: export ANTHROPIC_API_KEY=your_key_here")
        print("\nOr create a .env file with your API key.")
        sys.exit(1)

    # Create and run assistant
    try:
        assistant = VoiceAssistant(api_key=api_key)
        assistant.run()
    except Exception as e:
        print(f"Failed to start assistant: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
