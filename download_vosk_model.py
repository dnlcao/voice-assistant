#!/usr/bin/env python3
"""
Download Vosk speech recognition models.
"""

import os
import sys
import zipfile
import urllib.request
from pathlib import Path

MODELS = {
    "cn": {
        "name": "Chinese Small Model",
        "url": "https://alphacephei.com/vosk/models/vosk-model-small-cn-0.22.zip",
        "size": "39 MB",
        "folder": "vosk-model-small-cn-0.22"
    },
    "en": {
        "name": "English US Small Model",
        "url": "https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip",
        "size": "40 MB",
        "folder": "vosk-model-small-en-us-0.15"
    },
    "en-big": {
        "name": "English US Large Model",
        "url": "https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip",
        "size": "1.8 GB",
        "folder": "vosk-model-en-us-0.22"
    }
}


def download_file(url: str, destination: str, chunk_size: int = 8192):
    """Download a file with progress."""
    print(f"Downloading from: {url}")
    print(f"Saving to: {destination}")

    def report_progress(block_num, block_size, total_size):
        downloaded = block_num * block_size
        percent = min(downloaded * 100 / total_size, 100)
        print(f"\rProgress: {percent:.1f}% ({downloaded // 1024 // 1024} MB / {total_size // 1024 // 1024} MB)", end="")

    try:
        urllib.request.urlretrieve(url, destination, reporthook=report_progress)
        print("\n[OK] Download complete!")
        return True
    except Exception as e:
        print(f"\n[X] Download failed: {e}")
        return False


def extract_zip(zip_path: str, extract_to: str):
    """Extract a zip file."""
    print(f"Extracting {zip_path}...")
    try:
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(extract_to)
        print("[OK] Extraction complete!")
        return True
    except Exception as e:
        print(f"[X] Extraction failed: {e}")
        return False


def main():
    print("=" * 60)
    print("Vosk Model Downloader")
    print("=" * 60)
    print()

    # Show available models
    print("Available models:")
    for key, info in MODELS.items():
        print(f"  [{key}] {info['name']} ({info['size']})")
    print()

    # Get user choice
    if len(sys.argv) > 1:
        choice = sys.argv[1]
    else:
        choice = input("Enter model code (default: cn for Chinese): ").strip() or "cn"

    if choice not in MODELS:
        print(f"[X] Invalid choice: {choice}")
        print(f"Valid options: {', '.join(MODELS.keys())}")
        sys.exit(1)

    model_info = MODELS[choice]
    zip_filename = f"{model_info['folder']}.zip"

    # Check if already exists
    if os.path.exists(model_info['folder']):
        print(f"[!] Model folder already exists: {model_info['folder']}")
        overwrite = input("Overwrite? (y/N): ").strip().lower()
        if overwrite != 'y':
            print("Download cancelled.")
            return

    # Download
    print(f"\n[*] Downloading {model_info['name']}...")
    if not download_file(model_info['url'], zip_filename):
        sys.exit(1)

    # Extract
    print()
    if not extract_zip(zip_filename, "."):
        sys.exit(1)

    # Cleanup
    print()
    cleanup = input("Delete zip file? (Y/n): ").strip().lower()
    if cleanup != 'n':
        os.remove(zip_filename)
        print("[OK] Zip file deleted")

    print()
    print("=" * 60)
    print("[OK] Model ready!")
    print(f"   Location: ./{model_info['folder']}")
    print()
    print("You can now run the voice assistant:")
    print(f"  python voice_assistant_kimi.py")
    print("=" * 60)


if __name__ == "__main__":
    main()
