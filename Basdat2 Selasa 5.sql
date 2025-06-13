select * from POH order by tglmodify desc
select * from POD order by tglmodify desc


select PONo, Kodebarang, Jumlah, Harga, PRDNo from POD where PONo = '200125030080'

delete from PRD where PRDNo = '200125030053'

select PONo, Kodebarang, Jumlah, Harga, 
SisaPR = (select sisa from PRD where PRDNo = POD.PRDNo)
from POD where PONo = '200125030080'

select PONo, Kodebarang, Jumlah, Harga, 
(select sisa from PRD where PRDNo = POD.PRDNo) SisaPR
from POD where PONo = '200125030080'


-- harus ada data di dua table.. 
select d.PONo, d.Kodebarang, d.Jumlah, d.Harga, r.Sisa 
from POD d, PRD r where PONo = '200125030080' and d.PRDNo = r.PRDNO

select d.PONo, d.Kodebarang, d.Jumlah, d.Harga, r.Sisa 
from POD d, PRD r where PONo = '200125030080' and d.PRDNo *= r.PRDNO