-- =====================================================
-- MATERI DATABASE SQL - LENGKAP DAN TERSTRUKTUR
-- =====================================================

-- =====================================================
-- BAGIAN 1: SELECT STATEMENT DASAR
-- =====================================================

-- 1.1 Select Semua Data
SELECT * FROM POH;
SELECT * FROM POD;
SELECT * FROM Supplier;
SELECT * FROM Barang;
SELECT * FROM Alat;

-- 1.2 Select dengan Kolom Spesifik
SELECT PONo, Tgl, KodeSupplier, KodeAlat FROM POH;
SELECT PONo, Kodebarang, Jumlah, Harga FROM POD ORDER BY PONo DESC;
SELECT Kode, Nama, Alamat, Kota, Telp, Fax FROM Supplier;
SELECT Kode, Nama, Satuan, StokMin, StokMax, Jenis FROM Barang;
SELECT Kode, Nama, Type, SN FROM Alat;

-- 1.3 Select dengan WHERE Clause
SELECT * FROM POH WHERE PONo = '200123100018';
SELECT * FROM POD WHERE PONo = '200123100018';
SELECT * FROM POD WHERE PONo = '200125030080';

-- 1.4 Select dengan ORDER BY
SELECT * FROM POH ORDER BY TglModify DESC;
SELECT * FROM POD ORDER BY TglModify DESC;

-- =====================================================
-- BAGIAN 2: JOIN OPERATIONS
-- =====================================================

-- 2.1 Inner Join (Implisit)
SELECT PONo, Tgl, h.KodeSupplier, s.Nama AS Supplier, a.Nama AS Alat 
FROM POH h, Supplier s, Alat a
WHERE h.KodeSupplier = s.Kode AND h.KodeAlat = a.Kode;

-- 2.2 Join dengan Agregasi
SELECT s.Nama AS Supplier, a.Nama AS Alat, b.Nama AS ItemBarang, SUM(Jumlah*d.Harga) AS Total 
FROM Supplier s, POH h, POD d, Barang b, Alat a
WHERE a.Kode = h.KodeAlat 
  AND s.Kode = h.KodeSupplier 
  AND h.PONo = d.PONo 
  AND b.Kode = d.KodeBarang
GROUP BY s.Nama, a.Nama, b.Nama;

-- 2.3 Join dengan Explicit Syntax
SELECT Supplier.Nama AS Supplier, Alat.Nama AS Alat, Barang.Nama AS ItemBarang, 
       SUM(Jumlah*POD.Harga) AS Total 
FROM Supplier, POH, POD, Barang, Alat
WHERE Alat.Kode = POH.KodeAlat 
  AND Supplier.Kode = POH.KodeSupplier 
  AND POH.PONo = POD.PONo 
  AND Barang.Kode = POD.KodeBarang
GROUP BY Supplier.Nama, Alat.Nama, Barang.Nama;

-- =====================================================
-- BAGIAN 3: SUBQUERY DAN NESTED QUERY
-- =====================================================

-- 3.1 Subquery dalam SELECT
SELECT PONo, Kodebarang, Jumlah, Harga, 
       (SELECT Sisa FROM PRD WHERE PRDNo = POD.PRDNo) AS SisaPR
FROM POD 
WHERE PONo = '200125030080';

-- 3.2 Subquery dalam FROM (Derived Table)
SELECT * FROM 
(SELECT PONo, Tgl, KodeSupplier, KodeAlat FROM POH) A;

SELECT * FROM 
(SELECT PONo, Tgl, Nama AS NamaSupplier 
 FROM POH, Supplier 
 WHERE Kode = KodeSupplier) A;

-- 3.3 Subquery dengan Agregasi
SELECT Nama, Merk, Type, 
       (SELECT SUM(TotalPO) FROM V2 WHERE Kalat = Kode) AS Total 
FROM Alat;

-- =====================================================
-- BAGIAN 4: UNION OPERATIONS
-- =====================================================

-- 4.1 UNION untuk Menggabungkan Data Masuk dan Keluar
SELECT Kodebarang, Barang, SUM(Masuk) AS TotalMasuk, SUM(Keluar) AS TotalKeluar 
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
GROUP BY KodeBarang, Barang;

