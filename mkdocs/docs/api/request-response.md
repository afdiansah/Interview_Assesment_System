# Request & Response Format

Detail format request dan response untuk setiap endpoint.

---

## 📤 Upload Request Details

### Video Upload Format

**Supported Video Formats:**

- MP4 (recommended)
- AVI
- MOV
- MKV
- WebM

**Video Requirements:**

| Property           | Requirement       | Recommended       |
| ------------------ | ----------------- | ----------------- |
| Max File Size      | 500 MB            | < 200 MB          |
| Max Duration       | 60 minutes        | 10-30 minutes     |
| Resolution         | Any               | 720p - 1080p      |
| Codec              | H.264/H.265       | H.264             |
| Audio              | Required          | Stereo, 44.1kHz   |
| Frame Rate         | 15-60 fps         | 30 fps            |

**Language Codes:**

- `en` - English
- `id` - Indonesian (Bahasa Indonesia)

---

## 📊 Response Format

### Standard Success Response

```json
{
  "status": "success",
  "data": {
    // ... response data
  },
  "timestamp": "2025-12-12T10:30:00Z",
  "request_id": "req_abc123"
}
```

### Standard Error Response

```json
{
  "status": "error",
  "error": {
    "code": "INVALID_FILE",
    "message": "Video file format not supported",
    "details": {
      "provided_format": "wmv",
      "supported_formats": ["mp4", "avi", "mov", "mkv"]
    }
  },
  "timestamp": "2025-12-12T10:30:00Z",
  "request_id": "req_abc123"
}
```

---

## 🔍 Detailed Response Schemas

### Transcription Response

```json
{
  "transcription": {
    "full_text": "Complete transcription text...",
    "language": "en",
    "duration_seconds": 300,
    "word_count": 450,
    "speakers": [
      {
        "speaker_id": "SPEAKER_00",
        "total_duration": 250,
        "segment_count": 15,
        "segments": [
          {
            "start": 0.0,
            "end": 3.5,
            "text": "Hello, my name is John",
            "confidence": 0.95,
            "words": [
              {
                "word": "Hello",
                "start": 0.0,
                "end": 0.5,
                "confidence": 0.98
              }
            ]
          }
        ]
      }
    ],
    "metadata": {
      "model": "openai/whisper-large-v3",
      "processing_time_seconds": 45,
      "audio_quality": "good"
    }
  }
}
```

---

### LLM Assessment Response

```json
{
  "assessment": {
    "overall_score": 8.5,
    "rating": "Excellent",
    "categories": {
      "technical_skills": {
        "score": 9.0,
        "confidence": 0.88,
        "evidence": [
          "Demonstrated strong knowledge of Python and frameworks",
          "Explained complex algorithms clearly"
        ]
      },
      "communication": {
        "score": 8.0,
        "confidence": 0.85,
        "evidence": [
          "Clear and articulate responses",
          "Good structure in explanations"
        ]
      },
      "problem_solving": {
        "score": 8.5,
        "confidence": 0.90,
        "evidence": [
          "Systematic approach to problems",
          "Creative solutions proposed"
        ]
      },
      "cultural_fit": {
        "score": 8.0,
        "confidence": 0.82,
        "evidence": [
          "Team-oriented mindset",
          "Values align with company culture"
        ]
      }
    },
    "strengths": [
      "Strong technical foundation",
      "Excellent communication skills",
      "Problem-solving abilities"
    ],
    "areas_for_improvement": [
      "Could provide more specific examples",
      "Time management in responses"
    ],
    "detailed_feedback": "The candidate demonstrates exceptional technical skills...",
    "recommendation": "Strongly Recommended for Next Round",
    "confidence_score": 0.87,
    "metadata": {
      "model": "meta-llama/Llama-3.1-8B-Instruct",
      "processing_time_seconds": 12,
      "token_count": 2500
    }
  }
}
```

---

### Cheating Detection Response

