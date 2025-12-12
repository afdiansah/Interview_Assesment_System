# Installation Guide

This guide will walk you through installing and setting up the AI Interview Assessment System.

## Prerequisites

Before you begin, ensure you have:

- [x] Python 3.11 installed
- [x] pip (Python package manager)
- [x] Git (for cloning repository)
- [x] 10GB+ free disk space
- [x] Stable internet connection

### Optional but Recommended

- NVIDIA GPU with CUDA support (for faster processing)
- Virtual environment tool (venv, conda)

---

## Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/Interview_Assesment_System-ngrok-raifal.git

# Navigate to project directory
cd Interview_Assesment_System-ngrok-raifal
```

---

## Step 2: Create Virtual Environment

=== "Windows"

    ```powershell
    # Create virtual environment
    python -m venv .venv
    
    # Activate virtual environment
    .venv\Scripts\activate
    
    # Verify activation (should show (.venv) prefix)
    ```

=== "macOS/Linux"

    ```bash
    # Create virtual environment
    python3 -m venv .venv
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Verify activation (should show (.venv) prefix)
    ```

---

## Step 3: Install Dependencies

### Core Packages

```bash
# Update pip
pip install --upgrade pip

# Install core packages
pip install fastapi uvicorn nest-asyncio pyngrok python-multipart
pip install tqdm ipywidgets jupyter imageio-ffmpeg
```

### AI/ML Packages

```bash
# Speech recognition & translation
pip install faster-whisper deepl silero-vad huggingface-hub

# Computer vision & audio analysis
pip install mediapipe resemblyzer moviepy
pip install pydub soundfile scipy scikit-learn librosa

# Additional tools
pip install gdown requests torchcodec
```

### PyTorch & NumPy

!!! warning "Important"
    Install specific versions to avoid compatibility issues:

```bash
# NumPy (specific version)
pip install numpy==1.26.4

# PyTorch (CPU version)
pip install torch torchaudio

# Or PyTorch (GPU version with CUDA 11.8)
pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu118
```

---

## Step 4: Install FFmpeg

FFmpeg is **required** for audio extraction and processing.

=== "Windows"

    1. Download FFmpeg from [GitHub Releases](https://github.com/GyanD/codexffmpeg/releases)
    2. Extract to `C:\ffmpeg`
    3. Add `C:\ffmpeg\bin` to System PATH:
        - Right-click "This PC" → Properties
        - Advanced system settings → Environment Variables
        - Edit "Path" → Add `C:\ffmpeg\bin`
    4. Verify installation:
    
    ```powershell
    ffmpeg -version
    ```

=== "macOS"

    ```bash
    # Install via Homebrew
    brew install ffmpeg
    
    # Verify installation
    ffmpeg -version
    ```

=== "Linux (Ubuntu/Debian)"

    ```bash
    # Install via apt
    sudo apt update
    sudo apt install ffmpeg
    
    # Verify installation
    ffmpeg -version
    ```

---

## Step 5: Configure API Keys

### DeepL API (Translation)

1. Sign up at [DeepL Pro API](https://www.deepl.com/pro-api)
2. Get FREE API key (500,000 chars/month)
3. Open `payload_video.ipynb` in Jupyter
4. Find the cell with `DEEPL_API_KEY` and update:

```python
DEEPL_API_KEY = "YOUR_API_KEY_HERE:fx"
```

### Hugging Face API (LLM Assessment)

1. Sign up at [Hugging Face](https://huggingface.co/join)
2. Generate API token at [Settings → Tokens](https://huggingface.co/settings/tokens)
   - Select **READ** access (sufficient for inference)
3. Find the cell with `HF_TOKEN` and update:

```python
HF_TOKEN = "hf_xxxxxxxxxxxxxxxxxxxx"
client = InferenceClient(api_key=HF_TOKEN)
```

!!! tip "Free Tier Benefits"
    - Model: meta-llama/Llama-3.1-8B-Instruct
    - Unlimited requests (rate-limited ~30 req/min)
    - No credit card required
    - Automatic fallback to rule-based scoring if API fails

---

## Step 6: Start Backend Server

### Option A: Jupyter Notebook (Recommended)

```bash
# Install Jupyter if not already installed
pip install jupyter

# Launch Jupyter Notebook
jupyter notebook payload_video.ipynb
```

In the Jupyter interface:

1. **Execute cells in order** (Run All or Shift+Enter per cell):
   - Cell 1: Install dependencies
   - Cell 2: Import libraries
   - Cell 3: Setup directories
   - Cell 4: Initialize Whisper Model (~3GB download on first run)
   - Cell 5: Initialize Voice Encoder (Resemblyzer)
   - Cell 6: Initialize DeepL translator
   - Cell 7: Initialize Hugging Face LLM client
   - Cell 8-13: Load analysis functions
   - Cell 14: Define FastAPI app & endpoints
   - Cell 15: Start server

2. **Server will start on** `http://localhost:8888`

### Option B: Direct Python (Advanced)

```bash
# Not recommended - use Jupyter for better control
uvicorn payload_video:app --host 0.0.0.0 --port 8888
```

---

## Step 7: Start Frontend

=== "VS Code Live Server"

    1. Install "Live Server" extension in VS Code
    2. Right-click `Upload.html`
    3. Select "Open with Live Server"
    4. Frontend opens at `http://127.0.0.1:5500/Upload.html`

=== "Python HTTP Server"

    ```bash
    # In project root directory
    python -m http.server 5500
    ```
    
    Open browser: `http://localhost:5500/Upload.html`

---

## Verification

### Test Backend

Visit `http://localhost:8888/docs` to see FastAPI interactive documentation.

### Test Frontend

1. Open `http://localhost:5500/Upload.html`
2. Upload a test video (or use Google Drive URL)
3. Monitor processing in Jupyter Notebook terminal
4. View results in dashboard

---

## GPU Setup (Optional)

For faster processing with NVIDIA GPU:

### Install CUDA Toolkit

1. Download [CUDA Toolkit 11.8](https://developer.nvidia.com/cuda-11-8-0-download-archive)
2. Install following the wizard
3. Verify installation:

```bash
nvcc --version
```

### Install cuDNN

1. Download [cuDNN 8.x for CUDA 11.8](https://developer.nvidia.com/cudnn)
2. Extract and copy files to CUDA installation directory
3. Verify PyTorch CUDA support:

```python
import torch
print(torch.cuda.is_available())  # Should return True
print(torch.cuda.get_device_name(0))  # Shows GPU name
```

---

## Troubleshooting Installation

### ModuleNotFoundError

```bash
# Reinstall the missing package
pip install <package-name>
```

### FFmpeg Not Found

```bash
# Windows: Add to PATH manually or use this in notebook
import os
os.environ["PATH"] += os.pathsep + r"C:\ffmpeg\bin"
```

### Port Already in Use

```bash
# Kill process using port 8888 (Windows)
netstat -ano | findstr :8888
taskkill /PID <PID> /F

# Or use different port in notebook
import uvicorn
uvicorn.run(app, host="0.0.0.0", port=8889)
```

### CUDA Out of Memory

```python
# Use CPU mode instead
device = "cpu"
compute_type = "int8"
```

---

## Next Steps

Installation complete! Now learn how to use the system:

[Quick Start Guide](quickstart.md){ .md-button .md-button--primary }