-- 4.2 UNION ALL untuk Kalkulasi Stok
SELECT Kodebarang, SUM(Masuk-Keluar) AS Stok 
FROM 
(
    SELECT Kodebarang, SUM(Jumlah) AS Masuk, 0 AS Keluar 
    FROM MasukD 
    GROUP BY Kodebarang
    UNION ALL
    SELECT Kodebarang, 0 AS Masuk, SUM(Jumlah) AS Keluar 
    FROM KeluarD 
    GROUP BY Kodebarang
) A
GROUP BY KodeBarang;

-- =====================================================
-- BAGIAN 5: VIEW MANAGEMENT
-- =====================================================

-- 5.1 Membuat View Sederhana
CREATE VIEW v_TblA AS
SELECT PONo, Tgl, Nama AS NamaSupplier 
FROM POH, Supplier 
WHERE Kode = KodeSupplier;

-- 5.2 View dengan Agregasi
CREATE VIEW V1 AS
SELECT s.Kode, s.Nama AS NamaSupplier, SUM(Jumlah*Harga) AS TotalPO 
FROM POH h, Supplier s, POD d
WHERE s.Kode = h.KodeSupplier AND h.PONo = d.PONo
GROUP BY s.Kode, s.Nama;

-- 5.3 View dengan Multiple Table Join
CREATE VIEW V2 AS 
SELECT a.Kode AS KAlat, s.Kode AS KSupplier, SUM(Jumlah*Harga) AS TotalPO 
FROM Alat a, POH h, POD d, Supplier s 
WHERE a.Kode = h.KodeAlat 
  AND h.PONo = d.PONo 
  AND h.KodeSupplier = s.Kode
GROUP BY a.Kode, s.Kode;

-- 5.4 View dengan HAVING Clause
CREATE VIEW vTotalPO AS 
SELECT s.Nama AS NamaSupplier, a.Nama AS NamaAlat, 
       SUM(Jumlah*d.Harga) AS TotalPO, b.Nama AS NamaBarang 
FROM Supplier s, POH h, POD d, Barang b, Alat a
WHERE s.Kode = h.KodeSupplier 
  AND h.PONo = d.PONo 
  AND d.KodeBarang = b.Kode 
  AND a.Kode = h.KodeAlat 
GROUP BY s.Nama, a.Nama, b.Nama
HAVING SUM(Jumlah*d.Harga) > 1000000;

-- 5.5 Menggunakan View
SELECT * FROM V1;
SELECT * FROM V2;
SELECT * FROM vTotalPO;

-- 5.6 Mengubah View
ALTER VIEW V1 AS
SELECT s.Kode, s.Nama AS NamaSupplier, SUM(Jumlah*Harga) AS TotalPO 
FROM POH h, Supplier s, POD d
WHERE s.Kode = h.KodeSupplier AND h.PONo = d.PONo
GROUP BY s.Kode, s.Nama;

-- =====================================================
-- BAGIAN 6: STORED PROCEDURES
-- =====================================================

-- 6.1 Stored Procedure Tanpa Parameter
CREATE PROCEDURE spRepMasukD AS 
BEGIN
    SELECT d.KodeBarang, Barang, Jumlah 
    FROM MasukD d, Barang b 
    WHERE d.KodeBarang = b.KodeBarang;
END;

-- Eksekusi: EXEC spRepMasukD;

-- 6.2 Stored Procedure dengan Parameter Input
CREATE PROCEDURE spRepMasukDP1 (@vInput CHAR(10)) AS 
BEGIN
    SELECT d.KodeBarang, Barang, Jumlah 
    FROM MasukD d, Barang b 
    WHERE d.KodeBarang = b.KodeBarang 
      AND Barang LIKE @vInput;
END;

-- Eksekusi: EXEC spRepMasukDP1 'Saori%';

-- 6.3 Stored Procedure untuk Insert
CREATE PROCEDURE spInsMasukD (@Nomor CHAR(3), @KodeBarang CHAR(3), @Jumlah INT) AS 
BEGIN
    INSERT INTO MasukD VALUES (@Nomor, @KodeBarang, @Jumlah);
