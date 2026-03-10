#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test Coding Plan API connection.
Tests the 3 required parameters: ANTHROPIC_BASE_URL, ANTHROPIC_AUTH_TOKEN, ANTHROPIC_MODEL
"""

import os
from openai import OpenAI

def test_coding_plan_api():
    """Test Coding Plan API with the 3 required parameters."""
    # Get the 3 required parameters
    api_key = os.environ.get('ANTHROPIC_AUTH_TOKEN') or os.environ.get('ANTHROPIC_API_KEY')
    base_url = os.environ.get('ANTHROPIC_BASE_URL', 'https://coding.dashscope.aliyuncs.com/v1')
    model = os.environ.get('ANTHROPIC_MODEL', 'qwen3.5-plus')

    # Fix base URL: convert /apps/anthropic to /v1 for OpenAI SDK
    if '/apps/anthropic' in base_url:
        base_url = base_url.replace('/apps/anthropic', '/v1')
        print('[INFO] Converted base URL for OpenAI SDK compatibility')

    print("=" * 60)
    print("Testing Coding Plan API")
    print("=" * 60)
    print(f"Base URL: {base_url}")
    print(f"Model: {model}")
    print(f"API Key: {'*' * 10}{api_key[-6:] if api_key else 'NOT SET'}")
    print("-" * 60)

    if not api_key:
        print("[FAIL] ANTHROPIC_AUTH_TOKEN or ANTHROPIC_API_KEY not set")
        return False

    try:
        client = OpenAI(api_key=api_key, base_url=base_url)

        response = client.chat.completions.create(
            model=model,
            messages=[{'role': 'user', 'content': 'Hello! Please reply with "OK"'}],
            max_tokens=10
        )

        content = response.choices[0].message.content
        print(f"[OK] API Response: {content}")
        print("=" * 60)
        print("Coding Plan API test PASSED!")
        print("=" * 60)
        return True

    except Exception as e:
        print(f"[FAIL] Error: {e}")
        print("=" * 60)
        print("Coding Plan API test FAILED!")
        print("=" * 60)
        return False


if __name__ == "__main__":
    success = test_coding_plan_api()
    exit(0 if success else 1)
