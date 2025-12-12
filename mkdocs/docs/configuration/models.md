# Model Configuration

Panduan konfigurasi AI models yang digunakan dalam sistem.

---

## 🤖 Overview Model yang Digunakan

| Model | Purpose | Size | Hardware | Speed |
|-------|---------|------|----------|-------|
| Whisper Large-v3 | Speech-to-Text | 3 GB | GPU (recommended) | Fast |
| Llama 3.1-8B | Assessment | API | Cloud | Medium |
| MediaPipe | Face Detection | 20 MB | CPU/GPU | Very Fast |
| Resemblyzer | Speaker Verification | 200 MB | CPU | Fast |

---

## 🎙️ Whisper Configuration

### Model Selection

Edit `payload_video.ipynb`:

```python
# Whisper model options
WHISPER_MODEL = "openai/whisper-large-v3"  # Best accuracy
# WHISPER_MODEL = "openai/whisper-medium"  # Balanced
# WHISPER_MODEL = "openai/whisper-small"   # Fastest
```

### Model Comparison

| Model | Size | Accuracy | Speed (GPU) | Memory |
|-------|------|----------|-------------|--------|
| large-v3 | 3 GB | 98% | ~1min/10min video | 6-8 GB |
| medium | 1.5 GB | 95% | ~30sec/10min video | 3-4 GB |
| small | 500 MB | 90% | ~15sec/10min video | 1-2 GB |

### Language-Specific Settings

```python
# For English
whisper_config = {
    "model": "openai/whisper-large-v3",
    "language": "en",
    "task": "transcribe"
}

# For Indonesian
whisper_config = {
    "model": "openai/whisper-large-v3",
    "language": "id",
    "task": "transcribe"
}
```

### Advanced Whisper Settings

```python
# Fine-tune parameters
whisper_params = {
    "chunk_length_s": 30,          # Audio chunk size
    "batch_size": 8,                # GPU batch size
    "return_timestamps": True,      # Word-level timestamps
    "temperature": 0.0,             # Sampling temperature
    "compression_ratio_threshold": 2.4,
    "logprob_threshold": -1.0,
    "no_speech_threshold": 0.6
}
```

---

## 🧠 LLM Configuration (Llama 3.1)

### API Setup

```python
# Hugging Face Inference API
LLM_MODEL = "meta-llama/Llama-3.1-8B-Instruct"
HF_API_KEY = "your_huggingface_api_key"
```

### Generation Parameters

```python
llm_params = {
    "max_new_tokens": 2048,      # Max response length
    "temperature": 0.7,           # Creativity (0.0-1.0)
    "top_p": 0.9,                 # Nucleus sampling
    "top_k": 50,                  # Top-k sampling
    "repetition_penalty": 1.1,    # Avoid repetition
    "do_sample": True             # Enable sampling
}
```

### Prompt Engineering

```python
# Custom assessment prompt
assessment_prompt = """
You are an expert HR interviewer. Analyze this interview transcription and provide:

1. Overall Score (0-10)
2. Category Scores:
   - Technical Skills
   - Communication
   - Problem Solving
   - Cultural Fit
3. Strengths (3-5 points)
4. Areas for Improvement (2-3 points)
5. Detailed Feedback (2-3 paragraphs)
6. Recommendation (Hire/Maybe/No)

Transcription:
{transcription}

Provide assessment in JSON format.
"""
```

### Alternative LLM Models

```python
# Option 1: Local Llama via Ollama
LLM_MODEL = "llama3.1:8b"
LLM_PROVIDER = "ollama"
OLLAMA_URL = "http://localhost:11434"

# Option 2: OpenAI GPT
LLM_MODEL = "gpt-4"
LLM_PROVIDER = "openai"
OPENAI_API_KEY = "your_openai_key"

# Option 3: Anthropic Claude
LLM_MODEL = "claude-3-sonnet"
LLM_PROVIDER = "anthropic"
ANTHROPIC_API_KEY = "your_anthropic_key"
```

---

## 👁️ MediaPipe Configuration

### Face Detection Settings

```python
import mediapipe as mp

face_detection_config = {
    "min_detection_confidence": 0.5,  # Detection threshold
    "model_selection": 0               # 0: < 2m, 1: full range
}

face_mesh_config = {
    "max_num_faces": 2,                # Max faces to detect
    "refine_landmarks": True,          # High-quality landmarks
    "min_detection_confidence": 0.5,
    "min_tracking_confidence": 0.5
}
```

### Face Mesh for Expression Analysis

```python
# Initialize Face Mesh
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(
    static_image_mode=False,
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)
```

