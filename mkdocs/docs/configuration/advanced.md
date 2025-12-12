# Advanced Configuration

Konfigurasi advanced untuk customization dan optimization.

---

## ⚙️ Server Configuration

### FastAPI Settings

```python
# Server configuration
SERVER_CONFIG = {
    "host": "0.0.0.0",
    "port": 8000,
    "reload": True,  # Auto-reload on code changes
    "workers": 4,     # Number of worker processes
    "log_level": "info"
}

# Run server
import uvicorn
uvicorn.run("main:app", **SERVER_CONFIG)
```

### CORS Configuration

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 📁 File Storage Configuration

### Local Storage

```python
STORAGE_CONFIG = {
    "base_path": "d:/Interview_Assesment_System-ngrok-raifal",
    "uploads_folder": "uploads",
    "results_folder": "results",
    "transcriptions_folder": "transcriptions",
    "temp_folder": "temp"
}

# Max file sizes
MAX_FILE_SIZE_MB = 500
MAX_DURATION_SECONDS = 3600  # 1 hour
```

### Google Drive Integration

```python
# Google Drive configuration
GDRIVE_CONFIG = {
    "enabled": True,
    "credentials_file": "credentials.json",
    "folder_id": "your_folder_id_here",
    "auto_upload": True,
    "keep_local": False  # Delete local after upload
}
```

Setup Google Drive:

```bash
# Install gdown
pip install gdown google-api-python-client

# Upload credentials.json to project root
```

---

## 🎯 Processing Pipeline Configuration

### Pipeline Stages

```python
PIPELINE_CONFIG = {
    "stages": [
        "extract_audio",
        "transcribe",
        "translate",
        "llm_assessment",
        "cheating_detection",
        "non_verbal_analysis",
        "save_results"
    ],
    "skip_stages": [],  # Stages to skip
    "parallel_processing": True
}
```

### Stage-Specific Settings

```python
# Audio extraction
AUDIO_CONFIG = {
    "format": "wav",
    "sample_rate": 16000,
    "channels": 1  # Mono
}

# Transcription
TRANSCRIPTION_CONFIG = {
    "chunk_size_seconds": 30,
    "overlap_seconds": 5,
    "enable_diarization": True,
    "min_speaker_duration": 5.0
}

# Cheating detection
CHEATING_CONFIG = {
    "frame_skip": 5,  # Analyze every 5th frame
    "face_confidence_threshold": 0.5,
    "max_faces_allowed": 1,
    "looking_away_threshold": 45  # degrees
}
```

---

## 🚀 Performance Optimization

### GPU Configuration

```python
import torch

GPU_CONFIG = {
    "enabled": torch.cuda.is_available(),
    "device_id": 0,  # GPU index
    "memory_fraction": 0.8,  # Use 80% of GPU memory
    "mixed_precision": True  # FP16 for speed
}

# Apply configuration
if GPU_CONFIG["enabled"]:
    torch.cuda.set_device(GPU_CONFIG["device_id"])
    torch.cuda.set_per_process_memory_fraction(
        GPU_CONFIG["memory_fraction"],
        GPU_CONFIG["device_id"]
    )
```

### Multiprocessing

```python
from multiprocessing import Pool

MULTIPROCESSING_CONFIG = {
    "enabled": True,
    "num_workers": 4,  # CPU cores
    "chunk_size": 1
}

# Process multiple videos
def process_multiple_videos(video_paths):
    with Pool(MULTIPROCESSING_CONFIG["num_workers"]) as pool:
        results = pool.map(process_video, video_paths)
    return results
```

### Caching

```python
from functools import lru_cache

CACHE_CONFIG = {
    "enabled": True,
    "max_size": 100,  # Cache 100 items
    "ttl_seconds": 3600  # 1 hour expiry
}

# Cache transcriptions
@lru_cache(maxsize=CACHE_CONFIG["max_size"])
def get_transcription(session_id):
    # Load from cache or compute
    pass
```

---

## 📊 Logging Configuration

### Setup Logging

```python
import logging
from logging.handlers import RotatingFileHandler

LOGGING_CONFIG = {
    "level": "INFO",  # DEBUG, INFO, WARNING, ERROR
    "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    "file": "logs/app.log",
    "max_bytes": 10_000_000,  # 10 MB
    "backup_count": 5
}

# Setup logger
logging.basicConfig(
    level=getattr(logging, LOGGING_CONFIG["level"]),
    format=LOGGING_CONFIG["format"],
    handlers=[
        RotatingFileHandler(
            LOGGING_CONFIG["file"],
            maxBytes=LOGGING_CONFIG["max_bytes"],
            backupCount=LOGGING_CONFIG["backup_count"]
        ),
        logging.StreamHandler()  # Also print to console
    ]
)

logger = logging.getLogger(__name__)
```

### Structured Logging

```python
import json
from datetime import datetime

def log_processing(session_id, stage, status, duration=None):
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "session_id": session_id,
        "stage": stage,
        "status": status,
        "duration_seconds": duration
    }
    logger.info(json.dumps(log_entry))
```

---

## 🔒 Security Configuration

### Rate Limiting

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)

RATE_LIMIT_CONFIG = {
    "upload": "10/hour",
    "results": "100/hour",
    "status": "60/minute"
}

