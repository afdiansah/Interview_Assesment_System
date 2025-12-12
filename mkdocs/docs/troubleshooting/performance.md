# Performance Tuning

Panduan optimasi performance untuk processing yang lebih cepat.

---

## ⚡ Performance Overview

### Expected Processing Times

**10-minute video:**

| Configuration | Time | Hardware |
|--------------|------|----------|
| CPU Only | 8-12 min | Intel i7/Ryzen 7 |
| GPU (GTX 1660) | 3-4 min | 6GB VRAM |
| GPU (RTX 3070) | 2-3 min | 8GB VRAM |
| GPU (RTX 4090) | 1-2 min | 24GB VRAM |

---

## 🚀 Quick Wins

### 1. Use GPU

**Check GPU availability:**

```python
import torch

print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA version: {torch.version.cuda}")
print(f"GPU: {torch.cuda.get_device_name(0)}")
```

**Install GPU PyTorch:**

```bash
# For CUDA 11.8
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# For CUDA 12.1
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

**Expected speedup:** 3-5x faster

---

### 2. Use Smaller Whisper Model

```python
# Fast but less accurate
WHISPER_MODEL = "openai/whisper-small"  # ~15s for 10min video

# Balanced
WHISPER_MODEL = "openai/whisper-medium"  # ~30s for 10min video

# Best quality
WHISPER_MODEL = "openai/whisper-large-v3"  # ~1min for 10min video
```

**Quality vs Speed tradeoff:**

| Model | Accuracy | Speed (GPU) | VRAM |
|-------|----------|-------------|------|
| small | 90% | Very Fast | 1 GB |
| medium | 95% | Fast | 3 GB |
| large-v3 | 98% | Medium | 6 GB |

---

### 3. Skip Unnecessary Stages

```python
# If you don't need cheating detection
SKIP_STAGES = ["cheating_detection", "non_verbal_analysis"]

# Savings: ~1-2 minutes per video
```

---

## 🔧 GPU Optimization

### Optimize GPU Memory

```python
import torch

# Clear cache before processing
torch.cuda.empty_cache()

# Use mixed precision (FP16)
torch.backends.cudnn.benchmark = True

# Limit memory usage
torch.cuda.set_per_process_memory_fraction(0.8, 0)
```

### Batch Processing

```python
# Process multiple videos in parallel
BATCH_CONFIG = {
    "batch_size": 4,  # Process 4 videos at once
    "num_workers": 2   # Parallel workers
}

# Expected speedup: 2-3x for multiple videos
```

### Monitor GPU Usage

```bash
# Watch GPU in real-time
watch -n 1 nvidia-smi

# Or in Python
import pynvml

pynvml.nvmlInit()
handle = pynvml.nvmlDeviceGetHandleByIndex(0)
info = pynvml.nvmlDeviceGetMemoryInfo(handle)
print(f"Used: {info.used / 1024**3:.2f} GB")
print(f"Free: {info.free / 1024**3:.2f} GB")
```

---

## 💾 Memory Optimization

### Reduce Memory Usage

```python
# Process in chunks
CHUNK_SIZE = 30  # seconds
OVERLAP = 5      # seconds overlap

def process_large_video(video_path):
    chunks = split_video(video_path, CHUNK_SIZE, OVERLAP)
    results = []
    
    for chunk in chunks:
        result = process_chunk(chunk)
        results.append(result)
        
        # Free memory after each chunk
        del chunk
        torch.cuda.empty_cache()
    
    return merge_results(results)
```

### Stream Processing

```python
# Don't load entire video into memory
def process_streaming(video_path):
    cap = cv2.VideoCapture(video_path)
    
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        
        # Process frame
        process_frame(frame)
        
        # Free frame immediately
        del frame
    
    cap.release()
```

---

## 📊 Video Preprocessing

### Reduce Video Size

```bash
# Reduce resolution to 720p
ffmpeg -i input.mp4 -vf scale=-2:720 -c:a copy output.mp4

