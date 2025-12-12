# Common Issues & Solutions

Solusi untuk masalah-masalah yang sering terjadi.

---

## 🔴 Installation Issues

### Issue: pip install fails

**Symptoms:**
```
ERROR: Could not find a version that satisfies the requirement...
```

**Solutions:**

```bash
# Update pip
python -m pip install --upgrade pip

# Use specific version
pip install torch==2.0.1

# Install with no cache
pip install --no-cache-dir package_name
```

---

### Issue: Virtual environment not working

**Symptoms:**
```
'python' is not recognized as an internal or external command
```

**Solutions:**

```powershell
# Recreate virtual environment
Remove-Item -Recurse -Force .venv
py -3.11 -m venv .venv

# Activate without script execution
.venv\Scripts\python.exe -m pip install --upgrade pip

# Run commands with full path
.venv\Scripts\python.exe your_script.py
```

---

### Issue: FFmpeg not found

**Symptoms:**
```
FileNotFoundError: ffmpeg not found
```

**Solutions:**

**Windows:**
```powershell
# Install via Chocolatey
choco install ffmpeg

# Or download from https://ffmpeg.org/download.html
# Add to PATH: C:\ffmpeg\bin
```

**macOS:**
```bash
brew install ffmpeg
```

**Linux:**
```bash
sudo apt-get install ffmpeg
```

Verify:
```bash
ffmpeg -version
```

---

## 🎙️ Audio/Video Issues

### Issue: Video upload fails

**Symptoms:**
```
ERROR: Invalid file format
```

**Solutions:**

1. **Check file format:**
   ```python
   from pathlib import Path
   file_path = "interview.mp4"
   print(f"Extension: {Path(file_path).suffix}")
   # Must be: .mp4, .avi, .mov, .mkv
   ```

2. **Convert video:**
   ```bash
   # Convert to MP4
   ffmpeg -i input.avi -c:v libx264 -c:a aac output.mp4
   ```

3. **Check file size:**
   ```python
   import os
   size_mb = os.path.getsize("video.mp4") / (1024 * 1024)
   print(f"Size: {size_mb:.2f} MB")
   # Must be < 500 MB
   ```

---

### Issue: No audio in transcription

**Symptoms:**
```
Transcription returns empty text
```

**Solutions:**

1. **Check audio track:**
   ```bash
   ffmpeg -i video.mp4
   # Look for: "Audio: aac" or "Audio: mp3"
   ```

2. **Extract audio manually:**
   ```bash
   ffmpeg -i video.mp4 -vn -acodec copy audio.aac
   ```

3. **Test audio quality:**
   ```python
   import librosa
   y, sr = librosa.load("audio.wav", sr=16000)
   print(f"Duration: {len(y)/sr:.2f}s")
   print(f"Sample rate: {sr}")
   ```

---

### Issue: Poor transcription quality

**Symptoms:**
```
Transcription has many errors or wrong words
```

**Solutions:**

1. **Improve audio quality:**
   ```bash
   # Reduce noise
   ffmpeg -i noisy.mp4 -af "highpass=f=200, lowpass=f=3000" clean.mp4
   
   # Normalize volume
   ffmpeg -i quiet.mp4 -af "volume=2.0" louder.mp4
   ```

2. **Use larger Whisper model:**
   ```python
   WHISPER_MODEL = "openai/whisper-large-v3"  # Best quality
   ```

3. **Adjust Whisper parameters:**
   ```python
   whisper_params = {
       "temperature": 0.0,  # More deterministic
       "compression_ratio_threshold": 2.4,
       "logprob_threshold": -1.0,
       "no_speech_threshold": 0.6
   }
   ```

---

## 🤖 Model & API Issues

### Issue: Hugging Face API key invalid

**Symptoms:**
```
401 Unauthorized: Invalid API key
```

**Solutions:**

