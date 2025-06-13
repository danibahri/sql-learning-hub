select * from MasukD
select * from KeluarD
select * from barang

-- store procedure tanpa parameter
create procedure spRepMasukD as begin
	select d.KodeBarang, Barang, Jumlah from MasukD d, Barang b where d.Kodebarang = b.Kodebarang
end

exec spRepMasukD

create procedure spTransferKeluar as begin
	insert into MasukD select * from KeluarD
end

exec spTransferKeluar

alter procedure spDelMasukD (@jumlah int) as begin
	delete from MasukD where jumlah = @jumlah
end

select * from masukd
exec spDelMasukD 3

-- store procedure dengan parameter input
create procedure spRepMasukDP1 (@vInput char(10)) as begin
	select d.KodeBarang, Barang, Jumlah from MasukD d, Barang b where d.Kodebarang = b.Kodebarang 
	and barang like @vInput
end

exec spRepMasukDP1 'Saori%'

alter procedure spInsMasukD (@Nomor char(3), @Kodebarang char(3), @Jumlah int) as begin
	insert into MasukD Values (@Nomor, @Kodebarang, @Jumlah)
end

exec spInsMasukD '011','005',2
select * from MasukD

ALTER procedure spInsMasukD (@tipe int, @Nomor char(3), @KOdeBarang char(3), @jumlah int, @hasil char(10) OUTPUT) as begin
set @hasil = '' -- ada yang kurang bener
	if @tipe = 1 begin
		if not exists(select KodeBarang from MasukD where Nomor = @Nomor) begin
			insert into MasukD Values(@Nomor,@KOdeBarang, @jumlah)
			set @hasil = 'Input ok'
		end
		set @hasil = 'Gak ngap2in'
	end else begin
		update MasukD set KodeBarang = @KOdeBarang, Jumlah = @jumlah where Nomor = @Nomor
		set @hasil = 'Edit ok'
	end
end