@app.post("/upload")
@limiter.limit(RATE_LIMIT_CONFIG["upload"])
async def upload_video(request: Request):
    pass
```

### Input Validation

```python
from pydantic import BaseModel, validator

class VideoUpload(BaseModel):
    language: str
    
    @validator('language')
    def validate_language(cls, v):
        if v not in ['en', 'id']:
            raise ValueError('Language must be en or id')
        return v
```

---

## 🌐 Translation Configuration

### DeepL Settings

```python
TRANSLATION_CONFIG = {
    "provider": "deepl",
    "source_lang": "auto",  # Auto-detect
    "preserve_formatting": True,
    "formality": "default",  # default, more, less
    "cache_translations": True
}
```

### Fallback Translation

```python
# Use Google Translate as fallback
from googletrans import Translator

def translate_with_fallback(text, target_lang):
    try:
        # Try DeepL first
        result = deepl_translator.translate_text(
            text,
            target_lang=target_lang
        )
        return result.text
    except Exception as e:
        # Fallback to Google Translate
        logger.warning(f"DeepL failed, using Google Translate: {e}")
        translator = Translator()
        result = translator.translate(text, dest=target_lang)
        return result.text
```

---

## 📈 Monitoring Configuration

### Metrics Collection

```python
from prometheus_client import Counter, Histogram

METRICS_CONFIG = {
    "enabled": True,
    "port": 9090
}

# Define metrics
upload_counter = Counter('videos_uploaded', 'Total videos uploaded')
processing_time = Histogram('processing_duration_seconds', 'Processing time')

# Track metrics
@processing_time.time()
def process_video(video_path):
    upload_counter.inc()
    # Processing logic
    pass
```

### Health Checks

```python
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "gpu_available": torch.cuda.is_available(),
        "disk_space_gb": get_disk_space(),
        "memory_usage_percent": get_memory_usage()
    }
```

---

## 🎨 UI Configuration

### Dashboard Settings

```python
DASHBOARD_CONFIG = {
    "theme": "dark",  # dark or light
    "language": "auto",  # auto, en, id
    "auto_refresh": True,
    "refresh_interval_seconds": 5,
    "show_debug_info": False
}
```

### Visualization

```python
VISUALIZATION_CONFIG = {
    "chart_library": "plotly",  # plotly, matplotlib
    "color_scheme": "viridis",
    "figure_size": (12, 6),
    "dpi": 100
}
```

---

## 🔄 Backup Configuration

### Automatic Backups

```python
BACKUP_CONFIG = {
    "enabled": True,
    "schedule": "daily",  # daily, weekly
    "retention_days": 30,
    "backup_path": "backups/",
    "include": [
        "results/",
        "transcriptions/",
        "logs/"
    ]
}
```

### Backup Script

```python
import shutil
from datetime import datetime

def create_backup():
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = f"{BACKUP_CONFIG['backup_path']}/backup_{timestamp}"
    
    for folder in BACKUP_CONFIG['include']:
        shutil.copytree(folder, f"{backup_dir}/{folder}")
    
    logger.info(f"Backup created: {backup_dir}")
```

---

## 🧪 Development vs Production

### Development Config

```python
DEV_CONFIG = {
    "debug": True,
    "reload": True,
    "log_level": "DEBUG",
    "mock_api_calls": False,
    "save_intermediate_results": True
}
```

### Production Config

```python
PROD_CONFIG = {
    "debug": False,
    "reload": False,
    "log_level": "INFO",
    "enable_rate_limiting": True,
    "use_https": True,
    "compress_responses": True
}
```

### Environment Detection

```python
import os

ENV = os.getenv("ENVIRONMENT", "development")

if ENV == "production":
    CONFIG = PROD_CONFIG
else:
    CONFIG = DEV_CONFIG
```

---

## 📦 Export Configuration

### Export Formats

```python
EXPORT_CONFIG = {
    "formats": ["json", "csv", "pdf"],
    "default_format": "json",
    "include_metadata": True,
    "compress": True  # Zip files
}
```

### Generate Report

```python
def export_results(session_id, format="json"):
    results = get_results(session_id)
    
    if format == "json":
        return json.dumps(results, indent=2)
    elif format == "csv":
        return convert_to_csv(results)
    elif format == "pdf":
        return generate_pdf_report(results)
```

---

## 🔧 Custom Configuration File

Create `config.yaml`:

```yaml
server:
  host: 0.0.0.0
  port: 8000
  workers: 4

models:
  whisper: openai/whisper-large-v3
  llm: meta-llama/Llama-3.1-8B-Instruct

processing:
  max_file_size_mb: 500
  max_duration_seconds: 3600
  gpu_enabled: true

storage:
  local_path: ./data
  google_drive:
    enabled: false
    folder_id: null

security:
  rate_limiting: true
  api_key_required: false
```

Load config:

```python
import yaml

def load_config(config_file="config.yaml"):
    with open(config_file, 'r') as f:
        config = yaml.safe_load(f)
    return config

CONFIG = load_config()
```

---

## 📚 See Also

- [Model Configuration](models.md)
- [API Keys](api-keys.md)
- [Performance Tuning](../troubleshooting/performance.md)
