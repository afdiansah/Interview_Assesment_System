# Frequently Asked Questions (FAQ)

Jawaban untuk pertanyaan yang sering ditanyakan.

---

## 🎯 General Questions

### Q: Apa itu Interview Assessment System?

**A:** Sistem AI untuk menganalisis interview video secara otomatis. Sistem ini melakukan:
- Speech-to-text transcription
- LLM-based assessment
- Cheating detection
- Non-verbal analysis

---

### Q: Berapa lama waktu processing?

**A:** Tergantung hardware dan panjang video:

| Video Duration | CPU Only | With GPU |
|---------------|----------|----------|
| 5 minutes | 4-6 minutes | 1-2 minutes |
| 10 minutes | 8-12 minutes | 2-3 minutes |
| 30 minutes | 24-36 minutes | 6-9 minutes |

---

### Q: Apa saja requirements minimum?

**A:**

**Minimum:**
- Python 3.11+
- 8 GB RAM
- 20 GB storage
- CPU: Intel i5 / AMD Ryzen 5

**Recommended:**
- Python 3.11+
- 16 GB RAM
- 50 GB storage
- GPU: NVIDIA GTX 1660 (6GB VRAM)
- CUDA 11.8 atau 12.1

---

### Q: Apakah gratis?

**A:** 
- ✅ Sistem: Open source (gratis)
- ✅ Whisper: Gratis (local processing)
- ✅ MediaPipe: Gratis
- ❌ LLM API: Memerlukan API key (free tier tersedia)
- ❌ DeepL: Memerlukan API key (free tier 500k chars/month)

---

## 📹 Video Questions

### Q: Format video apa yang supported?

**A:** 
- MP4 (recommended)
- AVI
- MOV
- MKV
- WebM

---

### Q: Berapa ukuran maksimal video?

**A:** 
- **Max size:** 500 MB
- **Max duration:** 60 minutes
- **Recommended:** 10-30 minutes, < 200 MB

---

### Q: Bagaimana kalau video lebih dari 500 MB?

**A:** Compress video terlebih dahulu:

```bash
# Reduce to 720p
ffmpeg -i large_video.mp4 -vf scale=-2:720 -crf 23 compressed.mp4

# Or trim video
ffmpeg -i long_video.mp4 -ss 00:00:00 -t 00:30:00 trimmed.mp4
```

---

### Q: Apakah perlu audio?

**A:** **Ya, wajib!** Video harus memiliki audio track untuk transcription. Video tanpa audio akan ditolak.

---

### Q: Apakah bisa upload dari smartphone?

**A:** **Ya**, selama:
- Video format supported (MP4, MOV)
- Ukuran < 500 MB
- Ada audio yang jelas
- Upload via web interface atau API

---

## 🎙️ Transcription Questions

### Q: Bahasa apa yang supported?

**A:** Saat ini:
- ✅ English (en)
- ✅ Indonesian (id)

Future plans: Tambah bahasa lain sesuai kebutuhan.

---

### Q: Apakah bisa detect multiple speakers?

**A:** **Ya!** Sistem menggunakan speaker diarization untuk:
- Memisahkan interviewer dan interviewee
- Menandai siapa yang berbicara kapan
- Menghitung durasi bicara per speaker

---

### Q: Bagaimana kalau transkrip banyak error?

**A:** Improve audio quality:

1. **Reduce background noise:**
   ```bash
   ffmpeg -i noisy.mp4 -af "highpass=f=200,lowpass=f=3000" clean.mp4
   ```

2. **Normalize volume:**
   ```bash
   ffmpeg -i quiet.mp4 -af "volume=2.0" louder.mp4
   ```

3. **Use external microphone** saat recording

4. **Use Whisper large-v3** (most accurate model)

---

## 🤖 LLM Assessment Questions

### Q: Apa yang di-assess oleh LLM?

**A:** LLM menganalisis:
- **Technical Skills:** Pengetahuan teknis
- **Communication:** Cara komunikasi
- **Problem Solving:** Kemampuan solve problems
- **Cultural Fit:** Kesesuaian dengan budaya kerja

---

### Q: Seberapa akurat LLM assessment?

