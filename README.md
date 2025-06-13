# Pembelajaran SQL

Platform pembelajaran SQL lengkap dengan materi terstruktur, contoh kode, dan penjelasan detail.

## Fitur

- **Materi Terstruktur**: 11 bagian pembelajaran dari dasar hingga advanced
- **Contoh Kode Real**: Semua contoh SQL dapat langsung dipraktikkan
- **Penjelasan Detail**: Setiap konsep dijelaskan dengan poin-poin mudah dipahami
- **Pencarian Cepat**: Fitur pencarian untuk menemukan materi dengan mudah
- **Responsive Design**: Dapat diakses dari desktop, tablet, dan mobile
- **Syntax Highlighting**: Kode SQL dengan highlighting yang menarik
- **GitHub Integration**: Link ke profil GitHub developer dengan responsive design

## Struktur Materi

1. **SELECT Statement Dasar** - Dasar pengambilan data
2. **JOIN Operations** - Menggabungkan data dari multiple tabel
3. **Subquery dan Nested Query** - Query kompleks
4. **UNION Operations** - Menggabungkan hasil query
5. **View Management** - Virtual table management
6. **Stored Procedures** - Program tersimpan untuk logic bisnis
7. **Triggers** - Automasi dan data integrity
8. **Cursor Programming** - Pemrosesan data baris per baris
9. **DML Operations** - INSERT, UPDATE, DELETE
10. **Aggregate Functions** - Fungsi kalkulasi dan GROUP BY
11. **Utility Commands** - Manajemen database objects

## Instalasi dan Menjalankan

### 1. Persiapan Environment

```powershell
# Masuk ke direktori project
cd c:\laragon\www\basdat

# Aktifkan virtual environment
venv\Scripts\activate

# Install dependencies (jika belum)
pip install -r requirements.txt
```

### 2. Menjalankan Aplikasi

```powershell
# Jalankan Flask development server
python app.py
```

Atau menggunakan Flask CLI:

```powershell
# Set environment variables
$env:FLASK_APP = "app.py"
$env:FLASK_ENV = "development"

# Jalankan aplikasi
flask run --host=0.0.0.0 --port=5000
```

### 3. Akses Aplikasi

Buka browser dan akses:

- **Local**: http://localhost:5000
- **Network**: http://192.168.x.x:5000 (dapat diakses dari device lain di jaringan yang sama)

## Struktur Project

```
basdat/
├── app.py                 # Flask application utama
├── requirements.txt       # Python dependencies
├── templates/            # HTML templates
│   ├── base.html         # Template dasar
│   ├── index.html        # Halaman utama
│   ├── section.html      # Halaman bagian materi
│   ├── topic.html        # Halaman detail topik
│   └── search.html       # Halaman pencarian
├── static/              # CSS, JS, dan assets
│   ├── style.css        # Custom CSS
│   └── script.js        # Custom JavaScript
└── venv/               # Virtual environment
```

## Teknologi yang Digunakan

- **Backend**: Flask (Python)
- **Frontend**: Bootstrap 5, HTML5, CSS3, JavaScript
- **Styling**: Custom CSS dengan gradient dan animasi
- **Icons**: Font Awesome 6
- **Syntax Highlighting**: Prism.js

## Fitur Khusus

### 1. Syntax Highlighting

Kode SQL ditampilkan dengan highlighting untuk keyword, string, dan comment.

### 2. Copy Code

Tombol untuk menyalin kode SQL ke clipboard dengan satu klik.

### 3. Pencarian Cerdas

Pencarian dapat menemukan materi berdasarkan:

- Judul bagian/topik
- Deskripsi materi
- Isi kode SQL

### 4. Navigasi Mudah

- Breadcrumb navigation
- Sidebar navigasi topik
- Tombol Previous/Next
- Back to top button

### 5. Responsive Design

Website dapat diakses dengan baik di:

- Desktop (1200px+)
- Tablet (768px - 1199px)
- Mobile (< 768px)

## Customization

### Menambah Materi Baru

Edit file `app.py` pada variabel `sql_content` untuk menambah bagian atau topik baru:

```python
sql_content = {
    "12": {  # Bagian baru
        "title": "Judul Bagian Baru",
        "description": "Deskripsi bagian",
        "topics": {
            "12.1": {
                "title": "Topik Baru",
                "description": "Deskripsi topik",
                "code": "SELECT * FROM table;",
                "explanation": [
                    "Penjelasan poin 1",
                    "Penjelasan poin 2"
                ]
            }
        }
    }
}
```

### Mengubah Tema

Edit file `static/style.css` untuk mengubah warna tema:

```css
:root {
  --primary-color: #667eea; /* Warna utama */
  --secondary-color: #764ba2; /* Warna sekunder */
  /* ... warna lainnya */
}
```

## Troubleshooting

### Port sudah digunakan

Jika port 5000 sudah digunakan, ubah di `app.py`:

```python
app.run(debug=True, host='0.0.0.0', port=5001)
```

### Virtual environment tidak aktif

Pastikan virtual environment aktif sebelum menjalankan:

```powershell
venv\Scripts\activate
```

### Module tidak ditemukan

Install ulang dependencies:

```powershell
pip install -r requirements.txt
```

## Kontribusi

Untuk berkontribusi pada project ini:

1. Fork repository
2. Buat branch fitur baru
3. Commit perubahan
4. Push ke branch
5. Buat Pull Request

## Lisensi

Project ini dibuat untuk tujuan pembelajaran dan dapat digunakan secara bebas.

## Support

Jika mengalami masalah atau memiliki saran, silakan buat issue di repository atau hubungi developer.

---

**Happy Learning SQL! 🎓💻**
