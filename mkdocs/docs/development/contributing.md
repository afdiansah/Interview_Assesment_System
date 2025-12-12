# Contributing Guide

Panduan untuk berkontribusi ke Interview Assessment System.

---

## 🎉 Welcome Contributors!

Terima kasih atas minat Anda untuk berkontribusi! Kontribusi dalam bentuk apapun sangat dihargai:

- 🐛 Bug reports
- ✨ Feature requests
- 📝 Documentation improvements
- 💻 Code contributions
- 🧪 Testing

---

## 🚀 Quick Start

### 1. Fork & Clone Repository

```bash
# Fork repository via GitHub UI
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/Interview_Assesment_System-ngrok-raifal.git
cd Interview_Assesment_System-ngrok-raifal
```

### 2. Setup Development Environment

```bash
# Create virtual environment
py -3.11 -m venv .venv

# Activate (Windows)
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Install dev dependencies
pip install pytest black flake8 mypy pre-commit
```

### 3. Create Branch

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Or bug fix branch
git checkout -b fix/bug-description
```

---

## 📋 Development Workflow

### Step 1: Make Changes

```bash
# Edit files
code payload_video.ipynb
# or
code Upload.html
```

### Step 2: Test Changes

```python
# Run tests
pytest tests/

# Run specific test
pytest tests/test_transcription.py -v
```

### Step 3: Format Code

```bash
# Format Python code
black .

# Check linting
flake8 .

# Type checking
mypy .
```

### Step 4: Commit Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add speaker diarization feature"

# Or for bug fixes
git commit -m "fix: resolve audio extraction error"
```

**Commit Message Format:**
```
type: short description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Add tests
- `chore`: Maintenance

### Step 5: Push & Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name

# Create Pull Request via GitHub UI
```

---

## 🧪 Testing Guidelines

### Writing Tests

```python
# tests/test_transcription.py
import pytest
from pipeline.transcription import WhisperTranscriber

def test_transcription():
    """Test basic transcription"""
    transcriber = WhisperTranscriber()
    result = transcriber.transcribe("test_audio.wav", language="en")
    
    assert result is not None
    assert "text" in result
    assert len(result["text"]) > 0

def test_transcription_invalid_file():
    """Test error handling"""
    transcriber = WhisperTranscriber()
    
    with pytest.raises(FileNotFoundError):
        transcriber.transcribe("nonexistent.wav")
```

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=pipeline --cov-report=html

# Run specific test
pytest tests/test_transcription.py::test_transcription -v

# Run tests matching pattern
pytest -k "transcription"
```

---

## 📝 Code Style

### Python Style Guide

Follow **PEP 8** with these specifics:

```python
# Good
def transcribe_audio(audio_path: str, language: str = "en") -> dict:
    """
    Transcribe audio file to text.
    
    Args:
        audio_path: Path to audio file
        language: Language code (en/id)
    
    Returns:
        dict: Transcription result with text and timestamps
    """
    result = process_audio(audio_path)
    return result

# Bad
def transcribeAudio(audioPath,lang='en'):
    result=processAudio(audioPath)
    return result
```

### JavaScript Style Guide

```javascript
// Good
function uploadVideo(file, language) {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('language', language);
  
  return fetch('/upload', {
    method: 'POST',
    body: formData
  });
}

// Bad
function upload_video(file,language){
    var formData=new FormData()
    formData.append('file',file)
    formData.append('language',language)
    return fetch('/upload',{method:'POST',body:formData})
}
```

### Formatting Tools

```bash
# Python: Black
black --line-length 88 .

# Python: isort (import sorting)
isort .

# JavaScript: Prettier
npx prettier --write "**/*.js"
```

---

## 📚 Documentation

### Docstring Format

```python
def process_video(video_path: str, language: str) -> dict:
    """
    Process interview video and generate assessment.
    
    This function orchestrates the entire processing pipeline:
    1. Extract audio
    2. Transcribe speech
    3. Assess with LLM
    4. Detect cheating
    5. Analyze non-verbal cues
    
    Args:
        video_path: Absolute path to video file
        language: Language code ('en' or 'id')
    
    Returns:
        dict: Complete assessment results containing:
            - transcription: Full text with timestamps
            - assessment: LLM scores and feedback
            - cheating: Detected suspicious behaviors
            - nonverbal: Expression and posture analysis
    
    Raises:
        FileNotFoundError: If video file doesn't exist
        ValueError: If language is not supported
        ProcessingError: If any pipeline stage fails
    
    Example:
        >>> results = process_video("interview.mp4", "en")
        >>> print(results["assessment"]["overall_score"])
        8.5
    """
    pass
