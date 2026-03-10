#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Test main() API key detection."""

import os
import sys

print("=" * 60)
print("Testing API Key Detection in main()")
print("=" * 60)
print()

# 直接检查环境变量
env_token = os.environ.get("ANTHROPIC_AUTH_TOKEN")
env_api_key = os.environ.get("ANTHROPIC_API_KEY")

print("Environment variables:")
print(f"  ANTHROPIC_AUTH_TOKEN: {env_token[:25]}..." if env_token else "  ANTHROPIC_AUTH_TOKEN: NOT SET")
print(f"  ANTHROPIC_API_KEY: {env_api_key[:25]}..." if env_api_key else "  ANTHROPIC_API_KEY: NOT SET")
print()

# 模拟 main() 中的逻辑
anthropic_key = os.environ.get("ANTHROPIC_AUTH_TOKEN") or os.environ.get("ANTHROPIC_API_KEY")
print(f"Detected anthropic_key (using 'or'): {anthropic_key[:25]}..." if anthropic_key else "Detected anthropic_key: NOT SET")
print()

# 检查 sys.argv
print(f"sys.argv: {sys.argv}")
print(f"'--anthropic' in sys.argv: {'--anthropic' in sys.argv}")
