--CREATE VIEW V_CONTACT_INFO AS
--SELECT FirstName, MiddleName, LastName
--FROM Person.Person
--GO
--SELECT * FROM V_CONTACT_INFO
--DROP VIEW V_CONTACT_INFO

CREATE VIEW V_EMPLOYEES AS
SELECT p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person AS P ON e.BusinessEntityID = p.BusinessEntityID;
GO

SELECT * FROM V_EMPLOYEES
GO

ALTER VIEW V_EMPLOYEES AS
SELECT p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person AS P ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName LIKE '%B%'
GO

sp_helptext 'V_EMPLOYEES'
GO

sp_depends 'V_EMPLOYEES'
GO

CREATE VIEW OrderRejects
WITH ENCRYPTION AS
SELECT PurchaseOrderID, ReceivedQty, RejectedQty, RejectedQty/ReceivedQty AS RejectRatio, Duedate
FROM Purchasing.PurchaseOrderDetail
WHERE RejectedQty/ReceivedQty = 1
AND Duedate > CONVERT(DATETIME,'20010630',101);
GO

DROP VIEW OrderRejects
GO

select * from OrderRejects
GO

sp_helptext 'OrderRejects'
GO

ALTER VIEW V_EMPLOYEES AS
SELECT p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
FROM HumanResources.Employee e
JOIN Person.Person AS P ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName LIKE '%B%'
WITH CHECK OPTION
GO

SELECT * FROM V_EMPLOYEES
GO

UPDATE V_EMPLOYEES SET FirstName = 'Bryana' WHERE LastName = 'Baker'
GO

CREATE VIEW V_EMPLOYEESES WITH SCHEMABINDING AS
SELECT FirstName, MiddleName, LastName, EmailPromotion
FROM Person.Person
GO
SELECT * FROM V_EMPLOYEESES
GO

CREATE UNIQUE CLUSTERED INDEX IX_Contact_Email_2
ON V_EMPLOYEESES(EmailPromotion)
go

exec sp_rename V_EMPLOYEES, V_EmployeesInfo
SELECT * FROM V_EmployeesInfo
GO


--PROCEDURE STORE

CREATE PROCEDURE sp_DisplayEmployeesHireYear
@HireYear INT
AS
SELECT *FROM HumanResources.Employee
WHERE DATEPART(YY,HireDate) = @HireYear
GO

EXECUTE sp_DisplayEmployeesHireYear 2009
GO

CREATE PROCEDURE sp_EmployeesHireYearCount
@HireYear INT,
@Count INT OUTPUT
AS
SELECT @Count = COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
DECLARE @Number INT
EXECUTE sp_EmployeesHireYearCount 2009, @Number OUTPUT
PRINT @Number
GO

CREATE PROCEDURE sp_EmployeesHireYearCount2
@HireYear INT
AS
DECLARE @Count INT
SELECT @Count = COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate) = @HireYear
RETURN @Count
GO

DECLARE @Number INT
EXECUTE @Number = sp_EmployeesHireYearCount2 2009
PRINT @Number
go


CREATE TABLE #Student
(
Rollno varchar(6) COnSTRAINT PK_Student PRIMARY KEY,
FullName nvarchar(100),
Birthday datetime constraint df_studentbirthday default dateadd(yy, -18, getdate())
)
go
select * from #Student

create procedure #sp_InsertStudents
@Rollno varchar(6),
@fullname nvarchar(100),
@birthday datetime
as begin 
if(@birthday  is NULL)
	set @birthday=dateadd(yy,-18,getdate())
	insert into #Student(Rollno,FullName,Birthday)
	values(@Rollno,@fullname,@birthday)
	end
	go

exec #sp_InsertStudents 'A12345', 'abc', null
exec #sp_InsertStudents 'B53321', 'nbs','12/24/2011'

CREATE PROCEDURE Cal_square @num int=0 as
begin
return (@num*@num);
end
go
declare @square int;
exec @square = Cal_square 10;
print @square;
go

select OBJECT_DEFINITION(object_ID('HumanResources.uspUpdateEmployeePersonalInfo')) as definition