1. **Verify API key:**
   ```python
   import os
   from dotenv import load_dotenv
   
   load_dotenv()
   key = os.getenv('HUGGINGFACE_API_KEY')
   
   print(f"Key starts with 'hf_': {key.startswith('hf_')}")
   print(f"Key length: {len(key)}")  # Should be ~37 characters
   ```

2. **Test API key:**
   ```bash
   curl https://huggingface.co/api/whoami-v2 \
     -H "Authorization: Bearer hf_your_key_here"
   ```

3. **Regenerate key:**
   - Go to https://huggingface.co/settings/tokens
   - Revoke old token
   - Create new token with Read access

---

### Issue: DeepL translation fails

**Symptoms:**
```
403 Forbidden: Authentication failed
```

**Solutions:**

1. **Check API key format:**
   ```python
   key = os.getenv('DEEPL_API_KEY')
   print(f"Key ends with ':fx': {key.endswith(':fx')}")
   ```

2. **Verify quota:**
   ```python
   import deepl
   translator = deepl.Translator(key)
   usage = translator.get_usage()
   print(f"Used: {usage.character.count}/{usage.character.limit}")
   ```

3. **Use fallback:**
   ```python
   # Fallback to no translation
   if translation_fails:
       return original_text  # Use English as-is
   ```

---

### Issue: GPU out of memory

**Symptoms:**
```
CUDA out of memory
```

**Solutions:**

1. **Clear GPU cache:**
   ```python
   import torch
   torch.cuda.empty_cache()
   ```

2. **Reduce batch size:**
   ```python
   batch_size = 1  # Process one at a time
   ```

3. **Use smaller model:**
   ```python
   WHISPER_MODEL = "openai/whisper-medium"  # Instead of large
   ```

4. **Use CPU:**
   ```python
   device = "cpu"
   model = model.to(device)
   ```

5. **Monitor GPU:**
   ```bash
   # Windows
   nvidia-smi
   
   # Check memory
   nvidia-smi --query-gpu=memory.used,memory.total --format=csv
   ```

---

## 🌐 Server Issues

### Issue: Port 8000 already in use

**Symptoms:**
```
OSError: [Errno 98] Address already in use
```

**Solutions:**

1. **Find process using port:**
   ```powershell
   # Windows
   netstat -ano | findstr :8000
   
   # Kill process
   taskkill /PID <PID> /F
   ```

2. **Use different port:**
   ```python
   uvicorn.run("main:app", host="0.0.0.0", port=8001)
   ```

3. **Stop all Python processes:**
   ```powershell
   Get-Process python | Stop-Process -Force
   ```

---

### Issue: Cannot access server remotely

**Symptoms:**
```
Connection refused when accessing from another device
```

**Solutions:**

1. **Bind to 0.0.0.0:**
   ```python
   uvicorn.run("main:app", host="0.0.0.0", port=8000)
   ```

2. **Check firewall:**
   ```powershell
   # Windows: Allow port 8000
   netsh advfirewall firewall add rule name="FastAPI" dir=in action=allow protocol=TCP localport=8000
   ```

3. **Use ngrok:**
   ```bash
   ngrok http 8000
   # Access via: https://xxxxx.ngrok.io
   ```

---

### Issue: Slow processing

**Symptoms:**
```
Processing takes > 30 minutes for 10-minute video
```

**Solutions:**

1. **Use GPU:**
   ```python
   import torch
   print(f"GPU available: {torch.cuda.is_available()}")
   
   # If False, install CUDA-enabled PyTorch
   ```

2. **Install GPU PyTorch:**
   ```bash
   # CUDA 11.8
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
   
   # CUDA 12.1
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
   ```

3. **Reduce video size:**
   ```bash
   # Reduce resolution to 720p
   ffmpeg -i input.mp4 -vf scale=-2:720 output.mp4
   
   # Reduce frame rate to 30fps
   ffmpeg -i input.mp4 -r 30 output.mp4
   ```