END;

-- Eksekusi: EXEC spInsMasukD '011','005',2;

-- 6.4 Stored Procedure dengan Parameter Output
ALTER PROCEDURE spInsMasukD (
    @Tipe INT, 
    @Nomor CHAR(3), 
    @KodeBarang CHAR(3), 
    @Jumlah INT, 
    @Hasil CHAR(10) OUTPUT
) AS 
BEGIN
    SET @Hasil = '';
    IF @Tipe = 1 
    BEGIN
        IF NOT EXISTS(SELECT KodeBarang FROM MasukD WHERE Nomor = @Nomor) 
        BEGIN
            INSERT INTO MasukD VALUES(@Nomor, @KodeBarang, @Jumlah);
            SET @Hasil = 'Input OK';
        END
        ELSE
            SET @Hasil = 'Data Exists';
    END 
    ELSE 
    BEGIN
        UPDATE MasukD SET KodeBarang = @KodeBarang, Jumlah = @Jumlah 
        WHERE Nomor = @Nomor;
        SET @Hasil = 'Edit OK';
    END
END;

-- 6.5 Stored Procedure untuk Transfer Data
CREATE PROCEDURE spTransferKeluar AS 
BEGIN
    INSERT INTO MasukD SELECT * FROM KeluarD;
END;

-- 6.6 Stored Procedure untuk Delete
ALTER PROCEDURE spDelMasukD (@Jumlah INT) AS 
BEGIN
    DELETE FROM MasukD WHERE Jumlah = @Jumlah;
END;

-- 6.7 Stored Procedure dengan Cursor untuk Koreksi Stok
CREATE PROCEDURE spBetulinStok AS 
BEGIN
    DECLARE @KodeBarang CHAR(5), @Jumlah INT;
    DECLARE crIns CURSOR FOR 
        SELECT KodeBarang, SUM(Masuk-Keluar) AS Stok 
        FROM 
        (
            SELECT KodeBarang, SUM(Jumlah) AS Masuk, 0 AS Keluar 
            FROM MasukD 
            GROUP BY KodeBarang
            UNION ALL
            SELECT KodeBarang, 0 AS Masuk, SUM(Jumlah) AS Keluar 
            FROM KeluarD 
            GROUP BY KodeBarang
        ) A
        GROUP BY KodeBarang;
    
    OPEN crIns;
    FETCH NEXT FROM crIns INTO @KodeBarang, @Jumlah;
    WHILE (@@FETCH_STATUS = 0) 
    BEGIN
        UPDATE Barang SET Stok = @Jumlah WHERE KodeBarang = @KodeBarang;
        FETCH NEXT FROM crIns INTO @KodeBarang, @Jumlah;
    END
    CLOSE crIns;
    DEALLOCATE crIns;
END;

-- =====================================================
-- BAGIAN 7: TRIGGERS
-- =====================================================

-- 7.1 Template Trigger
CREATE TRIGGER NamaTrigger ON NamaTabel FOR INSERT AS 
BEGIN 
    -- Logic trigger di sini
END;

-- 7.2 Trigger untuk Insert (Menambah Stok)
CREATE TRIGGER trMasukD ON MasukD FOR INSERT AS 
BEGIN
    DECLARE @KodeBarang CHAR(5), @Jumlah INT;
    SELECT @KodeBarang = KodeBarang, @Jumlah = Jumlah FROM inserted;
    UPDATE Barang SET Stok = Stok + @Jumlah WHERE KodeBarang = @KodeBarang;
END;

-- 7.3 Trigger untuk Delete (Mengurangi Stok)
CREATE TRIGGER trDelMasukD ON MasukD FOR DELETE AS 
BEGIN 
    DECLARE @KodeBarang CHAR(5), @Jumlah INT;
    SELECT @KodeBarang = KodeBarang, @Jumlah = Jumlah FROM deleted;
    UPDATE Barang SET Stok = Stok - @Jumlah WHERE KodeBarang = @KodeBarang;
END;