select definition from sys.sql_modules
where object_id = OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
go

sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
go

create procedure sp_displayemployee as
select * from HumanResources.Employee
go
alter procedure sp_displayemployee as
select * from HumanResources.Employee
where Gender = 'F'
go

exec sp_displayemployee

drop procedure sp_displayemployee

create procedure sp_employeeHire2
as
begin 
execute sp_DisplayEmployeesHireYear 2009
declare @Number int
execute sp_EmployeesHireYearCount 2009, @Number OUTPUT
print N'Số nhân viên vào làm năm 2009 là: ' + convert(varchar(3),@Number)
end
go
exec sp_employeeHire2

alter procedure sp_EmployeeHire2
@HireYear int
as
begin
begin try
execute sp_DisplayEmployeesHireYear @HireYear
declare @Number int
execute sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
print N'Số nhân viên vào làm năm là: ' + convert(varchar(3), @Number)
end try
begin catch
print N'Cố lỗi xảy ra trong quá tình thực hiện lưu trữ'
end catch
print N'Kết thúc lưu trữ'
end
go

exec sp_EmployeeHire2 2009

alter procedure sp_EmployeeHire2
@HireYear int
as
begin
execute sp_DisplayEmployeesHireYear @HireYear
declare @Number int
execute sp_EmployeesHireYearCount @HireYear, @Number OUTPUT, '123'
if @@ERROR <> 0
print N'Có lỗi xảy ra khi thực hiện quá trình lưu trữ'
print N'Số nhân viên vào làm năm là: ' + Convert(varchar(3), @Number)
end
go

exec sp_EmployeeHire2 1999
GO

--TRIGGER

create database test
go
use test
go

create table Class
(
ID int primary key identity,
Name varchar(10),
Deleted int not null default(0)
)
go
create table Student
(
ID int primary key identity,
Name varchar(30),
Age int,
ClassID int foreign key references Class(ID),
Deleted int not null default(0)
)
go
insert into Class(Name) values ('C11011')
go

create trigger CheckAgeOnInsert
on Student
for insert
as
	begin 
		if exists(select * from inserted where age<16)
		begin
		print 'Tuoi khong the nho hon 16';
			rollback transaction;
		end
	end
go

drop trigger CheckAgeOnInsert

insert into Student values('Nguyen Van A',15,1,0)
insert into Student values('Nguyen Van B',17,1,0)
go

create trigger CheckAgeOnUpdate
on Student
for update
as
	begin
		if exists(select * from inserted I inner join deleted D
			on I.ID = D.ID where D.Age>i.Age)
		begin
			print 'Tuoi moi khong the nho hon tuoi cu';
			rollback transaction;
		end
	end
go

insert into Student values('Nguyen Van C',22,1,0)
update Student set Age = 20 where Name Like 'Nguyen Van C';
go

create trigger DeleteStudent
on Student
for delete
as
	begin
		declare @ID int;
		select @ID = ID from deleted;
		rollback transaction;
		update Student set Deleted=1 where ID=@ID;
	end
go
drop trigger DeleteStudent
go
alter trigger DeleteStudent
on Student
for delete
as
	begin
		update Student set Deleted=1 where ID in(select ID from deleted);
		rollback transaction;
	end
go

insert into Student values('Kun',20,1,0)
select *from Student
delete from Student where ID = 3
go



--Assignment 1

--1,2
CREATE DATABASE Kho
USE Kho
GO

CREATE TABLE KhachHang
(
Ma_KH CHAR(5) PRIMARY KEY,
TenKH VARCHAR(30),
DiaChi VARCHAR(50),
DienThoai BIGINT,
Trangthai VARCHAR(10)
)

CREATE TABLE SanPham
(
Ma_SP VARCHAR(20) PRIMARY KEY,
Ten_SP VARCHAR(20),
Mota_SP VARCHAR(20),
DonVi VARCHAR(10),
Gia MONEY,
Trangthai VARCHAR(10),
Soluongton INT
)