# Reduce frame rate to 30fps
ffmpeg -i input.mp4 -r 30 output.mp4

# Compress video
ffmpeg -i input.mp4 -crf 23 -preset fast output.mp4
```

### Extract Audio Early

```bash
# Extract audio once, use for all stages
ffmpeg -i video.mp4 -vn -acodec pcm_s16le -ar 16000 -ac 1 audio.wav

# Savings: No need to extract audio multiple times
```

---

## 🎯 Stage-Specific Optimization

### 1. Transcription (Whisper)

```python
# Optimize Whisper inference
whisper_config = {
    "chunk_length_s": 30,      # Larger chunks
    "batch_size": 16,          # Larger batch size (if GPU has memory)
    "use_flash_attention": True  # Faster attention
}

# Use faster generation
generation_config = {
    "num_beams": 1,            # Greedy decoding (faster)
    "temperature": 0.0,        # Deterministic
}
```

**Expected speedup:** 20-30%

---

### 2. LLM Assessment

```python
# Cache prompts
from functools import lru_cache

@lru_cache(maxsize=100)
def get_assessment_cached(transcription_hash):
    return llm_assess(transcription)

# Use smaller context
max_tokens = 2048  # Instead of 4096

# Parallel API calls
import asyncio

async def assess_multiple(transcriptions):
    tasks = [assess_async(t) for t in transcriptions]
    return await asyncio.gather(*tasks)
```

**Expected speedup:** 40-50%

---

### 3. Cheating Detection

```python
# Skip frames
FRAME_SKIP = 10  # Analyze every 10th frame instead of every frame

# Use smaller face detection model
face_detection_config = {
    "model_selection": 0,  # Faster model
    "min_detection_confidence": 0.7  # Stricter threshold
}

# Downsample frames
frame = cv2.resize(frame, (640, 480))  # Instead of 1920x1080
```

**Expected speedup:** 50-60%

---

### 4. Non-Verbal Analysis

```python
# Reduce landmark tracking
face_mesh_config = {
    "refine_landmarks": False,  # Disable refinement
    "max_num_faces": 1          # Only track 1 face
}

# Sample frames
FPS_SAMPLE = 5  # Analyze 5 fps instead of 30 fps
```

**Expected speedup:** 40-50%

---

## 🔄 Parallel Processing

### Multi-Threading

```python
from concurrent.futures import ThreadPoolExecutor

def process_multiple_videos(video_paths):
    with ThreadPoolExecutor(max_workers=4) as executor:
        futures = [executor.submit(process_video, path) 
                  for path in video_paths]
        results = [f.result() for f in futures]
    return results
```

### Multi-Processing

```python
from multiprocessing import Pool, cpu_count

def process_batch(video_paths):
    num_cpus = cpu_count()
    with Pool(num_cpus) as pool:
        results = pool.map(process_video, video_paths)
    return results
```

---

## 💡 Caching Strategies

### 1. Result Caching

```python
import json
from pathlib import Path

def get_or_compute(session_id, compute_func):
    cache_file = f"cache/{session_id}.json"
    
    # Check cache
    if Path(cache_file).exists():
        with open(cache_file) as f:
            return json.load(f)
    
    # Compute and cache
    result = compute_func()
    Path("cache").mkdir(exist_ok=True)
    with open(cache_file, 'w') as f:
        json.dump(result, f)
    
    return result
```

### 2. Model Caching

```python
# Cache loaded models
_model_cache = {}

def get_model(model_name):
    if model_name not in _model_cache:
        print(f"Loading {model_name}...")
        _model_cache[model_name] = load_model(model_name)
    return _model_cache[model_name]
```

### 3. API Response Caching

```python
import hashlib

def cached_api_call(prompt, cache_dir="api_cache"):
    # Create hash of prompt
    prompt_hash = hashlib.md5(prompt.encode()).hexdigest()
    cache_file = f"{cache_dir}/{prompt_hash}.json"
    
    if Path(cache_file).exists():
        with open(cache_file) as f:
            return json.load(f)
    
    # Make API call
    response = api_call(prompt)
    
    # Cache response
    Path(cache_dir).mkdir(exist_ok=True)
    with open(cache_file, 'w') as f:
        json.dump(response, f)
    
    return response