-- 7.4 Trigger dengan Cursor untuk Multiple Records
ALTER TRIGGER trUpdateMasukD ON MasukD FOR INSERT, DELETE, UPDATE AS 
BEGIN
    DECLARE @KodeBarang CHAR(5), @Jumlah INT;
    
    -- Handle INSERT
    DECLARE crIns CURSOR FOR SELECT KodeBarang, Jumlah FROM inserted;
    OPEN crIns;
    FETCH NEXT FROM crIns INTO @KodeBarang, @Jumlah;
    WHILE (@@FETCH_STATUS = 0) 
    BEGIN
        UPDATE Barang SET Stok = Stok + @Jumlah WHERE KodeBarang = @KodeBarang;
        FETCH NEXT FROM crIns INTO @KodeBarang, @Jumlah;
    END
    CLOSE crIns;
    DEALLOCATE crIns;

    -- Handle DELETE
    DECLARE crDel CURSOR FOR SELECT KodeBarang, Jumlah FROM deleted;
    OPEN crDel;
    FETCH NEXT FROM crDel INTO @KodeBarang, @Jumlah;
    WHILE (@@FETCH_STATUS = 0) 
    BEGIN
        UPDATE Barang SET Stok = Stok - @Jumlah WHERE KodeBarang = @KodeBarang;
        FETCH NEXT FROM crDel INTO @KodeBarang, @Jumlah;
    END
    CLOSE crDel;
    DEALLOCATE crDel;
END;

-- 7.5 Trigger untuk Tabel KeluarD
ALTER TRIGGER trKeluarD ON KeluarD FOR INSERT, UPDATE, DELETE AS 
BEGIN
    DECLARE @KodeBarang CHAR(10), @Jumlah FLOAT;
    
    -- Handle INSERT/UPDATE
    DECLARE csInsKeluar CURSOR FOR SELECT KodeBarang, Jumlah FROM inserted;
    OPEN csInsKeluar;
    FETCH NEXT FROM csInsKeluar INTO @KodeBarang, @Jumlah;
    WHILE (@@FETCH_STATUS = 0) 
    BEGIN 
        UPDATE Barang SET Stok = Stok - @Jumlah WHERE KodeBarang = @KodeBarang;    
        FETCH NEXT FROM csInsKeluar INTO @KodeBarang, @Jumlah;
    END
    CLOSE csInsKeluar;    
    DEALLOCATE csInsKeluar;

    -- Handle DELETE
    DECLARE csDelKeluar CURSOR FOR SELECT KodeBarang, Jumlah FROM deleted;
    OPEN csDelKeluar;
    FETCH NEXT FROM csDelKeluar INTO @KodeBarang, @Jumlah;
    WHILE (@@FETCH_STATUS = 0) 
    BEGIN 
        UPDATE Barang SET Stok = Stok + @Jumlah WHERE KodeBarang = @KodeBarang;
        FETCH NEXT FROM csDelKeluar INTO @KodeBarang, @Jumlah;
    END
    CLOSE csDelKeluar;
    DEALLOCATE csDelKeluar;
END;

-- =====================================================
-- BAGIAN 8: CURSOR PROGRAMMING
-- =====================================================

-- 8.1 Cursor Sederhana
DECLARE @KodeBarang CHAR(5), @Jumlah INT, @Nomor CHAR(3);
DECLARE crIns CURSOR FOR SELECT Nomor, KodeBarang, Jumlah FROM MasukD WHERE Jumlah = 5;
OPEN crIns;
FETCH NEXT FROM crIns INTO @Nomor, @KodeBarang, @Jumlah;
WHILE (@@FETCH_STATUS = 0) 
BEGIN
    PRINT @Nomor + ' ' + @KodeBarang;
    FETCH NEXT FROM crIns INTO @Nomor, @KodeBarang, @Jumlah;
END
CLOSE crIns;
DEALLOCATE crIns;

-- 8.2 Cursor dengan View
DECLARE @KodeBarang CHAR(5), @Jumlah INT, @Barang CHAR(10);
DECLARE crIns CURSOR FOR SELECT KodeBarang, Barang, Stok FROM vBarang;
OPEN crIns;
FETCH NEXT FROM crIns INTO @KodeBarang, @Barang, @Jumlah;
WHILE (@@FETCH_STATUS = 0) 
BEGIN
    PRINT @Barang + ' ' + @KodeBarang;
    FETCH NEXT FROM crIns INTO @KodeBarang, @Barang, @Jumlah;
