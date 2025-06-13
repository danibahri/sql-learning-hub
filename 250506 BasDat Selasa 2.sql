create trigger namatrigger on namatable for insert as begin 

end

select * from masukD order by nomor
select * from barang

delete from MasukD where jumlah = 3

update MasukD set jumlah = 10 where nomor = '001'

select * from keluard

-- copy transfer data di keluard.. di Insert ke masukD
insert into MasukD (Nomor, Kodebarang, Jumlah) select Nomor, Kodebarang, Jumlah from KeluarD
-- atau
insert into MasukD select * from KeluarD


insert into MasukD Values('014','001',3)
delete from masukD where nomor = '013'

alter trigger trMasukD on MasukD for insert as begin
	update Barang set Stok = Stok + (select jumlah from inserted) 
		where KodeBarang = (select KodeBarang from inserted)
end

alter trigger trMasukD on MasukD for insert as begin
	declare @KOdebarang char(5), @jumlah int -- variable
	select @KOdebarang = Kodebarang, @jumlah = Jumlah from inserted 
	-- inserted adalah table yang muncul otomatis saat trigger running
	update Barang set Stok = Stok + @jumlah where KodeBarang = @KOdebarang
end

select * from Barang
select * from masukD order by nomor
select * from KeluarD

insert into MasukD select * from KeluarD

insert into MasukD Values('016','003',3)
delete from MasukD where Nomor = '015'
update MasukD set Jumlah = 5 where nomor = '016'

create trigger trDelMasukD on MasukD for delete as begin 
	declare @KOdebarang char(5), @jumlah int -- variable
	select @KOdebarang = Kodebarang, @jumlah = Jumlah from deleted
	-- deleted adalah table yang muncul otomatis saat trigger running
	update Barang set Stok = Stok - @jumlah where KodeBarang = @KOdebarang
end

drop trigger trDelMasukD
drop trigger trMasukD

-- ada kesalahan saat delete, insert dan update secara banyak data
alter trigger trUpdateMasukD on MasukD for insert, delete, update as begin
	declare @KOdebarang char(5), @jumlah int -- variable
	select @KOdebarang = Kodebarang, @jumlah = Jumlah from inserted 
	-- inserted adalah table yang muncul otomatis saat trigger running
	update Barang set Stok = Stok + @jumlah where KodeBarang = @KOdebarang
	select @KOdebarang = Kodebarang, @jumlah = Jumlah from deleted
	-- deleted adalah table yang muncul otomatis saat trigger running
	update Barang set Stok = Stok - @jumlah where KodeBarang = @KOdebarang
end

-- diperbaiki menggunakan cursor
alter trigger trUpdateMasukD on MasukD for insert, delete, update as begin
	declare @KOdebarang char(5), @jumlah int -- variable
	declare crIns cursor for select Kodebarang, jumlah from inserted
	open crIns
	fetch next from crIns into @KOdebarang, @jumlah
	while (@@fetch_status = 0) begin
		update Barang set Stok = Stok + @jumlah where KodeBarang = @KOdebarang
		fetch next from crIns into @KOdebarang, @jumlah
	end
	close crIns
	deallocate crIns

	declare crDel cursor for select Kodebarang, jumlah from Deleted
	open crDel
	fetch next from crDel into @KOdebarang, @jumlah
	while (@@fetch_status = 0) begin
		update Barang set Stok = Stok - @jumlah where KodeBarang = @KOdebarang
		fetch next from crDel into @KOdebarang, @jumlah
	end
	Close crDel
	Deallocate crDel
end

delete from masukD where jumlah = 3
select sum(jumlah) from masukD where KodeBarang = '001'
select * from KeluarD
select * from barang

insert into MasukD select * from KeluarD
delete from MasukD where jumlah = 3

exec spBetulinStok
create procedure spBetulinStok as begin
	declare @KOdebarang char(5), @jumlah int -- variable
	declare crIns cursor for select Kodebarang, Sum(Masuk-Keluar) Stok from 
		(select Kodebarang, sum(jumlah) Masuk, 0 Keluar from MasukD group by Kodebarang
		union all
		select Kodebarang, 0 Masuk, sum(Jumlah) Keluar from KeluarD group by Kodebarang) a
		group by KodeBarang
	open crIns
	fetch next from crIns into @KOdebarang, @jumlah
	while (@@fetch_status = 0) begin
		update Barang set Stok = @jumlah where KodeBarang = @KOdebarang
		fetch next from crINs into @KOdebarang, @jumlah
	end
	Close crIns
	Deallocate crIns
end



alter procedure spInsMasukD (@Nomor char(3), @Kodebarang char(3), @Jumlah int) as begin 
	insert into MasukD Values(@Nomor, @Kodebarang, @Jumlah)
end

exec spInsMasukD '013','002',3


CREATE trigger [dbo].[trDUpdateMasukD] on [dbo].[MasukD] for insert, delete, update as begin
	declare @KOdebarang char(5), @jumlah int
	select @KOdebarang = Kodebarang, @jumlah = Jumlah from deleted -- data lama yang ada di masukd
	update Barang set Stok = Stok - @jumlah where KodeBarang = @KOdebarang

	select @KOdebarang = Kodebarang, @jumlah = Jumlah from inserted -- diubah menjadi data yang baru
	update Barang set Stok = Stok + @jumlah where KodeBarang = @KOdebarang
end






CREATE trigger [dbo].[trDelMasukD] on [dbo].[MasukD] for delete as begin
	declare @KOdebarang char(5), @jumlah int
	declare crDel cursor for select Kodebarang, jumlah from Deleted
	open crDel
	fetch next from crDel into @KOdebarang, @jumlah
	while (@@fetch_status = 0) begin
		update Barang set Stok = Stok - @jumlah where KodeBarang = @KOdebarang
		fetch next from crDel into @KOdebarang, @jumlah
	end
	close crDel
	deallocate crDel
end

GO

/****** Object:  Trigger [dbo].[trDUpdateMasukD]    Script Date: 06/05/2025 07.36.06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Trigger [dbo].[trMasukD]    Script Date: 06/05/2025 07.36.06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER trigger [dbo].[trKeluarD] on [dbo].[KeluarD]
for insert, update, delete as begin
	declare @KodeBarang char(10), @Jumlah float
	declare csInsKeluar cursor for select KodeBarang, Jumlah from inserted
	open csInsKeluar
	fetch next from csInsKeluar into @KodeBarang, @Jumlah
	while (@@fetch_status = 0) begin 
		update Barang set Stok = Stok - @Jumlah where KodeBarang = @KodeBarang	
		fetch next from csInsKeluar into @KodeBarang, @Jumlah
	end
	close csInsKeluar	
	deallocate csInsKeluar

	declare csDelKeluar cursor for select KodeBarang, Jumlah from deleted
	open csDelKeluar
	fetch next from csDelKeluar into @KodeBarang, @Jumlah
	while (@@fetch_status = 0) begin 
		update Barang set Stok = Stok + @Jumlah where KodeBarang = @KodeBarang
		fetch next from csDelKeluar into @KodeBarang, @Jumlah
	end
	close csDelKeluar
	deallocate csDelKeluar
end