```json
{
  "cheating_detection": {
    "overall_status": "clean",
    "is_suspicious": false,
    "confidence": 0.92,
    "risk_level": "low",
    "detections": {
      "multiple_faces": {
        "detected": false,
        "count": 0,
        "timestamps": []
      },
      "no_face_detected": {
        "detected": false,
        "duration_seconds": 0,
        "percentage": 0.0,
        "timestamps": []
      },
      "looking_away": {
        "detected": true,
        "count": 2,
        "total_duration_seconds": 15,
        "percentage": 5.0,
        "timestamps": [
          {
            "start": 45.2,
            "end": 52.8,
            "duration": 7.6
          },
          {
            "start": 120.5,
            "end": 127.9,
            "duration": 7.4
          }
        ]
      },
      "voice_inconsistency": {
        "detected": false,
        "confidence": 0.95,
        "segments": []
      },
      "background_noise": {
        "detected": true,
        "severity": "low",
        "timestamps": [
          {
            "start": 80.0,
            "end": 85.0,
            "type": "keyboard"
          }
        ]
      }
    },
    "summary": {
      "total_suspicious_events": 2,
      "critical_events": 0,
      "warning_events": 2,
      "info_events": 1
    },
    "metadata": {
      "models": {
        "face_detection": "mediapipe",
        "speaker_verification": "resemblyzer"
      },
      "processing_time_seconds": 60,
      "frames_analyzed": 9000
    }
  }
}
```

---

### Non-Verbal Analysis Response

```json
{
  "non_verbal_analysis": {
    "eye_contact": {
      "score": 0.85,
      "percentage_time": 85,
      "rating": "Excellent",
      "breakdown": {
        "direct": 255,
        "away": 45
      }
    },
    "facial_expressions": {
      "dominant_emotion": "confident",
      "emotions": {
        "confident": 0.70,
        "nervous": 0.15,
        "neutral": 0.10,
        "happy": 0.05
      },
      "timeline": [
        {
          "timestamp": 10.0,
          "emotion": "confident",
          "confidence": 0.85
        }
      ]
    },
    "posture": {
      "overall": "good",
      "stability": 0.88,
      "engagement_score": 0.82,
      "notes": [
        "Maintained upright posture throughout",
        "Minimal excessive movement"
      ]
    },
    "gestures": {
      "hand_movements": {
        "count": 45,
        "appropriateness": "high",
        "types": {
          "illustrative": 30,
          "emphatic": 10,
          "adaptive": 5
        }
      }
    },
    "overall_presence": {
      "score": 8.2,
      "professionalism": 0.90,
      "engagement": 0.85,
      "confidence": 0.82
    },
    "metadata": {
      "model": "mediapipe_face_mesh",
      "frames_analyzed": 9000,
      "processing_time_seconds": 35
    }
  }
}
```

---

## ⏱️ Response Times

**Average Processing Times:**

| Stage                  | CPU Only      | With GPU      |
| ---------------------- | ------------- | ------------- |
| Video Upload           | < 5 seconds   | < 5 seconds   |
| Audio Extraction       | 10-15 seconds | 10-15 seconds |
| Transcription          | 3-5 minutes   | 30-60 seconds |
| LLM Assessment         | 20-30 seconds | 5-10 seconds  |
| Cheating Detection     | 1-2 minutes   | 20-30 seconds |
| Non-Verbal Analysis    | 1-2 minutes   | 20-30 seconds |
| **Total (10 min video)**| **8-12 minutes** | **2-3 minutes** |

---

## 📏 Response Size Limits

| Endpoint           | Max Response Size | Typical Size  |
| ------------------ | ----------------- | ------------- |
| `/transcription/*` | 5 MB              | 100-500 KB    |
| `/results/*`       | 10 MB             | 1-2 MB        |
| `/sessions`        | 2 MB              | 50-200 KB     |

---

## 🔄 Pagination

For list endpoints:

```http
GET /sessions?limit=20&offset=0
```

**Response:**

```json
{
  "total": 100,
  "limit": 20,
  "offset": 0,
  "has_more": true,
  "data": [...]
}
```

---

## 📝 Best Practices

### 1. Polling Status

```python
import time
import requests

def wait_for_completion(session_id):
    while True:
        response = requests.get(f"http://localhost:8000/status/{session_id}")
        status = response.json()["status"]
        
        if status == "completed":
            return True
        elif status == "failed":
            return False
        
        time.sleep(5)  # Poll every 5 seconds
```

### 2. Error Handling

```python
try:
    response = requests.post(url, files=files, data=data)
    response.raise_for_status()
    result = response.json()
except requests.exceptions.HTTPError as e:
    print(f"HTTP Error: {e.response.status_code}")
    print(f"Details: {e.response.json()}")
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
```

---

## 📚 See Also

- [API Endpoints](endpoints.md)
- [Error Codes](errors.md)
- [Quickstart Guide](../getting-started/quickstart.md)