**A:** 
- **Overall accuracy:** ~85-90%
- **Best for:** Screening awal, bukan keputusan final
- **Recommendation:** Gunakan sebagai referensi tambahan, bukan satu-satunya penilaian

---

### Q: Bisa custom kriteria assessment?

**A:** **Ya!** Edit prompt di `payload_video.ipynb`:

```python
custom_prompt = """
Analyze this interview and assess:
1. Leadership skills
2. Teamwork ability
3. Innovation mindset

Provide scores and detailed feedback.
"""
```

---

### Q: LLM model apa yang digunakan?

**A:** Default: **Llama 3.1-8B-Instruct**

Alternatives:
- GPT-4 (OpenAI)
- Claude 3 (Anthropic)
- Gemini (Google)
- Local Llama via Ollama

---

## 🕵️ Cheating Detection Questions

### Q: Apa saja yang dideteksi?

**A:**
- **Multiple faces:** Lebih dari 1 orang di frame
- **No face:** Kandidat hilang dari frame
- **Looking away:** Terlalu lama melihat ke samping/bawah
- **Voice changes:** Perubahan suara yang mencurigakan

---

### Q: Apakah bisa bypass cheating detection?

**A:** Sistem cukup robust, tapi tidak 100% foolproof. Best used as:
- **Indicator** bukan bukti mutlak
- **Screening tool** untuk flag suspicious behavior
- **Combined dengan** human review

---

### Q: False positive rate?

**A:** 
- **Multiple faces:** ~5% (bisa detect background people)
- **Looking away:** ~10-15% (normal eye movement)
- **Voice changes:** ~5-8%

**Tip:** Review manually jika ada flag.

---

## 🖥️ Technical Questions

### Q: Apakah perlu GPU?

**A:** 
- **Tidak wajib**, tapi **sangat recommended**
- **Without GPU:** Processing 3-5x lebih lambat
- **GPU recommended:** NVIDIA GTX 1660 atau lebih tinggi

---

### Q: Bagaimana cara install CUDA?

**A:**

1. Download CUDA Toolkit: https://developer.nvidia.com/cuda-downloads
2. Install CUDA 11.8 atau 12.1
3. Install PyTorch with CUDA:
   ```bash
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
   ```
4. Verify:
   ```python
   import torch
   print(torch.cuda.is_available())  # Should be True
   ```

---

### Q: Bisa run di macOS?

**A:** **Ya**, tapi:
- ❌ Tidak support CUDA (Apple Silicon/Intel)
- ✅ Bisa pakai CPU (lebih lambat)
- ✅ Apple Silicon (M1/M2) support MPS acceleration

Setup for Apple Silicon:
```python
device = "mps" if torch.backends.mps.is_available() else "cpu"
```

---

### Q: Bisa run di cloud (AWS, GCP)?

**A:** **Ya!** Recommended instances:

**AWS:**
- `g4dn.xlarge` (GPU, ~$0.50/hour)
- `t3.xlarge` (CPU only, ~$0.17/hour)

**GCP:**
- `n1-standard-4` + Tesla T4 GPU

**Azure:**
- `Standard_NC6` (GPU)

---

## 🔒 Security & Privacy Questions

### Q: Apakah video di-upload ke cloud?

**A:** 
- **Default:** Semua processing **lokal** di server Anda
- **Optional:** Bisa upload ke Google Drive untuk backup
- **API calls:** Hanya transcription text dikirim ke LLM API (bukan video)

---

### Q: Apakah data aman?

**A:**
- ✅ Video disimpan lokal
- ✅ Tidak ada sharing ke third party
- ✅ API calls encrypted (HTTPS)
- ✅ Session auto-expire setelah 7 hari

**Best practice:**
- Delete videos setelah processing selesai
- Use strong API keys
- Enable HTTPS di production

---

### Q: GDPR compliant?

**A:** 
- ✅ Data stored locally (under your control)
- ✅ Can delete data on request
- ✅ No tracking/analytics
- ⚠️ Perlu inform kandidat tentang recording & AI analysis

---

## 💰 Cost Questions

### Q: Berapa biaya total?

**A:**

**One-time costs:**
- Server/Computer: $500-2000 (jika belum punya)
- Software: **Gratis** (open source)

