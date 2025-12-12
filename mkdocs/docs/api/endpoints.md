# API Endpoints

Dokumentasi lengkap semua endpoint yang tersedia di Interview Assessment System.

## Base URL

```
http://localhost:8000
```

---

## 📤 Upload & Processing

### Upload Video Interview

Upload video interview untuk diproses.

```http
POST /upload
```

**Content-Type:** `multipart/form-data`

**Parameters:**

| Field        | Type   | Required | Description                           |
| ------------ | ------ | -------- | ------------------------------------- |
| `file`       | File   | ✅       | Video file (MP4, AVI, MOV, MKV)       |
| `language`   | String | ✅       | Language code: `"en"` or `"id"`       |
| `session_id` | String | ❌       | Custom session ID (auto-generated)    |

**Example Request (cURL):**

```bash
curl -X POST http://localhost:8000/upload \
  -F "file=@interview.mp4" \
  -F "language=en"
```

**Example Request (Python):**

```python
import requests

url = "http://localhost:8000/upload"
files = {"file": open("interview.mp4", "rb")}
data = {"language": "en"}

response = requests.post(url, files=files, data=data)
print(response.json())
```

**Response (200 OK):**

```json
{
  "status": "success",
  "session_id": "8ed72a2bed56428da884abed7cb11649",
  "message": "Video uploaded successfully",
  "file_info": {
    "filename": "interview.mp4",
    "size_mb": 45.2,
    "duration_seconds": 300,
    "language": "en"
  },
  "next_step": "processing_started"
}
```

**Response (400 Bad Request):**

```json
{
  "status": "error",
  "error": "Invalid file format",
  "supported_formats": ["mp4", "avi", "mov", "mkv"]
}
```

---

## 📊 Results & Dashboard

### Get Processing Status

Check status dari video yang sedang diproses.

```http
GET /status/{session_id}
```

**Path Parameters:**

| Parameter    | Type   | Description                |
| ------------ | ------ | -------------------------- |
| `session_id` | String | Session ID dari upload     |

**Example Request:**

```bash
curl http://localhost:8000/status/8ed72a2bed56428da884abed7cb11649
```

**Response (200 OK):**

```json
{
  "status": "processing",
  "session_id": "8ed72a2bed56428da884abed7cb11649",
  "progress": {
    "current_stage": "transcription",
    "percentage": 45,
    "stages_completed": ["extraction", "preprocessing"],
    "stages_remaining": ["transcription", "llm_assessment", "cheating_detection"]
  },
  "estimated_time_remaining": 120
}
```

---

### Get Complete Results

Dapatkan hasil lengkap dari assessment.

```http
GET /results/{session_id}
```

**Path Parameters:**

| Parameter    | Type   | Description            |
| ------------ | ------ | ---------------------- |
| `session_id` | String | Session ID dari upload |

**Example Request:**

```bash
curl http://localhost:8000/results/8ed72a2bed56428da884abed7cb11649
```

**Response (200 OK):**

```json
{
  "status": "completed",
  "session_id": "8ed72a2bed56428da884abed7cb11649",
  "results": {
    "transcription": {
      "text": "Hello, my name is John...",
      "language": "en",
      "duration": 300,
      "speakers": [
        {
          "speaker_id": "SPEAKER_00",
          "segments": [
            {
              "start": 0.0,
              "end": 3.5,
              "text": "Hello, my name is John"
            }
          ]
        }
      ]
    },
    "llm_assessment": {
      "overall_score": 8.5,
      "categories": {
        "technical_skills": 9.0,
        "communication": 8.0,
        "problem_solving": 8.5
      },
      "feedback": "Candidate demonstrates strong technical knowledge...",
      "confidence": 0.87
    },
    "cheating_detection": {
      "is_suspicious": false,
      "confidence": 0.92,
      "detections": {
        "multiple_faces": false,
        "looking_away": 2,
        "no_face_detected": 0,
        "voice_changes": false
      }
    },
    "non_verbal_analysis": {
      "eye_contact": 0.85,
      "facial_expressions": {
        "confident": 0.70,
        "nervous": 0.15,
        "neutral": 0.15
      },
      "posture": "good"
    }
  }
}
```

---

### Get Transcription Only

Dapatkan hanya hasil transcription.

```http
GET /transcription/{session_id}
```

**Response (200 OK):**

```json
{
  "session_id": "8ed72a2bed56428da884abed7cb11649",
  "transcription": {
    "text": "Full transcription text here...",
    "language": "en",
    "segments": [...],
    "speakers": [...]
  }
}
```

---

### Get LLM Assessment Only

```http
GET /assessment/{session_id}
```

**Response (200 OK):**

```json
{
  "session_id": "8ed72a2bed56428da884abed7cb11649",
  "assessment": {
    "overall_score": 8.5,
    "categories": {...},
    "feedback": "..."
  }
}
```

---

### Get Cheating Detection Only

```http
GET /cheating/{session_id}
```

**Response (200 OK):**

```json
{
  "session_id": "8ed72a2bed56428da884abed7cb11649",
  "cheating_detection": {
    "is_suspicious": false,
    "confidence": 0.92,
    "detections": {...}
  }
}
```

---

## 🗑️ Management

### Delete Session

Hapus session dan semua data terkait.

```http
DELETE /session/{session_id}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "message": "Session deleted successfully",
  "session_id": "8ed72a2bed56428da884abed7cb11649"
}
```

---

### List All Sessions

Dapatkan list semua session.

```http
GET /sessions
```

**Query Parameters:**

| Parameter | Type   | Default | Description                      |
| --------- | ------ | ------- | -------------------------------- |
| `limit`   | Int    | 10      | Max number of sessions           |
| `offset`  | Int    | 0       | Pagination offset                |
| `status`  | String | `all`   | Filter: `completed`, `processing`|

**Example:**

```bash
curl "http://localhost:8000/sessions?limit=20&status=completed"
```

**Response (200 OK):**

```json
{
  "total": 45,
  "sessions": [
    {
      "session_id": "8ed72a2bed56428da884abed7cb11649",
      "filename": "interview.mp4",
      "status": "completed",
      "created_at": "2025-12-12T10:30:00Z",
      "completed_at": "2025-12-12T10:35:00Z"
    }
  ]
}
```

---

## 📈 System Info

### Health Check

Check apakah server running.

```http
GET /health
```

**Response (200 OK):**

```json
{
  "status": "healthy",
  "version": "1.0.0",
  "uptime_seconds": 3600,
  "gpu_available": true
}
```

---

### Get System Config

Dapatkan konfigurasi sistem.

```http
GET /config
```

**Response (200 OK):**

```json
{
  "models": {
    "whisper": "openai/whisper-large-v3",
    "llm": "meta-llama/Llama-3.1-8B-Instruct"
  },
  "supported_languages": ["en", "id"],
  "max_video_size_mb": 500,
  "max_duration_seconds": 3600
}
```

---

## 📝 Rate Limits

| Endpoint        | Rate Limit       | Notes                        |
| --------------- | ---------------- | ---------------------------- |
| `/upload`       | 10 per hour      | Per IP address               |
| `/results/*`    | 100 per hour     | Per session                  |
| `/status/*`     | 60 per minute    | Polling allowed              |
| Other endpoints | 1000 per hour    | General limit                |

---

## 🔐 Authentication (Coming Soon)

Future versions akan support API key authentication:

```http
Authorization: Bearer YOUR_API_KEY
```

---

## 📚 See Also

- [Request & Response Details](request-response.md)
- [Error Handling](errors.md)
- [Configuration](../configuration/api-keys.md)
