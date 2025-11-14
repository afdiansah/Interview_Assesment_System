# Interview Assesment System

Capstone Project Asah by Dicoding 2025

## Menjalankan server upload lokal (untuk development)

1. Install dependency:

   - pip install fastapi uvicorn

2. Jalankan server:

   - python d:\Coding\Interview_Assesment_System-main\server.py
     atau
   - uvicorn server:app --host 0.0.0.0 --port 8888 --reload

3. Perilaku server:
   - POST /upload_file -> terima multipart file, simpan di folder `uploads/`, kembalikan JSON `{ "success": true, "url": "http://<host>:8888/uploads/<file>" }`
   - POST /upload -> terima JSON payload (dari client), simpan ke `received_payloads/` dan kembalikan `{ "success": true, "saved_as": "<filename>" }`
   - Static files tersedia di http://127.0.0.1:8888/uploads/<file>

Catatan:

- Untuk pengujian lokal buka Upload.html di browser (file://) lalu pilih video, klik "Kirim Video". Server akan menerima file via /upload_file, mengembalikan URL publik (http://127.0.0.1:8888/uploads/...), lalu Upload.html akan mengirim payload JSON ke /upload yang berisi URL tersebut. Klik "Download JSON" akan mengunduh payload dengan URL yang dapat dibuka di browser.