**Monthly costs:**
- Hugging Face API: $0-9/month (free tier available)
- DeepL API: $0-6/month (free tier available)
- Electricity: ~$10-20/month (jika run 24/7)

**Per video processing:**
- ~$0.01-0.05 per video (API costs)

---

### Q: Free tier API cukup?

**A:** 

**Hugging Face Free:**
- ~1000 requests/day
- Enough for **~100-200 videos/day**

**DeepL Free:**
- 500,000 characters/month
- Enough for **~500-1000 videos/month**

---

## 🚀 Deployment Questions

### Q: Bagaimana cara deploy ke production?

**A:**

1. **Setup server** (Ubuntu/Windows Server)
2. **Install dependencies**
3. **Configure environment variables**
4. **Setup HTTPS** (Let's Encrypt)
5. **Use process manager** (PM2, systemd)
6. **Setup monitoring** (logs, alerts)

Detailed guide: [Deployment Documentation](#)

---

### Q: Bisa multi-user?

**A:** **Ya!** Sistem support concurrent users:
- Multiple uploads simultaneously
- Queue system untuk processing
- Session isolation per user

---

### Q: Scalability?

**A:**

**Single server:**
- ~10-20 concurrent users
- ~100-200 videos/day

**Multiple servers:**
- Load balancer + worker nodes
- ~100+ concurrent users
- ~1000+ videos/day

---

## 🔧 Troubleshooting Questions

### Q: Error "CUDA out of memory"?

**A:**

```python
# Solution 1: Clear cache
import torch
torch.cuda.empty_cache()

# Solution 2: Use smaller model
WHISPER_MODEL = "openai/whisper-medium"

# Solution 3: Reduce batch size
batch_size = 1
```

---

### Q: Processing terlalu lambat?

**A:**

1. **Use GPU** (3-5x faster)
2. **Use smaller Whisper model** (2x faster)
3. **Skip unnecessary stages**
4. **Reduce video resolution** to 720p
5. **Check system resources** (RAM, CPU usage)

See: [Performance Tuning Guide](../troubleshooting/performance.md)

---

### Q: API key tidak working?

**A:**

1. Check `.env` file exists
2. Verify API key format:
   - Hugging Face: starts with `hf_`
   - DeepL: ends with `:fx`
3. Test API keys:
   ```bash
   python check_api_keys.py
   ```
4. Check API quota/limits

---

## 📚 Documentation Questions

### Q: Di mana dokumentasi lengkap?

**A:**

- **This site:** http://127.0.0.1:8000 (local)
- **GitHub:** [Repository README](https://github.com/your-repo)
- **API Docs:** [API Reference](../api/endpoints.md)
- **Troubleshooting:** [Common Issues](../troubleshooting/common-issues.md)

---

### Q: Ada tutorial video?

**A:** Coming soon! Untuk saat ini, ikuti:
- [Quickstart Guide](../getting-started/quickstart.md)
- [Installation Guide](../getting-started/installation.md)

---

## 💬 Support Questions

### Q: Di mana bisa minta bantuan?

**A:**

1. **Check Documentation** - Mayoritas masalah sudah documented
2. **Search GitHub Issues** - Mungkin sudah ada solusinya
3. **Create GitHub Issue** - Jika masalah baru
4. **Email Support** - For private inquiries

---

### Q: Bisa request fitur baru?

**A:** **Ya!** 

1. Check [Roadmap](../development/roadmap.md)
2. Create feature request di GitHub
3. Atau contribute via Pull Request

---

### Q: Bisa hire untuk custom development?

**A:** Yes! Contact untuk:
- Custom features
- Integration dengan sistem existing
- Enterprise support
- Training & consultation

---

## 🎓 Learning Resources

### Q: Resources untuk belajar lebih lanjut?

**A:**

**AI/ML:**
- [Hugging Face Course](https://huggingface.co/learn)
- [FastAPI Tutorial](https://fastapi.tiangolo.com/tutorial/)

**Interview Assessment:**
- Research papers on automated interview analysis
- HR assessment best practices

---

**Masih ada pertanyaan?** [Open a GitHub issue](https://github.com/your-repo/issues) atau contact support! 💬
