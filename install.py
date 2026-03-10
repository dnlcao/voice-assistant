#!/usr/bin/env python3
"""Install voice assistant dependencies."""

import subprocess
import sys

def install(package):
    """Install a package using pip."""
    print(f"Installing {package}...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])
        print(f"✓ {package} installed successfully!")
        return True
    except Exception as e:
        print(f"✗ Failed to install {package}: {e}")
        return False

def check_import(module_name, package_name=None):
    """Check if a module can be imported."""
    if package_name is None:
        package_name = module_name
    try:
        __import__(module_name)
        print(f"✓ {package_name} is already installed")
        return True
    except ImportError:
        return False

def main():
    print("=" * 50)
    print("Voice Assistant Dependency Installer")
    print("=" * 50)
    print()

    # Check and install packages
    packages = [
        ("speech_recognition", "speechrecognition"),
        ("anthropic", "anthropic"),
        ("pyttsx3", "pyttsx3"),
        ("pyaudio", "pyaudio"),
    ]

    all_installed = True
    for module, package in packages:
        if not check_import(module, package):
            if not install(package):
                all_installed = False
        print()

    print("=" * 50)
    if all_installed:
        print("✓ All packages installed successfully!")
        print()
        print("You can now run the voice assistant with:")
        print("  python voice_assistant.py")
    else:
        print("✗ Some packages failed to install.")
        print()
        print("For pyaudio issues on Windows:")
        print("1. Download prebuilt wheel from:")
        print("   https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio")
        print("2. Install with: pip install <downloaded_file.whl>")
    print("=" * 50)

    input("\nPress Enter to exit...")

if __name__ == "__main__":
    main()
