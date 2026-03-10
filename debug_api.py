#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test Coding Plan API connection with detailed debugging.
"""

import os
import sys

# Check environment variables
api_key = os.environ.get('ANTHROPIC_AUTH_TOKEN') or os.environ.get('ANTHROPIC_API_KEY') or os.environ.get('DASHSCOPE_API_KEY')
base_url = os.environ.get('ANTHROPIC_BASE_URL', 'https://coding.dashscope.aliyuncs.com/apps/anthropic')
model = os.environ.get('ANTHROPIC_MODEL', 'qwen3.5-plus')

print("=" * 60)
print("Coding Plan API Test")
print("=" * 60)
print()

print("Environment Variables:")
print(f"  API Key: {api_key[:20]}..." if api_key else "  API Key: NOT SET")
print(f"  Base URL: {base_url}")
print(f"  Model: {model}")
print()

if not api_key:
    print("[ERROR] API key not set!")
    print("Set ANTHROPIC_AUTH_TOKEN environment variable")
    sys.exit(1)

# Convert URL for OpenAI SDK
openai_base_url = base_url.replace('/apps/anthropic', '/v1')
if openai_base_url != base_url:
    print(f"[INFO] Converted URL: {openai_base_url}")
    print()

# Test with OpenAI SDK
print("Testing with OpenAI SDK...")
print("-" * 60)

try:
    from openai import OpenAI

    client = OpenAI(
        api_key=api_key,
        base_url=openai_base_url
    )

    print(f"Request: model={model}, messages=[...], max_tokens=10")
    print()

    response = client.chat.completions.create(
        model=model,
        messages=[{'role': 'user', 'content': 'Hello, reply with OK'}],
        max_tokens=10
    )

    print(f"[SUCCESS] API connection successful!")
    print(f"Response: {response.choices[0].message.content}")
    print()
    print("=" * 60)
    print("All tests passed!")
    print("=" * 60)

except Exception as e:
    print(f"[FAILED] Error: {e}")
    print()
    print("=" * 60)
    print("Troubleshooting:")
    print("=" * 60)
    print()
    print("1. Verify your API key is correct:")
    print("   https://bailian.console.aliyun.com/cn-beijing/?tab=model#/efm/coding_plan")
    print()
    print("2. Check if the model is available in your subscription:")
    print(f"   Model: {model}")
    print()
    print("3. Try a different model:")
    print("   $env:ANTHROPIC_MODEL='qwen3.5-plus'")
    print()
    print("4. Try direct API call with curl:")
    print(f"   curl {openai_base_url}/chat/completions \\")
    print("     -H \"Authorization: Bearer YOUR_API_KEY\" \\")
    print("     -H \"Content-Type: application/json\" \\")
    print('     -d \'{"model": "' + model + '", "messages": [{"role": "user", "content": "Hello"}]}\'')
    print()
    sys.exit(1)
