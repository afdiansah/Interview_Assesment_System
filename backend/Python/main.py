import os

# Disable logging noise
os.environ["GLOG_minloglevel"] = "3"
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
os.environ["TF_ENABLE_ONEDNN_OPTS"] = "0"
os.environ["MEDIAPIPE_DISABLE_GPU"] = "1"

import logging

# ============================================================
# KONFIGURASI FFMPEG (Linux)
# ============================================================

# HuggingFace Spaces menggunakan Linux, jadi ekstensinya tidak .exe
os.environ["FFMPEG_BINARY"] = "ffmpeg"
os.environ["FFPROBE_BINARY"] = "ffprobe"

print("✅ FFmpeg set to system-installed version")

# ============================================================
# RUN APP
# ============================================================
from app.server import create_app
import uvicorn

app = create_app()

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=7860, reload=False)
