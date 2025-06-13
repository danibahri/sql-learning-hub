select * from POH where PONo = '200123100018'
select * from POD where PONo = '200123100018'


select PONo, Tgl, KodeSupplier, KOdeAlat from POH
select PONo, Kodebarang, Jumlah, Harga from POD order by PONo desc

select Kode, Nama, Alamat, Kota, Telp, Fax  from supplier
select Kode, Nama, Satuan, StokMin, StokMax, Jenis from Barang
select Kode, Nama, type, SN from alat

select * from 
(select POno, Tgl, h.KodeSupplier, s.Nama Supplier, a.Nama Alat 
from POH h, Supplier s, Alat a
where h.KodeSupplier = s.KOde and h.KodeAlat = a.Kode) A

alter view V1 as
select s.Kode, s.Nama NamaSupplier, sum(Jumlah*Harga) TotalPO 
from POH h, Supplier s, POD d
where s.Kode = h.KodeSupplier and h.PONo = d.PONo
group by s.Kode, s.Nama

select * from v1

Tampilkan Alat, TotalPO
alter view v2 as 
select a.Kode kalat, s.Kode ksupplier, sum(Jumlah*Harga) TotalPO 
from Alat a, POH h, POD d, Supplier s 
where a.Kode = h.KodeAlat and h.PONo = d.PONo and h.KodeSupplier = s.Kode
group by a.KOde, s.Kode

select Nama, Merk, Type, Total = (select sum(TotalPO) from V2 where Kalat = Kode) from alat
select * from v2

select s.Nama Supplier, a.Nama Alat, b.Nama ItemBarang, SUM(Jumlah*d.Harga) Total 
from Supplier s, POH h, POD d, Barang b, Alat a
where a.Kode = h.KodeAlat and s.Kode = h.KodeSupplier and h.PONo = d.PONo and b.Kode = d.KodeBarang
group by s.Nama, a.nama, b.Nama
 

select Supplier.Nama as Supplier, Alat.Nama as Alat, Barang.Nama as ItemBarang, SUM(Jumlah*POD.Harga) as Total 
from Supplier, POH, POD, Barang, Alat
where Alat.Kode = POH.KodeAlat and Supplier.Kode = POH.KodeSupplier and POH.PONo = POD.PONo and Barang.Kode = POD.KodeBarang
group by Supplier.Nama, alat.nama, Barang.Nama

select s.Nama NamaSupplier, Jumlah * Harga Total from Supplier s, POH h, POD d
where s.Kode = h.KOdeSupplier and h.PONo = d.PONo

select s.Nama NamaSupplier, sum(Jumlah * Harga) Total from Supplier s, POH h, POD d
where s.Kode = h.KOdeSupplier and h.PONo = d.PONo
group by s.Nama

create view vTotalPO as 
select s.Nama NamaSupplier, a.Nama NamaAlat, sum(Jumlah*d.Harga) TotalPO, b.Nama NamaBarang 
from Supplier s, POH h, POD d, Barang b, Alat a
where s.kode = h.KOdeSupplier and h.PONo = d.PONo 
and d.KOdebarang = b.Kode and a.KOde = h.KOdeAlat 
group by s.Nama, a.Nama, b.Nama
having SUM(Jumlah*d.Harga) > 1000000

select * from vTotalPO

use basisdata

select * from MasukD
select * from KeluarD
select * from Barang

select Kodebarang, Barang, sum(Masuk) TotalMasuk, sum(Keluar) TotalKeluar from 
(select d.KOdebarang, b.Barang, Jumlah Masuk, 0 Keluar, Stok 
from MasukD d, Barang b where d.KodeBarang = b.KodeBarang
union 
select k.KOdebarang, b.Barang, 0, Jumlah, Stok 
from KeluarD k, Barang b where k.KodeBarang = b.KodeBarang) A
group by KodeBarang, Barang


-- Nested Query
select * from 
(select PONo, Tgl, KodeSupplier, KOdeAlat from POH) A

create view v_TblA as
select PONo, Tgl, Nama NamaSupplier from POH, Supplier where Kode = KodeSupplier

select * from 
(select PONo, Tgl, Nama NamaSupplier from POH, Supplier where Kode = KodeSupplier) A

select * from v_TblA