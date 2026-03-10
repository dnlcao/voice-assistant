#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Test VoiceAssistant initialization."""

import os
import sys

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from voice_assistant_kimi import VoiceAssistant

print("=" * 60)
print("Testing VoiceAssistant Initialization")
print("=" * 60)
print()

# Check environment
print("Environment variables:")
print(f"  ANTHROPIC_AUTH_TOKEN: {(os.environ.get('ANTHROPIC_AUTH_TOKEN') or 'NOT SET')[:20]}...")
print(f"  ANTHROPIC_BASE_URL: {os.environ.get('ANTHROPIC_BASE_URL', 'NOT SET')}")
print(f"  ANTHROPIC_MODEL: {os.environ.get('ANTHROPIC_MODEL', 'NOT SET')}")
print()

try:
    # Test initialization
    print("Initializing VoiceAssistant...")
    assistant = VoiceAssistant(api_provider="anthropic")
    print()
    print("[SUCCESS] VoiceAssistant initialized successfully!")
    print(f"  API Provider: {assistant.api_provider}")
    print(f"  Model: {assistant.model}")
    print(f"  API Key: {assistant.api_key[:15]}..." if assistant.api_key else "  API Key: NOT SET")
    print()

    # Test API call
    print("Testing API call...")
    response = assistant.get_response("Say OK")
    print(f"[SUCCESS] API Response: {response}")

except Exception as e:
    print(f"[FAILED] Error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