CREATE TABLE Hoadon
(
Ma_HD CHAR(5) PRIMARY KEY,
MA_KH CHAR(5) CONSTRAINT FK_MaKH FOREIGN KEY(Ma_KH) REFERENCES KhachHang(Ma_KH),
Ngay_dat_hang DATETIME,
Trangthai VARCHAR(10)
)

CREATE TABLE Hoadonchitiet
(
Ma_HD CHAR(5) CONSTRAINT FK_MaHD FOREIGN KEY(Ma_HD) REFERENCES Hoadon(Ma_HD),
Ma_SP VARCHAR(20) CONSTRAINT FK_MaSP FOREIGN KEY(Ma_SP) REFERENCES SanPham(Ma_SP),
Gia MONEY,
Soluong INT,
Thanhtien Money,
)
GO

--3 Chen them du lieu vao bang
INSERT INTO KhachHang VALUES('KH01','Ta Hoang Ha','Gia Lam - Ha Noi','0966783049','Good')
INSERT INTO KhachHang VALUES('KH02','Nguyen Van An','111 Nguyen Trai - Thanh Xuan - Ha Noi','0987654321','Good')

INSERT INTO SanPham VALUES('SP01','May tinh T450','May nhap moi','Chiec','1000','Con hang','1')
INSERT INTO SanPham VALUES('SP02','Dien Thoai Nokia5670','Dien thoai dang hot','Chiec','200','Con hang','2')
INSERT INTO SanPham VALUES('SP03','May in Samsung 450','May in dang e','Chiec','100','Con hang','1')

INSERT INTO Hoadon VALUES('HD01','KH02','2009-11-18','Da giao')
INSERT INTO Hoadon VALUES('HD02','KH01','2009-11-18','Dang XL')
UPDATE Hoadon SET Trangthai = 'Da mua' WHERE Ngay_dat_hang = '2009-11-18'

INSERT INTO Hoadonchitiet VALUES('HD01','SP02','200','2','400')
INSERT INTO Hoadonchitiet VALUES('HD01','SP01','1000','1','1000')
INSERT INTO Hoadonchitiet VALUES('HD01','SP03','100','1','100')

INSERT INTO Hoadonchitiet VALUES('HD02','SP02','200','2','400')
INSERT INTO Hoadonchitiet VALUES('HD02','SP01','1000','1','1000')
INSERT INTO Hoadonchitiet VALUES('HD02','SP03','100','1','100')
GO

--4 Cau lenh truy van
--a) Liet ke danh sach khach hang da mua o cua hang
SELECT TenKH, Hoadon.Trangthai FROM Hoadon
INNER JOIN KhachHang ON Hoadon.MA_KH = KhachHang.Ma_KH
WHERE Hoadon.Trangthai = 'Da mua'
--b) Liet ke danh sach san pham cua hang
SELECT Ten_SP FROM SanPham
--c) Liet ke danh sach cac don dat hang cua cua hang
SELECT * FROM Hoadon
INNER JOIN KhachHang
ON Hoadon.MA_KH = KhachHang.Ma_KH
GO

--5 Cau lenh truy van de
--a) Liet ke danh sach khach hang theo alphabet
SELECT * FROM KhachHang ORDER BY TenKH ASC
--b) Liet ke danh sach san pham cua hang theo thu tu giam dan
SELECT * FROM SanPham ORDER BY Gia DESC
--c) Liet ke cac san pham Nguyen Van An da mua
DECLARE @Name VARCHAR(30)
SET @Name = 'Nguyen Van An'
SELECT Ten_SP, TenKH FROM Hoadon AS C
INNER JOIN KhachHang AS A ON A.Ma_KH = C.MA_KH
INNER JOIN Hoadonchitiet AS D ON D.Ma_HD = C.Ma_HD
INNER JOIN SanPham AS B ON B.Ma_SP = D.Ma_SP
WHERE TenKH = @Name
GO

