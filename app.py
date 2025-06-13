from flask import Flask, render_template, request, jsonify
import re

app = Flask(__name__)

# SQL Learning Content organized by sections
sql_content = {
    "1": {
        "title": "SELECT Statement Dasar",
        "description": "Pelajari dasar-dasar pengambilan data dengan SELECT statement",
        "topics": {
            "1.1": {
                "title": "Select Semua Data",
                "description": "Menggunakan SELECT * untuk mengambil semua kolom dari tabel",
                "code": """SELECT * FROM POH;
SELECT * FROM POD;
SELECT * FROM Supplier;
SELECT * FROM Barang;
SELECT * FROM Alat;""",
                "explanation": [
                    "SELECT * artinya memilih semua kolom dari tabel",
                    "FROM menentukan tabel sumber data",
                    "Semicolon (;) mengakhiri statement SQL",
                    "Query ini mengambil semua data dari tabel yang disebutkan"
                ]
            },
            "1.2": {
                "title": "Select dengan Kolom Spesifik",
                "description": "Memilih kolom tertentu saja untuk efisiensi dan kejelasan",
                "code": """SELECT PONo, Tgl, KodeSupplier, KodeAlat FROM POH;
SELECT PONo, Kodebarang, Jumlah, Harga FROM POD ORDER BY PONo DESC;
SELECT Kode, Nama, Alamat, Kota, Telp, Fax FROM Supplier;""",
                "explanation": [
                    "Pilih kolom spesifik untuk mengurangi transfer data",
                    "ORDER BY mengurutkan hasil berdasarkan kolom tertentu",
                    "DESC artinya descending (menurun), ASC untuk ascending (menaik)",
                    "Lebih efisien daripada SELECT * jika tidak butuh semua kolom"
                ]
            },
            "1.3": {
                "title": "Select dengan WHERE Clause",
                "description": "Menggunakan WHERE untuk memfilter data berdasarkan kondisi",
                "code": """SELECT * FROM POH WHERE PONo = '200123100018';
SELECT * FROM POD WHERE PONo = '200123100018';
SELECT * FROM POD WHERE PONo = '200125030080';""",
                "explanation": [
                    "WHERE digunakan untuk memfilter baris berdasarkan kondisi",
                    "Operator = untuk perbandingan sama dengan",
                    "String/teks harus dibungkus dengan tanda kutip",
                    "Kondisi dapat dikombinasikan dengan AND, OR, NOT"
                ]
            },
            "1.4": {
                "title": "Select dengan ORDER BY",
                "description": "Mengurutkan hasil query berdasarkan kolom tertentu",
                "code": """SELECT * FROM POH ORDER BY TglModify DESC;
SELECT * FROM POD ORDER BY TglModify DESC;""",
                "explanation": [
                    "ORDER BY mengurutkan hasil query",
                    "DESC = Descending (Z-A, 9-0, terbaru ke terlama)",
                    "ASC = Ascending (A-Z, 0-9, terlama ke terbaru)",
                    "Dapat mengurutkan berdasarkan multiple kolom"
                ]
            }
        }
    },
    "2": {
        "title": "JOIN Operations",
        "description": "Menggabungkan data dari multiple tabel menggunakan JOIN",
        "topics": {
            "2.1": {
                "title": "Inner Join (Implisit)",
                "description": "Menggabungkan tabel tanpa menggunakan keyword JOIN eksplisit",
                "code": """SELECT PONo, Tgl, h.KodeSupplier, s.Nama AS Supplier, a.Nama AS Alat 
FROM POH h, Supplier s, Alat a
WHERE h.KodeSupplier = s.Kode AND h.KodeAlat = a.Kode;""",
                "explanation": [
                    "JOIN implisit menggunakan koma (,) untuk menggabungkan tabel",
                    "Alias tabel (h, s, a) mempermudah penulisan",
                    "WHERE clause menentukan kondisi join",
                    "AS digunakan untuk memberikan alias pada kolom hasil"
                ]
            },
            "2.2": {
                "title": "Join dengan Agregasi",
                "description": "Menggabungkan JOIN dengan fungsi agregasi seperti SUM",
                "code": """SELECT s.Nama AS Supplier, a.Nama AS Alat, b.Nama AS ItemBarang, SUM(Jumlah*d.Harga) AS Total 
FROM Supplier s, POH h, POD d, Barang b, Alat a
WHERE a.Kode = h.KodeAlat 
  AND s.Kode = h.KodeSupplier 
  AND h.PONo = d.PONo 
  AND b.Kode = d.KodeBarang
GROUP BY s.Nama, a.Nama, b.Nama;""",
                "explanation": [
                    "SUM() menghitung total dari kolom numerik",
                    "GROUP BY mengelompokkan hasil berdasarkan kolom tertentu",
                    "Semua kolom non-agregasi harus ada di GROUP BY",
                    "Kalkulasi (Jumlah*d.Harga) dilakukan sebelum agregasi"
                ]
            }
        }
    },
    "3": {
        "title": "Subquery dan Nested Query",
        "description": "Query di dalam query untuk logic yang lebih kompleks",
        "topics": {
            "3.1": {
                "title": "Subquery dalam SELECT",
                "description": "Menggunakan subquery untuk mendapatkan nilai dari tabel lain",
                "code": """SELECT PONo, Kodebarang, Jumlah, Harga, 
       (SELECT Sisa FROM PRD WHERE PRDNo = POD.PRDNo) AS SisaPR
FROM POD 
WHERE PONo = '200125030080';""",
                "explanation": [
                    "Subquery ditulis dalam tanda kurung ()",
                    "Subquery di SELECT hanya boleh mengembalikan satu nilai",
                    "Dapat mengakses kolom dari query utama (POD.PRDNo)",
                    "Hasil subquery dapat diberi alias dengan AS"
                ]
            },
            "3.2": {
                "title": "Subquery dalam FROM (Derived Table)",
                "description": "Menggunakan hasil query sebagai tabel sumber",
                "code": """SELECT * FROM 
(SELECT PONo, Tgl, KodeSupplier, KodeAlat FROM POH) A;

SELECT * FROM 
(SELECT PONo, Tgl, Nama AS NamaSupplier 
 FROM POH, Supplier 
 WHERE Kode = KodeSupplier) A;""",
                "explanation": [
                    "Derived table adalah hasil query yang digunakan sebagai tabel",
                    "Harus diberi alias (A) untuk dapat direferensikan",
                    "Berguna untuk menyederhanakan query kompleks",
                    "Dapat digunakan seperti tabel biasa"
                ]
            }
        }
    },
    "4": {
        "title": "UNION Operations",
        "description": "Menggabungkan hasil dari multiple query",
        "topics": {
            "4.1": {
                "title": "UNION untuk Menggabungkan Data",
                "description": "Menggabungkan data masuk dan keluar dalam satu result set",
                "code": """SELECT Kodebarang, Barang, SUM(Masuk) AS TotalMasuk, SUM(Keluar) AS TotalKeluar 
FROM 
(
    SELECT d.KodeBarang, b.Barang, Jumlah AS Masuk, 0 AS Keluar, Stok 
    FROM MasukD d, Barang b 
    WHERE d.KodeBarang = b.KodeBarang
    UNION 
    SELECT k.KodeBarang, b.Barang, 0, Jumlah, Stok 
    FROM KeluarD k, Barang b 
    WHERE k.KodeBarang = b.KodeBarang
) A
GROUP BY KodeBarang, Barang;""",
                "explanation": [
                    "UNION menggabungkan hasil dari dua atau lebih query",
                    "Jumlah dan tipe kolom harus sama pada semua query",
                    "UNION menghilangkan duplikasi, UNION ALL mempertahankan duplikasi",
                    "Berguna untuk menggabungkan data serupa dari tabel berbeda"
                ]
            }
        }
    },
    "5": {
        "title": "View Management",
        "description": "Membuat virtual table untuk query yang sering digunakan",
        "topics": {
            "5.1": {
                "title": "Membuat View Sederhana",
                "description": "CREATE VIEW untuk menyimpan query sebagai virtual table",
                "code": """CREATE VIEW v_TblA AS
SELECT PONo, Tgl, Nama AS NamaSupplier 
FROM POH, Supplier 
WHERE Kode = KodeSupplier;""",
                "explanation": [
                    "VIEW adalah virtual table berdasarkan hasil SELECT",
                    "Tidak menyimpan data, hanya menyimpan query",
                    "Dapat digunakan seperti tabel biasa dalam SELECT",
                    "Memudahkan penggunaan ulang query kompleks"
                ]
            },
            "5.2": {
                "title": "View dengan Agregasi",
                "description": "View yang menggunakan fungsi agregasi dan GROUP BY",
                "code": """CREATE VIEW V1 AS
SELECT s.Kode, s.Nama AS NamaSupplier, SUM(Jumlah*Harga) AS TotalPO 
FROM POH h, Supplier s, POD d
WHERE s.Kode = h.KodeSupplier AND h.PONo = d.PONo
GROUP BY s.Kode, s.Nama;""",
                "explanation": [
                    "View dapat menggunakan agregasi seperti SUM, COUNT, AVG",
                    "GROUP BY mengelompokkan data sebelum agregasi",
                    "View agregasi berguna untuk laporan dan dashboard",
                    "Data akan diperbarui otomatis jika tabel sumber berubah"
                ]
            }
        }
    },
    "6": {
        "title": "Stored Procedures",
        "description": "Program tersimpan di database untuk logic bisnis",
        "topics": {
            "6.1": {
                "title": "Stored Procedure Tanpa Parameter",
                "description": "Procedure sederhana tanpa input parameter",
                "code": """CREATE PROCEDURE spRepMasukD AS 
BEGIN
    SELECT d.KodeBarang, Barang, Jumlah 
    FROM MasukD d, Barang b 
    WHERE d.KodeBarang = b.KodeBarang;
END;

-- Eksekusi: EXEC spRepMasukD;""",
                "explanation": [
                    "CREATE PROCEDURE mendefinisikan stored procedure",
                    "BEGIN dan END membatasi blok kode procedure",
                    "EXEC digunakan untuk menjalankan procedure",
                    "Procedure dapat berisi multiple statement SQL"
                ]
            },
            "6.2": {
                "title": "Stored Procedure dengan Parameter",
                "description": "Procedure dengan input parameter untuk fleksibilitas",
                "code": """CREATE PROCEDURE spRepMasukDP1 (@vInput CHAR(10)) AS 
BEGIN
    SELECT d.KodeBarang, Barang, Jumlah 
    FROM MasukD d, Barang b 
    WHERE d.KodeBarang = b.KodeBarang 
      AND Barang LIKE @vInput;
END;

-- Eksekusi: EXEC spRepMasukDP1 'Saori%';""",
                "explanation": [
                    "Parameter ditulis dalam tanda kurung dengan tipe data",
                    "@vInput adalah parameter input dengan tipe CHAR(10)",
                    "LIKE digunakan untuk pattern matching",
                    "% adalah wildcard untuk karakter apapun"
                ]
            }
        }
    },
    "7": {
        "title": "Triggers",
        "description": "Code yang dijalankan otomatis saat ada perubahan data",
        "topics": {
            "7.1": {
                "title": "Template Trigger",
                "description": "Struktur dasar pembuatan trigger",
                "code": """CREATE TRIGGER NamaTrigger ON NamaTabel FOR INSERT AS 
BEGIN 
    -- Logic trigger di sini
END;""",
                "explanation": [
                    "CREATE TRIGGER mendefinisikan trigger baru",
                    "ON menentukan tabel yang akan dipantau",
                    "FOR menentukan event yang memicu trigger (INSERT, UPDATE, DELETE)",
                    "Logic trigger ditulis dalam blok BEGIN-END"
                ]
            },
            "7.2": {
                "title": "Trigger untuk Insert",
                "description": "Trigger yang berjalan saat ada data baru (INSERT)",
                "code": """CREATE TRIGGER trMasukD ON MasukD FOR INSERT AS 
BEGIN
    DECLARE @KodeBarang CHAR(5), @Jumlah INT;
    SELECT @KodeBarang = KodeBarang, @Jumlah = Jumlah FROM inserted;
    UPDATE Barang SET Stok = Stok + @Jumlah WHERE KodeBarang = @KodeBarang;
END;""",
                "explanation": [
                    "inserted adalah tabel virtual berisi data yang baru diinsert",
                    "DECLARE mendefinisikan variabel lokal",
                    "Trigger otomatis update stok saat ada barang masuk",
                    "Memastikan konsistensi data secara otomatis"
                ]
            }
        }
    },
    "8": {
        "title": "Cursor Programming",
        "description": "Memproses data baris per baris",
        "topics": {
            "8.1": {
                "title": "Cursor Sederhana",
                "description": "Menggunakan cursor untuk iterasi data",
                "code": """DECLARE @KodeBarang CHAR(5), @Jumlah INT, @Nomor CHAR(3);
DECLARE crIns CURSOR FOR SELECT Nomor, KodeBarang, Jumlah FROM MasukD WHERE Jumlah = 5;
OPEN crIns;
FETCH NEXT FROM crIns INTO @Nomor, @KodeBarang, @Jumlah;
WHILE (@@FETCH_STATUS = 0) 
BEGIN
    PRINT @Nomor + ' ' + @KodeBarang;
    FETCH NEXT FROM crIns INTO @Nomor, @KodeBarang, @Jumlah;
END
CLOSE crIns;
DEALLOCATE crIns;""",
                "explanation": [
                    "CURSOR memungkinkan pemrosesan baris per baris",
                    "OPEN membuka cursor untuk digunakan",
                    "FETCH mengambil baris selanjutnya",
                    "@@FETCH_STATUS = 0 artinya masih ada data",
                    "CLOSE dan DEALLOCATE menutup dan membebaskan cursor"
                ]
            }
        }
    },
    "9": {
        "title": "DML Operations",
        "description": "Data Manipulation Language - INSERT, UPDATE, DELETE",
        "topics": {
            "9.1": {
                "title": "INSERT Operations",
                "description": "Menambahkan data baru ke dalam tabel",
                "code": """INSERT INTO MasukD VALUES('014','001',3);
INSERT INTO MasukD (Nomor, KodeBarang, Jumlah) 
    SELECT Nomor, KodeBarang, Jumlah FROM KeluarD;
INSERT INTO MasukD SELECT * FROM KeluarD;""",
                "explanation": [
                    "INSERT VALUES untuk menambah satu baris dengan nilai spesifik",
                    "Dapat menentukan kolom spesifik dalam tanda kurung",
                    "INSERT SELECT untuk menambah data dari query lain",
                    "Pastikan tipe data dan urutan kolom sesuai"
                ]
            },
            "9.2": {
                "title": "UPDATE Operations",
                "description": "Mengubah data yang sudah ada",
                "code": """UPDATE MasukD SET Jumlah = 10 WHERE Nomor = '001';
UPDATE MasukD SET Jumlah = 5 WHERE Nomor = '016';""",
                "explanation": [
                    "UPDATE mengubah data yang sudah ada",
                    "SET menentukan kolom dan nilai baru",
                    "WHERE menentukan baris mana yang akan diubah",
                    "Tanpa WHERE akan mengubah semua baris (berbahaya!)"
                ]
            },
            "9.3": {
                "title": "DELETE Operations",
                "description": "Menghapus data dari tabel",
                "code": """DELETE FROM MasukD WHERE Jumlah = 3;
DELETE FROM MasukD WHERE Nomor = '013';""",
                "explanation": [
                    "DELETE menghapus baris dari tabel",
                    "WHERE menentukan baris mana yang akan dihapus",
                    "Tanpa WHERE akan menghapus semua data (sangat berbahaya!)",
                    "DELETE tidak dapat di-undo, pastikan backup data"
                ]
            }
        }
    },
    "10": {
        "title": "Aggregate Functions dan GROUP BY",
        "description": "Fungsi untuk kalkulasi dan pengelompokan data",
        "topics": {
            "10.1": {
                "title": "Basic Aggregation",
                "description": "Menggunakan fungsi agregasi dasar",
                "code": """SELECT SUM(Jumlah) FROM MasukD WHERE KodeBarang = '001';
SELECT COUNT(*) FROM MasukD;""",
                "explanation": [
                    "SUM() menghitung total nilai numerik",
                    "COUNT(*) menghitung jumlah baris",
                    "Fungsi agregasi lain: AVG(), MIN(), MAX()",
                    "Hasil agregasi adalah satu nilai untuk semua baris"
                ]
            },
            "10.2": {
                "title": "GROUP BY dengan Agregasi",
                "description": "Mengelompokkan data sebelum agregasi",
                "code": """SELECT s.Nama AS NamaSupplier, SUM(Jumlah * Harga) AS Total 
FROM Supplier s, POH h, POD d
WHERE s.Kode = h.KodeSupplier AND h.PONo = d.PONo
GROUP BY s.Nama;""",
                "explanation": [
                    "GROUP BY mengelompokkan baris berdasarkan nilai kolom",
                    "Agregasi dihitung untuk setiap group",
                    "Kolom non-agregasi harus ada di GROUP BY",
                    "Menghasilkan satu baris per group"
                ]
            },
            "10.3": {
                "title": "HAVING Clause",
                "description": "Filter hasil agregasi dengan HAVING",
                "code": """SELECT s.Nama AS NamaSupplier, a.Nama AS NamaAlat, 
       SUM(Jumlah*d.Harga) AS TotalPO, b.Nama AS NamaBarang 
FROM Supplier s, POH h, POD d, Barang b, Alat a
WHERE s.Kode = h.KodeSupplier 
  AND h.PONo = d.PONo 
  AND d.KodeBarang = b.Kode 
  AND a.Kode = h.KodeAlat 
GROUP BY s.Nama, a.Nama, b.Nama
HAVING SUM(Jumlah*d.Harga) > 1000000;""",
                "explanation": [
                    "HAVING filter hasil setelah GROUP BY",
                    "WHERE filter sebelum GROUP BY",
                    "HAVING dapat menggunakan fungsi agregasi",
                    "Digunakan untuk filter berdasarkan hasil kalkulasi group"
                ]
            }
        }
    }
}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/section/<section_id>')
def section_detail(section_id):
    if section_id in sql_content:
        section = sql_content[section_id]
        return render_template('section.html', section=section, section_id=section_id)
    return "Section not found", 404