END
CLOSE crIns;
DEALLOCATE crIns;

-- =====================================================
-- BAGIAN 9: DML OPERATIONS
-- =====================================================

-- 9.1 INSERT Operations
INSERT INTO MasukD VALUES('014','001',3);
INSERT INTO MasukD (Nomor, KodeBarang, Jumlah) 
    SELECT Nomor, KodeBarang, Jumlah FROM KeluarD;
INSERT INTO MasukD SELECT * FROM KeluarD;

-- 9.2 UPDATE Operations
UPDATE MasukD SET Jumlah = 10 WHERE Nomor = '001';
UPDATE MasukD SET Jumlah = 5 WHERE Nomor = '016';

-- 9.3 DELETE Operations
DELETE FROM MasukD WHERE Jumlah = 3;
DELETE FROM MasukD WHERE Nomor = '013';
DELETE FROM PRD WHERE PRDNo = '200125030053';

-- =====================================================
-- BAGIAN 10: AGGREGATE FUNCTIONS DAN GROUP BY
-- =====================================================

-- 10.1 Basic Aggregation
SELECT SUM(Jumlah) FROM MasukD WHERE KodeBarang = '001';
SELECT COUNT(*) FROM MasukD;

-- 10.2 GROUP BY dengan SUM
SELECT s.Nama AS NamaSupplier, SUM(Jumlah * Harga) AS Total 
FROM Supplier s, POH h, POD d
WHERE s.Kode = h.KodeSupplier AND h.PONo = d.PONo
GROUP BY s.Nama;

-- 10.3 HAVING Clause
SELECT s.Nama AS NamaSupplier, a.Nama AS NamaAlat, 
       SUM(Jumlah*d.Harga) AS TotalPO, b.Nama AS NamaBarang 
FROM Supplier s, POH h, POD d, Barang b, Alat a
WHERE s.Kode = h.KodeSupplier 
  AND h.PONo = d.PONo 
  AND d.KodeBarang = b.Kode 
  AND a.Kode = h.KodeAlat 
GROUP BY s.Nama, a.Nama, b.Nama
HAVING SUM(Jumlah*d.Harga) > 1000000;

-- =====================================================
-- BAGIAN 11: UTILITY COMMANDS
-- =====================================================

-- 11.1 Database Selection
USE BasisData;

-- 11.2 Drop Objects
DROP TRIGGER trDelMasukD;
DROP TRIGGER trMasukD;

-- 11.3 Alter Objects
ALTER VIEW V1 AS SELECT ...;
ALTER TRIGGER trMasukD ON MasukD FOR INSERT AS ...;
ALTER PROCEDURE spInsMasukD (...) AS ...;

-- =====================================================
-- CATATAN PEMBELAJARAN:
-- =====================================================

/*
1. SELECT: Untuk mengambil data dari database
2. JOIN: Untuk menggabungkan data dari multiple tabel
3. SUBQUERY: Query di dalam query untuk logic yang kompleks
4. VIEW: Virtual table untuk menyimpan query yang sering digunakan
5. STORED PROCEDURE: Program tersimpan untuk logic bisnis
6. TRIGGER: Code yang dijalankan otomatis saat ada perubahan data
7. CURSOR: Untuk memproses data baris per baris
8. DML: Data Manipulation Language (INSERT, UPDATE, DELETE)
9. AGGREGATE: Fungsi untuk kalkulasi (SUM, COUNT, AVG, dll)
10. UTILITY: Command untuk manajemen database objects

TIPS BELAJAR:
- Mulai dari SELECT sederhana, lalu kompleks
- Pahami JOIN sebelum ke SUBQUERY
- Latih VIEW untuk menyederhanakan query kompleks
- STORED PROCEDURE untuk logic yang berulang
- TRIGGER untuk automasi dan data integrity
- CURSOR hanya untuk kasus yang tidak bisa diselesaikan dengan set-based operations
*/