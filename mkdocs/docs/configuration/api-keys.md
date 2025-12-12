# API Keys Configuration

Panduan lengkap setup dan konfigurasi API keys yang diperlukan.

---

## 🔑 Required API Keys

| Service | Purpose | Required | Cost |
|---------|---------|----------|------|
| Hugging Face | LLM Assessment | ✅ Yes | Free tier available |
| DeepL | Translation (EN↔ID) | ✅ Yes | Free tier available |
| ngrok (optional) | Remote access | ❌ No | Free tier available |

---

## 🚀 Quick Setup

### 1. Create `.env` File

Buat file `.env` di root folder project:

```bash
d:\Interview_Assesment_System-ngrok-raifal\.env
```

### 2. Add API Keys

```env
# Hugging Face API Key (Required)
HUGGINGFACE_API_KEY=hf_xxxxxxxxxxxxxxxxxxxxxxxxxx

# DeepL API Key (Required)
DEEPL_API_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:fx

# ngrok Auth Token (Optional)
NGROK_AUTH_TOKEN=your_ngrok_token_here
```

---

## 🤗 Hugging Face Setup

### Step 1: Create Account

1. Kunjungi [https://huggingface.co/join](https://huggingface.co/join)
2. Sign up dengan email atau GitHub
3. Verify email address

### Step 2: Get API Key

1. Login ke Hugging Face
2. Go to **Settings** → **Access Tokens**
3. Click **New token**
4. Token name: `interview-assessment`
5. Role: **Read**
6. Click **Generate token**
7. **Copy token** (starts with `hf_...`)

### Step 3: Add to `.env`

```env
HUGGINGFACE_API_KEY=hf_abcdefghijklmnopqrstuvwxyz1234567890
```

### Test API Key

```python
from transformers import pipeline

# Test connection
pipe = pipeline(
    "text-generation",
    model="meta-llama/Llama-3.1-8B-Instruct",
    token="hf_your_token_here"
)

print("✅ Hugging Face API working!")
```

---

## 🌐 DeepL Setup

### Step 1: Create Account

1. Kunjungi [https://www.deepl.com/pro-api](https://www.deepl.com/pro-api)
2. Click **Sign up for free**
3. Fill in details
4. Verify email

### Step 2: Get API Key

1. Login to DeepL
2. Go to **Account** → **API Keys**
3. Copy **Authentication Key**
4. Format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:fx`

### Step 3: Add to `.env`

```env
DEEPL_API_KEY=12345678-90ab-cdef-1234-567890abcdef:fx
```

### Test API Key

```python
import deepl

# Test translation
translator = deepl.Translator("your_api_key_here")
result = translator.translate_text("Hello", target_lang="ID")
print(result.text)  # Should print: Halo

print("✅ DeepL API working!")
```

### Free Tier Limits

| Plan | Characters/Month | Cost |
|------|-----------------|------|
| Free | 500,000 | $0 |
| Pro | Unlimited | Starting $5.99/month |

---

## 🔒 ngrok Setup (Optional)

ngrok diperlukan jika ingin akses server dari internet (remote).

### Step 1: Create Account

1. Visit [https://ngrok.com/signup](https://ngrok.com/signup)
2. Sign up (free account available)

### Step 2: Get Auth Token

1. Login to ngrok dashboard
2. Go to **Your Authtoken**
3. Copy auth token

### Step 3: Add to `.env`

```env
NGROK_AUTH_TOKEN=2abcdefghijklmnopqrstuvwxyz1234567890
```

### Step 4: Setup ngrok

```bash
# Install ngrok
pip install pyngrok

# Set auth token
ngrok config add-authtoken your_token_here

# Start tunnel
ngrok http 8000
```

---

## 📝 Environment File Examples

### Development (`.env.development`)

```env
# Development configuration
HUGGINGFACE_API_KEY=hf_dev_key_here
DEEPL_API_KEY=dev_deepl_key:fx
DEBUG=true
LOG_LEVEL=DEBUG
```

### Production (`.env.production`)

```env
# Production configuration
HUGGINGFACE_API_KEY=hf_prod_key_here
DEEPL_API_KEY=prod_deepl_key:fx
DEBUG=false
LOG_LEVEL=INFO
RATE_LIMIT_ENABLED=true
```

---

## 🔐 Security Best Practices

### ✅ DO

- **Store keys in `.env`** file
- **Add `.env` to `.gitignore`**
- **Use different keys for dev/prod**
- **Rotate keys regularly** (every 90 days)
- **Restrict key permissions** (read-only when possible)

### ❌ DON'T

- ❌ Commit `.env` to Git
- ❌ Share keys in chat/email
- ❌ Hardcode keys in source code
- ❌ Use production keys in development
- ❌ Store keys in public repositories

---

## 📋 `.gitignore` Configuration

Pastikan `.env` ada di `.gitignore`:

```gitignore
# Environment variables
.env
.env.local
.env.development
.env.production

# API keys
*.key
secrets/
```

---

## 🔄 Loading Environment Variables

### In Jupyter Notebook

```python
import os
from dotenv import load_dotenv

# Load .env file
load_dotenv()

# Access variables
HF_API_KEY = os.getenv('HUGGINGFACE_API_KEY')
DEEPL_API_KEY = os.getenv('DEEPL_API_KEY')

# Verify
if not HF_API_KEY:
    raise ValueError("❌ HUGGINGFACE_API_KEY not found in .env")

print("✅ Environment variables loaded")
```

### In Python Script

```python
#!/usr/bin/env python
import os
from pathlib import Path
from dotenv import load_dotenv

# Load .env from project root
env_path = Path(__file__).parent / '.env'
load_dotenv(dotenv_path=env_path)

# Get with default fallback
HF_KEY = os.getenv('HUGGINGFACE_API_KEY', 'default_key')
```

---

## 🧪 Validation Script

Create `check_api_keys.py`:

```python
#!/usr/bin/env python
"""
Validate all API keys are configured correctly
"""
import os
import sys
from dotenv import load_dotenv

def check_api_keys():
    load_dotenv()
    
    required_keys = {
        'HUGGINGFACE_API_KEY': 'Hugging Face',
        'DEEPL_API_KEY': 'DeepL'
    }
    
    optional_keys = {
        'NGROK_AUTH_TOKEN': 'ngrok'
    }
    
    all_ok = True
    
    print("🔍 Checking Required API Keys...\n")
    
    # Check required keys
    for key, service in required_keys.items():
        value = os.getenv(key)
        if value and len(value) > 10:
            print(f"✅ {service}: Configured")
        else:
            print(f"❌ {service}: Missing or invalid")
            all_ok = False
    
    print("\n🔍 Checking Optional API Keys...\n")
    
    # Check optional keys
    for key, service in optional_keys.items():
        value = os.getenv(key)
        if value:
            print(f"✅ {service}: Configured")
        else:
            print(f"⚠️  {service}: Not configured (optional)")
    
    print("\n" + "="*50)
    
    if all_ok:
        print("✅ All required API keys are configured!")
        return 0
    else:
        print("❌ Some required API keys are missing!")
        print("\n📝 Please check your .env file")
        return 1

if __name__ == "__main__":
    sys.exit(check_api_keys())
```

Run validation:

```bash
python check_api_keys.py
```

---

## 🔧 Troubleshooting

### Error: "API key not found"

**Solution:**

```bash
# Check .env exists
ls -la .env

# Check .env content (safely)
cat .env | sed 's/=.*/=***HIDDEN***/'

# Reload environment
python -c "from dotenv import load_dotenv; load_dotenv(); import os; print(os.getenv('HUGGINGFACE_API_KEY'))"
```

---

### Error: "Invalid API key"

**Hugging Face:**
- Key harus start dengan `hf_`
- Check di https://huggingface.co/settings/tokens

**DeepL:**
- Key harus end dengan `:fx`
- Check di https://www.deepl.com/account

---

### Error: "Rate limit exceeded"

**Solutions:**

1. **Wait and retry:**
   ```python
   import time
   time.sleep(60)  # Wait 1 minute
   ```

2. **Upgrade plan:**
   - Hugging Face: Pro plan
   - DeepL: Pro API

3. **Use caching:**
   ```python
   # Cache translations
   translation_cache = {}
   
   def translate_cached(text, target_lang):
       key = f"{text}_{target_lang}"
       if key not in translation_cache:
           translation_cache[key] = translator.translate_text(text, target_lang=target_lang)
       return translation_cache[key]
   ```

---

## 📊 API Usage Monitoring

### Track Hugging Face Usage

```python
import requests

def check_hf_rate_limit(api_key):
    headers = {"Authorization": f"Bearer {api_key}"}
    response = requests.get(
        "https://huggingface.co/api/whoami-v2",
        headers=headers
    )
    print(response.json())
```

### Track DeepL Usage

```python
import deepl

translator = deepl.Translator(api_key)
usage = translator.get_usage()

print(f"Character count: {usage.character.count}")
print(f"Character limit: {usage.character.limit}")
print(f"Remaining: {usage.character.limit - usage.character.count}")
```

---

## 💡 Cost Optimization Tips

1. **Cache results** - Avoid duplicate API calls
2. **Batch requests** - Process multiple items together
3. **Use free tiers** - Start with free plans
4. **Monitor usage** - Set up alerts
5. **Optimize prompts** - Shorter prompts = less cost

---

## 📚 See Also

- [Model Configuration](models.md)
- [Advanced Configuration](advanced.md)
- [Troubleshooting](../troubleshooting/common-issues.md)