### Pose Detection (Optional)

```python
mp_pose = mp.solutions.pose
pose = mp_pose.Pose(
    static_image_mode=False,
    model_complexity=1,          # 0, 1, or 2
    smooth_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)
```

---

## 🎤 Resemblyzer Configuration

### Speaker Embedding

```python
from resemblyzer import VoiceEncoder

# Initialize encoder
encoder = VoiceEncoder()

# Embed audio
embedding = encoder.embed_utterance(audio_clip)
```

### Speaker Diarization Settings

```python
diarization_config = {
    "min_speaker_duration": 5.0,    # Min seconds per speaker
    "max_speakers": 3,               # Max expected speakers
    "threshold": 0.75                # Similarity threshold
}
```

---

## ⚙️ Performance Optimization

### GPU Configuration

```python
import torch

# Check GPU availability
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Using device: {device}")

# GPU memory management
torch.cuda.empty_cache()

# Set GPU for specific model
whisper_model = whisper_model.to(device)
```

### Batch Processing

```python
# Process multiple videos efficiently
batch_config = {
    "batch_size": 4,              # Process 4 videos together
    "parallel_workers": 2,        # Parallel processing threads
    "gpu_memory_fraction": 0.8    # Use 80% of GPU memory
}
```

### CPU Optimization

```python
# For CPU-only environments
cpu_config = {
    "num_threads": 4,             # CPU threads
    "use_fp16": False,            # Don't use half precision
    "optimize_for_cpu": True
}
```

---

## 🔄 Model Updates

### Update Whisper Model

```bash
# Download specific version
pip install transformers==4.35.0

# Update model cache
python -c "from transformers import pipeline; \
           pipe = pipeline('automatic-speech-recognition', \
           model='openai/whisper-large-v3')"
```

### Update LLM Model

```python
# Change model version
LLM_MODEL = "meta-llama/Llama-3.1-70B-Instruct"  # Larger model

# Or switch provider
LLM_PROVIDER = "openai"
LLM_MODEL = "gpt-4-turbo"
```

---

## 💾 Model Caching

### Local Cache Directory

```python
import os

# Set cache directory
os.environ['HF_HOME'] = '/path/to/cache'
os.environ['TRANSFORMERS_CACHE'] = '/path/to/cache'

# Pre-download models
from transformers import AutoModel

AutoModel.from_pretrained(
    "openai/whisper-large-v3",
    cache_dir="/path/to/cache"
)
```

### Clear Cache

```bash
# Clear Hugging Face cache
rm -rf ~/.cache/huggingface/

# Clear pip cache
pip cache purge
```

---

## 📊 Model Monitoring

### Track Performance

```python
import time

def monitor_model_performance(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        result = func(*args, **kwargs)
        end_time = time.time()
        
        print(f"Function: {func.__name__}")
        print(f"Duration: {end_time - start_time:.2f}s")
        
        return result
    return wrapper

@monitor_model_performance
def transcribe_audio(audio_path):
    # Transcription code
    pass
```

---

## 🎯 Model Selection Guide

### Choose Based on Your Needs

**Priority: Accuracy**
```python
WHISPER_MODEL = "openai/whisper-large-v3"
LLM_MODEL = "meta-llama/Llama-3.1-70B-Instruct"
```

**Priority: Speed**
```python
WHISPER_MODEL = "openai/whisper-small"
LLM_MODEL = "meta-llama/Llama-3.1-8B-Instruct"
```

**Priority: Cost**
```python
WHISPER_MODEL = "openai/whisper-medium"
LLM_PROVIDER = "ollama"  # Run locally
```

**Priority: Balance**
```python
WHISPER_MODEL = "openai/whisper-large-v3"  # Best quality
LLM_MODEL = "meta-llama/Llama-3.1-8B-Instruct"  # Good enough
```

---

## 🔧 Troubleshooting Models

### Model Download Issues

```bash
# Manual download
huggingface-cli download openai/whisper-large-v3

# Check model availability
huggingface-cli scan-cache
```

### GPU Out of Memory

```python
# Reduce batch size
batch_size = 1

# Use smaller model
WHISPER_MODEL = "openai/whisper-medium"

# Clear GPU cache
torch.cuda.empty_cache()
```

### Slow Performance

```python
# Enable GPU
device = "cuda"

# Reduce precision
torch_dtype = torch.float16

# Optimize inference
torch.backends.cudnn.benchmark = True
```

---

## 📚 See Also

- [API Keys Configuration](api-keys.md)
- [Advanced Configuration](advanced.md)
- [Performance Tuning](../troubleshooting/performance.md)