```

### Comment Best Practices

```python
# Good: Explain WHY, not WHAT
# Use frame skip to reduce processing time while maintaining accuracy
frame_skip = 5

# Bad: Obvious comment
# Set frame skip to 5
frame_skip = 5
```

---

## 🔍 Code Review Process

### What Reviewers Look For

1. **Correctness:** Does it work as intended?
2. **Tests:** Are there adequate tests?
3. **Documentation:** Is it well documented?
4. **Style:** Does it follow style guidelines?
5. **Performance:** Are there any bottlenecks?
6. **Security:** Any security concerns?

### Responding to Reviews

```bash
# Make requested changes
git add .
git commit -m "refactor: address review comments"

# Push changes
git push origin feature/your-feature-name
```

---

## 🐛 Reporting Bugs

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Upload video with ...
2. Select language ...
3. Error occurs at ...

**Expected behavior**
What you expected to happen.

**Actual behavior**
What actually happened.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- OS: [e.g., Windows 11]
- Python version: [e.g., 3.11.9]
- GPU: [e.g., NVIDIA RTX 3070]

**Additional context**
- Error logs
- Video details (format, size, duration)
```

---

## ✨ Feature Requests

### Feature Request Template

```markdown
**Feature description**
Clear description of the feature.

**Use case**
Why is this feature needed?

**Proposed solution**
How should this be implemented?

**Alternatives considered**
Other approaches you've thought about.

**Additional context**
Mockups, examples, references.
```

---

## 🎯 Areas to Contribute

### High Priority

- ⭐ **Multi-language support** (add more languages)
- ⭐ **Performance optimization** (faster processing)
- ⭐ **Better UI/UX** (improve dashboard)
- ⭐ **Test coverage** (add more tests)

### Good First Issues

- 📝 Improve documentation
- 🎨 Fix UI styling
- 🐛 Fix minor bugs
- ✅ Add tests for existing code

### Advanced Contributions

- 🚀 Microservices architecture
- 🔒 Authentication system
- 📊 Advanced analytics
- 🤖 New ML models integration

---

## 💻 Development Tips

### Hot Reload During Development

```python
# Use reload for FastAPI
uvicorn main:app --reload --port 8000

# Or use Jupyter notebook auto-reload
%load_ext autoreload
%autoreload 2
```

### Debug Logging

```python
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

logger.debug("Processing frame %d", frame_idx)
logger.info("Transcription completed")
logger.warning("Low audio quality detected")
logger.error("Failed to load model: %s", error)
```

### Using Breakpoints

```python
# IPython debugger
import ipdb; ipdb.set_trace()

# Or Python debugger
import pdb; pdb.set_trace()

# Or use VS Code debugger
# Set breakpoint in editor
```

---

## 🔧 Pre-commit Hooks

### Setup Pre-commit

```bash
# Install pre-commit
pip install pre-commit

# Setup hooks
pre-commit install
```

### `.pre-commit-config.yaml`

```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.12.0
    hooks:
      - id: black
  
  - repo: https://github.com/PyCQA/flake8
    rev: 6.1.0
    hooks:
      - id: flake8
  
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.7.1
    hooks:
      - id: mypy
```

---

## 📊 Performance Benchmarking

### Benchmark Your Changes

```python
import time

def benchmark(func, *args, iterations=10):
    """Benchmark function performance"""
    times = []
    for _ in range(iterations):
        start = time.time()
        func(*args)
        end = time.time()
        times.append(end - start)
    
    avg = sum(times) / len(times)
    print(f"{func.__name__}: {avg:.2f}s avg")
    return avg

# Usage
benchmark(transcribe_audio, "test.wav")
```

---

## 🏆 Recognition

Contributors will be:
- ✨ Listed in CONTRIBUTORS.md
- 📝 Mentioned in release notes
- 🎖️ Given credit in documentation

---

## 📞 Getting Help

**Questions?**
- Open a GitHub Discussion
- Comment on existing issues
- Email: [your-email]

**Resources:**
- [Development Docs](architecture.md)
- [API Reference](../api/endpoints.md)
- [Troubleshooting](../troubleshooting/common-issues.md)

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the project's license.

---

**Thank you for contributing!** 🎉 Your efforts help make this project better for everyone!
