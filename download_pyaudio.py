import sys
import subprocess
import urllib.request
import os

def get_python_version():
    """Get Python version info."""
    major = sys.version_info.major
    minor = sys.version_info.minor
    return f"{major}.{minor}", major, minor

def download_pyaudio():
    """Download PyAudio wheel."""
    version_str, major, minor = get_python_version()
    print(f"Python version: {version_str}")
    print()

    # Map Python versions to download URLs
    urls = {
        (3, 9): "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp39-cp39-win_amd64.whl",
        (3, 10): "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp310-cp310-win_amd64.whl",
        (3, 11): "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp311-cp311-win_amd64.whl",
        (3, 12): "https://download.lfd.uci.edu/pythonlibs/archived/PyAudio-0.2.11-cp312-cp312-win_amd64.whl",
    }

    if (major, minor) not in urls:
        print(f"ERROR: Python {version_str} not supported.")
        print("Supported versions: 3.9, 3.10, 3.11, 3.12")
        return False

    url = urls[(major, minor)]
    filename = f"PyAudio-0.2.11-cp{major}{minor}-cp{major}{minor}-win_amd64.whl"

    print(f"Downloading PyAudio for Python {version_str}...")
    print(f"URL: {url}")
    print()

    try:
        urllib.request.urlretrieve(url, filename)
        print(f"Downloaded: {filename}")
        return filename
    except Exception as e:
        print(f"Download failed: {e}")
        print()
        print("Please manually download from:")
        print("https://www.lfd.uci.edu/~gohlke/pythonlibs/#pyaudio")
        return None

def install_pyaudio(filename):
    """Install the downloaded wheel."""
    print()
    print(f"Installing {filename}...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", filename])
        print()
        print("PyAudio installed successfully!")

        # Clean up
        os.remove(filename)
        print(f"Cleaned up {filename}")

        # Test import
        print()
        print("Testing import...")
        import pyaudio
        print("✓ PyAudio is working!")
        return True
    except Exception as e:
        print(f"Installation failed: {e}")
        return False

def main():
    print("=" * 50)
    print("PyAudio Installer for Windows")
    print("=" * 50)
    print()

    filename = download_pyaudio()
    if filename:
        install_pyaudio(filename)

    print()
    input("Press Enter to exit...")

if __name__ == "__main__":
    main()