--6 CAU LENH TRUY VAN DE
--a) So khach hang mua tai cua hang
SELECT  COUNT(TenKH) AS So_KH_Da_Mua FROM KhachHang
--b) So mat hang cua ban
SELECT COUNT(Ten_SP) AS So_Mat_Hang FROM SanPham
--c) Tong tien cua tung don hang
SELECT TenKH, SUM(ThanhTien) AS Tong_Tien
FROM KhachHang AS A
INNER JOIN Hoadon AS C ON A.Ma_KH = C.MA_KH
INNER JOIN Hoadonchitiet AS B ON C.Ma_HD = B.Ma_HD
GROUP BY TenKH
GO
--Thay doi thong tin CSDL
--a) Thay doi gia tien > 0 
ALTER TABLE Hoadon ADD CONSTRAINT CK_Date CHECK(Ngay_dat_hang < GETDATE())
--b) them truong ngay xuat hien tren thi truong cua san pham
ALTER TABLE SanPham
ADD Ngay_Xuat_Hien DATETIME
--Thuc hien cac yeu cau
--a)  Dat chi muc
CREATE NONCLUSTERED INDEX IX_MatHang
ON SanPham(Ten_SP)

CREATE NONCLUSTERED INDEX IX_KhachHang
ON KhachHang(TenKH)

EXEC sp_helpindex 'SanPham'
EXEC sp_helpindex 'KhachHang'
GO
--b) Xay dung cac view
---View_KhachHang với các cột: Tên khách hàng, Địa chỉ, Điện thoại
CREATE VIEW View_KH
AS
SELECT TenKH AS TenKhachHang, DiaChi, DienThoai
FROM KhachHang

SELECT * FROM View_KH

GO
---View_SanPham với các cột: Tên sản phẩm, Giá bán
CREATE VIEW View_SP
AS
SELECT Ten_SP AS TenSanPham, Gia AS GiaBan
FROM SanPham

SELECT * FROM View_SP

GO
---View_KhachHang_SanPham với các cột: Tên khách hàng, Số điện thoại, Tên sản phẩm, Số lượng, Ngày mua
CREATE VIEW View_KH_SP
As
SELECT TenKH AS TenKhachHang, DienThoai, Ten_SP AS TenSanPham, SoLuong, Ngay_dat_hang AS NgayMua
FROM Hoadon AS C
INNER JOIN KhachHang AS A ON A.Ma_KH = C.MA_KH
INNER JOIN Hoadonchitiet AS D ON D.Ma_HD = C.Ma_HD
INNER JOIN SanPham AS B ON B.Ma_SP = D.Ma_SP

SELECT * FROM View_KH_SP

GO
--SP_TimKH_MaKH: Tìm khách hàng theo mã khách hàng
CREATE PROCEDURE SP_TimKH_MaKH
 @CustomerID CHAR(5)
AS
SELECT Ma_KH, TenKH FROM KhachHang
WHERE Ma_KH = @CustomerID

EXECUTE SP_TimKH_MaKH KH01

GO
--SP_TimKH_MaHD: Tìm thông tin khách hàng theo mã hóa đơn
CREATE PROCEDURE SP_TimKH_MaHD
 @Bill CHAR(5)
AS
SELECT TenKH, DiaChi, DienThoai
FROM Hoadon AS C
INNER JOIN KhachHang AS A ON A.Ma_KH = C.MA_KH
INNER JOIN Hoadonchitiet AS D ON D.Ma_HD = C.Ma_HD
INNER JOIN SanPham AS B ON B.Ma_SP = D.Ma_SP
WHERE Ma_HD = @Bill

EXECUTE SP_TimKH_MaHD HD01

GO
--SP_SanPham_MaKH: Liệt kê các sản phẩm được mua bởi khách hàng có mã được truyền vào Store
CREATE PROCEDURE SP_SanPham_MaKH
 @Customer VARCHAR(30)
AS
SELECT TenKH, Ten_SP
FROM Hoadon AS C
INNER JOIN KhachHang AS A ON A.Ma_KH = C.MA_KH
INNER JOIN Hoadonchitiet AS D ON D.Ma_HD = C.Ma_HD
INNER JOIN SanPham AS B ON B.Ma_SP = D.Ma_SP
Where TenKH = @Customer

EXECUTE SP_SanPham_MaKH 'Nguyen Van An'

Go