USE [AdventureWorksOBP]
GO
/****** Object:  StoredProcedure [dbo].[CheckLogin]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------

CREATE PROC [dbo].[CheckLogin]
	@Email nvarchar(50),
	@Lozinka nvarchar(50)
AS
BEGIN
	SELECT * FROM Korisnik WHERE Email = @Email AND Lozinka = @Lozinka
END
GO
/****** Object:  StoredProcedure [dbo].[CreateKategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------
CREATE PROC [dbo].[CreateKategorija]

	@Naziv nvarchar(50)
AS
BEGIN
	INSERT INTO Kategorija(Naziv) VALUES (@Naziv)
END
GO
/****** Object:  StoredProcedure [dbo].[CreatePotkategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
CREATE PROC [dbo].[CreatePotkategorija]
@Naziv nvarchar(50),
@KategorijaID int
AS
BEGIN
	INSERT INTO Potkategorija(KategorijaID, Naziv) VALUES (@KategorijaID, @Naziv)
END
GO
/****** Object:  StoredProcedure [dbo].[CreateProizvod]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------
CREATE PROC [dbo].[CreateProizvod] 
	@Naziv nvarchar(50),
	@BrojProizvoda nvarchar(25),
	@Boja nvarchar(15),
	@MinimalnaKolicinaNaSkladistu smallint,
	@CijenaBezPDV money,
	@PotkategorijaID int
AS
BEGIN
	INSERT INTO Proizvod(Naziv, BrojProizvoda, Boja, MinimalnaKolicinaNaSkladistu, CijenaBezPDV, PotkategorijaID)
	VALUES(@Naziv, @BrojProizvoda, @Boja, @MinimalnaKolicinaNaSkladistu, @CijenaBezPDV, @PotkategorijaID)
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteKategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------
CREATE PROC [dbo].[DeleteKategorija]
	@IDKategorija int
AS
BEGIN
	DELETE FROM Stavka WHERE ProizvodID IN (SELECT IDProizvod FROM Proizvod WHERE PotkategorijaID IN (SELECT IDPotkategorija FROM Potkategorija WHERE KategorijaID = @IDKategorija))
	DELETE FROM Proizvod WHERE PotkategorijaID IN (SELECT IDPotkategorija FROM Potkategorija WHERE KategorijaID = @IDKategorija)
	DELETE FROM Potkategorija WHERE KategorijaID = @IDKategorija
	DELETE FROM Kategorija WHERE IDKategorija = @IDKategorija
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteKupac]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DeleteKupac]
	@IDKupac int
as
begin
	delete from Racun where KupacID=@IDKupac
	delete from Stavka where RacunID=RacunID
	delete from Kupac where IDKupac=@IDKupac
end
GO
/****** Object:  StoredProcedure [dbo].[DeletePotkategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------------
CREATE PROC [dbo].[DeletePotkategorija]
	@IDPotkategorija int
AS
BEGIN
	DELETE FROM Stavka WHERE ProizvodID IN (SELECT IDProizvod FROM Proizvod WHERE PotkategorijaID = @IDPotkategorija)
	DELETE FROM Proizvod WHERE PotkategorijaID = @IDPotkategorija
	DELETE FROM Potkategorija WHERE IDPotkategorija = @IDPotkategorija
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteProizvod]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------
CREATE PROC [dbo].[DeleteProizvod]
	@IDProizvod int
AS
BEGIN
	DELETE FROM Stavka WHERE ProizvodID = @IDProizvod
	DELETE FROM Proizvod WHERE IDProizvod = @IDProizvod
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiBrojKupaca]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------
CREATE PROC [dbo].[DohvatiBrojKupaca]
AS
BEGIN
	SELECT COUNT(*) FROM Kupac
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiGradove]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DohvatiGradove]
AS
BEGIN
	SELECT * FROM Grad
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiKupca]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DohvatiKupca]
	@IDKupac int
AS
BEGIN
	SELECT * FROM Kupac as k
	JOIN Grad as g
	ON k.GradID = g.IDGrad
	WHERE k.IDKupac = @IDKupac
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiKupca15]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------

create proc [dbo].[DohvatiKupca15]
	@IDKupac int
as
BEGIN
	SELECT * FROM Kupac WHERE IDKupac = @IDKupac
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiKupce]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------
----------------------ISTO VRAĆA, ALI TOČNO 10 KUPACA---------------
CREATE PROC [dbo].[DohvatiKupce]
AS
BEGIN
	SELECT top 50 * FROM Kupac AS k 
	JOIN Grad as g 
	ON k.GradID = g.IDGrad
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiKupce15]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------
-------------------------------------------------------------------
-------HVATA SAMO PODATAK ZA KUPCA, BEZ POVEZIVANJA SA GRADOM--------

create proc [dbo].[DohvatiKupce15]
as
BEGIN
	SELECT TOP 100 * FROM Kupac
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiRacuneKupca]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------
CREATE PROC [dbo].[DohvatiRacuneKupca]
	@IDKupac int
AS
BEGIN
	SELECT * FROM Racun WHERE KupacID = @IDKupac
END
GO
/****** Object:  StoredProcedure [dbo].[DohvatiRacuneSvihKupaca]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DohvatiRacuneSvihKupaca]
@IDRacun int
as
begin
select r.BrojRacuna,p.Naziv,s.Kolicina,pt.Naziv as Potkategorija,kt.Naziv as Kategorija,CONCAT(kom.Ime,' ',kom.Prezime) as Komercijalist from Stavka as s
inner join Racun as r on s.RacunID=r.IDRacun
inner join Proizvod as p on s.ProizvodID=p.IDProizvod
inner join Potkategorija as pt on p.PotkategorijaID=pt.IDPotkategorija
inner join Kategorija as kt on pt.KategorijaID=kt.IDKategorija
inner join KreditnaKartica as kk on r.KreditnaKarticaID=kk.IDKreditnaKartica
inner join Komercijalist as kom on r.KomercijalistID=kom.IDKomercijalist
where r.IDRacun=@IDRacun
end
GO
/****** Object:  StoredProcedure [dbo].[GetGradovi]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------VRAĆA GRADOVE ZA NEKU DRŽAVU-----------------
CREATE PROC [dbo].[GetGradovi]
	@DrzavaID int
AS
BEGIN
	SELECT * FROM Grad WHERE DrzavaID = @DrzavaID
	ORDER BY Naziv ASC
END
GO
/****** Object:  StoredProcedure [dbo].[GetKategorijaById]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------
CREATE PROC [dbo].[GetKategorijaById]
	@IDKategorija int
AS
BEGIN
	SELECT * FROM Kategorija WHERE IDKategorija = @IDKategorija
END
GO
/****** Object:  StoredProcedure [dbo].[GetKategorije]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------

CREATE PROC [dbo].[GetKategorije]
AS
BEGIN
	SELECT * FROM Kategorija
END
GO
/****** Object:  StoredProcedure [dbo].[GetKupac]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------

CREATE PROC [dbo].[GetKupac]
	@IDKupac int
AS
BEGIN
	SELECT k.*,g.DrzavaID, g.Naziv, g.IDGrad FROM Kupac AS k
	JOIN Grad as g
	ON k.GradID = g.IDGrad
	WHERE IDKupac = @IDKupac
END
GO
/****** Object:  StoredProcedure [dbo].[GetNameFromKupac]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[GetNameFromKupac]
	@Ime nvarchar(50),
	@Prezime nvarchar(50)
as
begin
	select*from Kupac where Ime=@Ime and Prezime=@Prezime
end
GO
/****** Object:  StoredProcedure [dbo].[GetPotkategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------
CREATE PROC [dbo].[GetPotkategorija]
AS
BEGIN
	SELECT * FROM Potkategorija as pk
	JOIN Kategorija as k
	ON k.IDKategorija = pk.KategorijaID
END
GO
/****** Object:  StoredProcedure [dbo].[GetPotkategorijaById]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------------------------------------------------------------------
CREATE PROC [dbo].[GetPotkategorijaById] 
	@IDPotkategorija int
AS
BEGIN
	SELECT * FROM Potkategorija as pk
	INNER JOIN Kategorija as k
	ON pk.KategorijaID = k.IDKategorija
	WHERE pk.IDPotkategorija = @IDPotkategorija
END
GO
/****** Object:  StoredProcedure [dbo].[GetProizvodById]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------
CREATE PROC [dbo].[GetProizvodById]
	@IDProizvod int
AS
BEGIN
	SELECT * FROM Proizvod as p
	 WHERE IDProizvod = @IDProizvod
END
GO
/****** Object:  StoredProcedure [dbo].[GetProizvodi]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------
CREATE PROC [dbo].[GetProizvodi]
AS
BEGIN	
	SELECT * FROM Proizvod as p
	JOIN Potkategorija as pk
	ON p.PotkategorijaID = pk.IDPotkategorija
	JOIN Kategorija as k
	ON k.IDKategorija = pk.KategorijaID
END
GO
/****** Object:  StoredProcedure [dbo].[InsertKupac]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------
create proc [dbo].[InsertKupac]
	@Ime nvarchar(50),
	@Prezime nvarchar(50),
	@Email nvarchar(50),
	@Telefon nvarchar(50),
	@GradID int
as 
begin
INSERT INTO Kupac(Ime, Prezime,Email,Telefon,GradID) VALUES (@Ime, @Prezime, @Email, @Telefon, @GradID)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertUpdateKomercijalist]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[InsertUpdateKomercijalist]
@Ime nvarchar(50),
@Prezime nvarchar(50)
as
begin
declare @IDKomercijalist int
if exists
    (select* from Komercijalist where Ime=@Ime and Prezime=@Prezime)
        return -1
else 
    begin
        insert into Komercijalist (Ime,Prezime,StalniZaposlenik) values(@Ime,@Prezime,0)
            set @IDKomercijalist=SCOPE_IDENTITY()
                return @IDKomercijalist
    end
end
GO
/****** Object:  StoredProcedure [dbo].[SelectKupci]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------VRAĆA ODREĐEN BROJ KUPACA----------------------
CREATE PROC [dbo].[SelectKupci]
	@amount INT
AS
BEGIN
	SELECT TOP (@amount) k.*, g.DrzavaID, g.Naziv, g.IDGrad FROM Kupac AS k 
	JOIN Grad as g 
	ON k.GradID = g.IDGrad
END
GO
/****** Object:  StoredProcedure [dbo].[SviPodaciNekogRacuna]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SviPodaciNekogRacuna]
	@IDRacun int
AS
BEGIN
select r.BrojRacuna,p.Naziv as NazivProizvoda,s.Kolicina as Kolicina, pk.Naziv as NazivPotkategorije,kat.Naziv as NazivKategorije, kk.Tip as TipKK,  CONCAT (kom.Ime, ' ', kom.Prezime) as Komercijalist from Racun as r
inner join Stavka as s 
on r.IDRacun=s.RacunID
inner join KreditnaKartica as kk
on r.KreditnaKarticaID=kk.IDKreditnaKartica
inner join Komercijalist as kom
on r.KomercijalistID=kom.IDKomercijalist
inner join Proizvod as p
on s.ProizvodID=p.IDProizvod
inner join Potkategorija as pk
on p.PotkategorijaID=pk.IDPotkategorija
inner join Kategorija as kat
on pk.KategorijaID=kat.IDKategorija
where r.IDRacun=@IDRacun
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateKategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------

CREATE PROC [dbo].[UpdateKategorija]
	@IDKategorija int,
	@Naziv nvarchar(50)
AS
BEGIN
	UPDATE Kategorija
	SET Naziv = @Naziv
	WHERE IDKategorija = @IDKategorija
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateKupac]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------
create proc [dbo].[UpdateKupac]
	@IDKupac int,
	@Ime nvarchar(50),
	@Prezime nvarchar(50),
	@Email nvarchar(50),
	@Telefon nvarchar(50),
	@GradID int
as 
begin
	update Kupac set Ime=@Ime, Prezime=@Prezime, Email=@Email, Telefon=@Telefon, GradID=@GradID where IDKupac=@IDKupac
END
GO
/****** Object:  StoredProcedure [dbo].[UpdatePotkategorija]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------------------

CREATE PROC [dbo].[UpdatePotkategorija] 
	@IDPotkategorija int,
	@KategorijaID int,
	@Naziv nvarchar(50)
AS
BEGIN
	UPDATE Potkategorija
	SET KategorijaID = @KategorijaID, Naziv = @Naziv
	WHERE IDPotkategorija = @IDPotkategorija
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateProizvod]    Script Date: 10.2.2022. 8:56:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------
CREATE PROC [dbo].[UpdateProizvod] 
	@IDProizvod int,
	@Naziv nvarchar(50),
	@BrojProizvoda nvarchar(25),
	@Boja nvarchar(15),
	@MinimalnaKolicinaNaSkladistu smallint,
	@CijenaBezPDV money,
	@PotkategorijaID int
AS
BEGIN
	UPDATE Proizvod
	SET Naziv = @Naziv, BrojProizvoda = @BrojProizvoda, Boja = @Boja, MinimalnaKolicinaNaSkladistu = @MinimalnaKolicinaNaSkladistu, CijenaBezPDV = @CijenaBezPDV, PotkategorijaID = @PotkategorijaID
	WHERE IDProizvod = @IDProizvod
END
GO