@app.route('/topic/<section_id>/<topic_id>')
def topic_detail(section_id, topic_id):
    if section_id in sql_content and topic_id in sql_content[section_id]['topics']:
        section = sql_content[section_id]
        topic = section['topics'][topic_id]
        return render_template('topic.html', topic=topic, section=section, section_id=section_id, topic_id=topic_id)
    return "Topic not found", 404

@app.route('/search')
def search():
    query = request.args.get('q', '').lower()
    results = []
    
    if query:
        for section_id, section in sql_content.items():
            # Search in section title and description
            if query in section['title'].lower() or query in section['description'].lower():
                results.append({
                    'type': 'section',
                    'title': section['title'],
                    'description': section['description'],
                    'url': f'/section/{section_id}'
                })
            
            # Search in topics
            for topic_id, topic in section['topics'].items():
                if (query in topic['title'].lower() or 
                    query in topic['description'].lower() or 
                    query in topic['code'].lower()):
                    results.append({
                        'type': 'topic',
                        'title': f"{section['title']} - {topic['title']}",
                        'description': topic['description'],
                        'url': f'/topic/{section_id}/{topic_id}'
                    })
    
    return render_template('search.html', query=query, results=results)

# Context processor to make sections available in all templates
@app.context_processor
def inject_sections():
    return dict(sections=sql_content)

# Vercel entry point
def handler(request):
    return app(request.environ, lambda *args: None)

# For local development
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
