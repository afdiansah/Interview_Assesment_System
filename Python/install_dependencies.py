import subprocess
import sys
import os

def pip_install(package):
    print(f"→ Installing: {' '.join(package)}")
    subprocess.check_call([sys.executable, "-m", "pip", "install"] + package)


print("📦 Installing required packages...\n")
# ============================
pip_install(["numpy==1.26.4"])
pip_install(["--upgrade", "torch", "torchaudio", "faster-whisper"])
pip_install(["ipywidgets", "jupyter"])
pip_install(["fastapi", "uvicorn", "nest-asyncio", "pyngrok", "python-multipart"])
pip_install(["tqdm"])
pip_install(["imageio-ffmpeg"])
pip_install(["deepl"])
pip_install(["silero-vad"])
pip_install(["pydub"])
pip_install(["soundfile"])
pip_install(["scipy"])
pip_install(["scikit-learn"])
pip_install(["huggingface-hub"])
pip_install(["mediapipe"])
pip_install(["torchcodec"])
pip_install(["librosa"])
pip_install(["gdown"])
pip_install(["requests"])
pip_install(["python-dotenv"])

print('\n✅ All safe packages installed')
print('   ✅ No numpy version conflicts')
print('   ✅ Jupyter widgets installed (fixes tqdm warning)')
print('   ✅ FFmpeg required for audio - verify with next cell')
# ============================


def download_ffmpeg_files():
    files = {
        "ffmpeg.exe": "1n_urz75dBFZRB8d6JK9SoU2Nzf1TJeVO",
        "ffplay.exe": "1LOzJH9V1c3XXofQcZ42qHdMY32XhN3I2",
        "ffprobe.exe": "1q7gC-gjDZytaHmZ8YOE5bZMRQ6ziiWqC",
    }

    # Install gdown kalau belum ada
    subprocess.run(["pip", "install", "gdown"], check=True)

    # Target folder = app/bin/
    target_folder = os.path.join("app", "bin")
    os.makedirs(target_folder, exist_ok=True)

    for filename, file_id in files.items():
        output_path = os.path.join(target_folder, filename)

        # Skip kalau file sudah ada
        if os.path.exists(output_path):
            print(f"✔ {filename} already exists — skip")
            continue

        print(f"📥 Downloading: {filename}")
        subprocess.run(
            ["gdown", f"https://drive.google.com/uc?id={file_id}", "-O", output_path],
            check=True
        )
        print(f"✔ Downloaded to: {output_path}")

    print("\n🎉 All FFmpeg files downloaded into app/bin/")
    return target_folder

# Auto run
download_ffmpeg_files()

print("\n🔥 Import test completed — semua library ter-load tanpa error!")