4. **Skip unnecessary stages:**
   ```python
   PIPELINE_CONFIG = {
       "skip_stages": ["non_verbal_analysis"]  # Skip if not needed
   }
   ```

---

## 📂 File & Path Issues

### Issue: FileNotFoundError

**Symptoms:**
```
FileNotFoundError: [Errno 2] No such file or directory
```

**Solutions:**

1. **Use absolute paths:**
   ```python
   from pathlib import Path
   
   base_path = Path(__file__).parent
   file_path = base_path / "results" / "output.json"
   ```

2. **Create directories:**
   ```python
   import os
   os.makedirs("results", exist_ok=True)
   ```

3. **Check path separators:**
   ```python
   # Use Path for cross-platform compatibility
   from pathlib import Path
   path = Path("d:/Interview_Assesment_System-ngrok-raifal/results")
   ```

---

### Issue: Permission denied

**Symptoms:**
```
PermissionError: [Errno 13] Permission denied
```

**Solutions:**

1. **Run as Administrator** (Windows)

2. **Check file permissions:**
   ```powershell
   # Windows
   icacls file.txt
   
   # Grant full control
   icacls file.txt /grant Everyone:F
   ```

3. **Close file handles:**
   ```python
   with open(file_path, 'w') as f:
       f.write(content)
   # File automatically closed after 'with' block
   ```

---

## 🔄 Processing Issues

### Issue: Session not found

**Symptoms:**
```
404 Not Found: Session ID does not exist
```

**Solutions:**

1. **Check session ID:**
   ```python
   # List all sessions
   sessions = os.listdir("results/")
   print("Available sessions:", sessions)
   ```

2. **Wait for processing:**
   ```python
   import time
   while True:
       status = get_status(session_id)
       if status == "completed":
           break
       time.sleep(5)
   ```

3. **Check session expiry:**
   ```python
   # Sessions expire after 7 days
   from datetime import datetime, timedelta
   expiry = datetime.now() - timedelta(days=7)
   ```

---

### Issue: Results incomplete

**Symptoms:**
```
Some fields missing in results JSON
```

**Solutions:**

1. **Wait for completion:**
   ```python
   status = get_status(session_id)
   print(f"Progress: {status['progress']['percentage']}%")
   ```

2. **Check for errors:**
   ```python
   if "error" in results:
       print(f"Error: {results['error']}")
   ```

3. **Retry processing:**
   ```python
   # Delete and re-upload
   delete_session(session_id)
   new_session = upload_video(video_path)
   ```

---

## 💻 Environment Issues

### Issue: Module not found

**Symptoms:**
```
ModuleNotFoundError: No module named 'module_name'
```

**Solutions:**

1. **Install module:**
   ```bash
   pip install module_name
   ```

2. **Check virtual environment:**
   ```powershell
   # Make sure you're in venv
   .venv\Scripts\python.exe -m pip list
   ```

3. **Reinstall dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

---

### Issue: Python version mismatch

**Symptoms:**
```
SyntaxError: invalid syntax (Python 3.9 required)
```

**Solutions:**

1. **Check Python version:**
   ```bash
   python --version
   # Must be 3.11+
   ```

2. **Use py launcher:**
   ```bash
   py -3.11 --version
   ```

3. **Recreate venv with correct version:**
   ```bash
   py -3.11 -m venv .venv
   ```

---

## 📚 Additional Resources

- [Error Codes Reference](../api/errors.md)
- [Performance Tuning](performance.md)
- [FAQ](faq.md)
- [GitHub Issues](https://github.com/your-repo/issues)

---

## 🆘 Still Having Issues?

1. **Check logs:**
   ```bash
   tail -f logs/app.log
   ```

2. **Enable debug mode:**
   ```python
   DEBUG = True
   LOG_LEVEL = "DEBUG"
   ```

3. **Create GitHub issue with:**
   - Error message (full traceback)
   - Steps to reproduce
   - System info (OS, Python version, GPU)
   - Log files

---

**Need more help?** Open an issue or contact support! 💬