```

---

## 📈 Benchmarking

### Measure Processing Time

```python
import time
from contextlib import contextmanager

@contextmanager
def timer(name):
    start = time.time()
    yield
    end = time.time()
    print(f"{name}: {end - start:.2f}s")

# Usage
with timer("Transcription"):
    transcription = transcribe_audio(audio_path)

with timer("LLM Assessment"):
    assessment = llm_assess(transcription)
```

### Profile Code

```python
import cProfile
import pstats

def profile_processing():
    profiler = cProfile.Profile()
    profiler.enable()
    
    # Your processing code
    process_video("video.mp4")
    
    profiler.disable()
    stats = pstats.Stats(profiler)
    stats.sort_stats('cumulative')
    stats.print_stats(20)  # Top 20 slowest functions
```

---

## 🎯 Performance Targets

### Optimization Goals

| Stage | Target (GPU) | Current | Improvement Needed |
|-------|-------------|---------|-------------------|
| Audio Extraction | < 10s | 15s | 33% |
| Transcription | < 60s | 90s | 33% |
| LLM Assessment | < 10s | 15s | 33% |
| Cheating Detection | < 30s | 45s | 33% |
| Non-Verbal | < 30s | 40s | 25% |
| **Total** | **< 3 min** | **4.5 min** | **33%** |

---

## 🔍 Monitoring Performance

### Real-Time Monitoring

```python
import psutil
import time

def monitor_resources():
    while True:
        cpu = psutil.cpu_percent()
        memory = psutil.virtual_memory().percent
        
        if torch.cuda.is_available():
            gpu_mem = torch.cuda.memory_allocated() / 1024**3
            print(f"CPU: {cpu}% | RAM: {memory}% | GPU: {gpu_mem:.2f}GB")
        
        time.sleep(1)
```

### Log Performance Metrics

```python
import logging

def log_performance(stage, duration, memory_used):
    logging.info(f"Stage: {stage}")
    logging.info(f"Duration: {duration:.2f}s")
    logging.info(f"Memory: {memory_used:.2f}GB")
    logging.info(f"Throughput: {video_duration/duration:.2f}x realtime")
```

---

## 📚 Best Practices

### ✅ DO

- Use GPU whenever possible
- Cache intermediate results
- Process in batches for multiple videos
- Monitor resource usage
- Profile code to find bottlenecks
- Use appropriate model sizes

### ❌ DON'T

- Load entire video into RAM
- Process all frames (skip frames when possible)
- Use largest models unnecessarily
- Forget to clear GPU cache
- Process videos sequentially (use parallelism)

---

## 🎓 Advanced Techniques

### 1. Quantization

```python
# Reduce model precision for speed
model = torch.quantization.quantize_dynamic(
    model,
    {torch.nn.Linear},
    dtype=torch.qint8
)

# Expected speedup: 2-3x with minimal accuracy loss
```

### 2. TensorRT Optimization

```bash
# Convert model to TensorRT for maximum speed
pip install tensorrt

# 2-4x faster inference on NVIDIA GPUs
```

### 3. ONNX Export

```python
# Export to ONNX for optimized inference
torch.onnx.export(
    model,
    dummy_input,
    "model.onnx",
    opset_version=14
)

# Use ONNX Runtime
import onnxruntime as ort
session = ort.InferenceSession("model.onnx")
```

---

## 📊 Performance Comparison

### Before vs After Optimization

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| 10-min video (GPU) | 8 min | 2.5 min | 3.2x |
| Memory usage | 12 GB | 6 GB | 50% |
| GPU utilization | 60% | 90% | 50% |
| Throughput | 1.25x | 4x | 3.2x |

---

## 📚 See Also

- [Common Issues](common-issues.md)
- [Advanced Configuration](../configuration/advanced.md)
- [Model Configuration](../configuration/models.md)
