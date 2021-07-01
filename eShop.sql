CREATE DATABASE eShop
USE eShop
GO

CREATE TABLE Categories
(
CategoryID INT PRIMARY KEY IDENTITY(1,1),
CategoryName VARCHAR(30) NOT NULL,
Description TEXT NULL
)
GO

CREATE TABLE Product
(
ProductID INT PRIMARY KEY IDENTITY(1,1),
ProductName VARCHAR(30) NOT NULL,
SupplierID INT,
CategoryID INT CONSTRAINT fk_categoryid FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryId),
QuantityPerUntit VARCHAR(30) NULL,
UnitPrice MONEY NULL DEFAULT(0) CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
UnitsinStock INT NULL DEFAULT(0) CONSTRAINT CK_UnitsInStock CHECK (UnitsInStock >= 0),
UnitsOnOrder INT NULL DEFAULT(0) CONSTRAINT CK_UnitsOnOrder CHECK (UnitsOnOrder >= 0),
ReorderLevel INT NULL DEFAULT(0) CONSTRAINT CK_ReorderLevel CHECK (ReorderLevel >= 0),
Discontinued BIT NULL DEFAULT(0)
)
GO

CREATE TABLE Customers
(
CustomerID VARCHAR(5) PRIMARY KEY DEFAULT NEWID() NOT NULL,
CompanyName VARCHAR(30) NOT NULL,
ContactName VARCHAR(30) NULL,
ContactTitle VARCHAR(30) NULL,
Address VARCHAR(30) NULL,
City VARCHAR(30) NULL,
Region TEXT NULL,
PostalCocde VARCHAR(30) NULL,
Country VARCHAR(30) NULL,
Phone BIGINT NULL,
Fax BIGINT NULL,
Image IMAGE NUll,
ImageThumbnall IMAGE NULL
)
GO

CREATE TABLE Employees
(
EmployeeID INT PRIMARY KEY IDENTITY(1,1),
LastNamme VARCHAR(30)NOT NULL,
FirstName VARCHAR(30) NOT NULL,
Title VARCHAR(30) NULL,
TitleOfCourtesy VARCHAR(30) NULL,
BirthDate DATETIME NULL CONSTRAINT ck_birthdate CHECK (BirthDate < getdate()),
HireDate DATETIME NULL,
Address VARCHAR(30) NULL,
City VARCHAR(30) NULL,
Region VARCHAR(30) NULL,
PostalCode VARCHAR(30) NULL,
Country VARCHAR(30)NULL,
HomePhone BIGINT NULL,
Extension INT NULL,
Notes TEXT NULL,
ReportsTo INT NULL CONSTRAINT fk_reportsto FOREIGN KEY(ReportsTo) REFERENCES Employees(EmployeeID)
)
GO

CREATE TABLE Shippers
(
ShipperID INT PRIMARY KEY IDENTITY(1,1),
CompanyName VARCHAR(30) NOT NULL,
Phone BIGINT NULL
)
GO

CREATE TABLE Suppliers
(
SupplierID INT PRIMARY KEY IDENTITY(1,1),
CompanyName VARCHAR(30) NOT NULL,
ContactName VARCHAR(30) NULL,
ContacTitle VARCHAR(30) NULL,
Address VARCHAR(30) NULL,
City VARCHAR(30) NULL,
Region VARCHAR(30) NULL,
PostalCode VARCHAR(30) NULL,
Country VARCHAR(30) NULL,
Phone BIGINT NULL,
Fax BIGINT NULL,
HomePage TEXT NULL,
)
GO

CREATE TABLE Orders
(
OrderID INT PRIMARY KEY IDENTITY(1,1),
CustomerID VARCHAR(5) DEFAULT NEWID() NOT NULL CONSTRAINT fk_customerid FOREIGN KEY(CustomerId) REFERENCES Customers(CustomerId),
EmployeeID INT CONSTRAINT fk_employeeid FOREIGN KEY(EmployeeId) REFERENCES Employees(EmployeeId),
OrderDate DATETIME NULL,
RequiredDate DATETIME NULL,
ShippedDate DATETIME NULL,
ShipVia INT CONSTRAINT fk_shipperid FOREIGN KEY(ShipVia) REFERENCES Shippers(ShipperID),
Freight MONEY NULL,
ShipName VARCHAR(30) NULL,
ShipAddress VARCHAR(30) NULL,
ShipCity VARCHAR(30) NULL,
ShipRegion VARCHAR(30) NULL,
ShipPostalCode VARCHAR(30) NULL,
ShipCountry VARCHAR(30) NULL,
)
GO

CREATE TABLE OrderDetails
(
OrderID INT CONSTRAINT fk_orderid FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
ProductID INT CONSTRAINT fk_productid FOREIGN KEY(ProductID) REFERENCES Product(ProductID),
UnitPrice MONEY NOT NULL DEFAULT (0) CONSTRAINT CK_UnitPrice CHECK (UnitPrice >= 0),
Quantity INT NOT NULL DEFAULT (1) CONSTRAINT CK_Quantity CHECK (Quantity > 0),
Discount REAL NOT NULL DEFAULT (0) CONSTRAINT CK_Discount CHECK (Discount >= 0 and (Discount <= 1)),
CONSTRAINT "PK_Order_Details" PRIMARY KEY 
	(
		"OrderID",
		"ProductID"
	)
)
GO

ALTER TABLE Product ADD CONSTRAINT fk_supplierid FOREIGN KEY(SupplierID) REFERENCES Suppliers(SupplierID)
GO

INSERT "Categories"("CategoryName","Description") VALUES('Beverages','Soft drinks, coffees, teas, beers, and ales')
INSERT "Categories"("CategoryName","Description") VALUES('Condiments','Sweet and savory sauces, relishes, spreads, and seasonings')
INSERT "Categories"("CategoryName","Description") VALUES('Confections','Desserts, candies, and sweet breads')
INSERT "Categories"("CategoryName","Description") VALUES('Dairy Products','Cheeses')
INSERT "Categories"("CategoryName","Description") VALUES('Grains/Cereals','Breads, crackers, pasta, and cereal')
INSERT "Categories"("CategoryName","Description") VALUES('Meat/Poultry','Prepared meats')
INSERT "Categories"("CategoryName","Description") VALUES('Produce','Dried fruit and bean curd')
INSERT "Categories"("CategoryName","Description") VALUES('Seafood','Seaweed and fish')
SELECT * FROM Categories
GO

INSERT "Customers" VALUES('ALFKI','Alfreds Futterkiste','Maria Anders','Sales Representative','Obere Str. 57','Berlin',NULL,'12209','Germany',0300074321,0300076545,'','')
INSERT "Customers" VALUES('ANATR','Ana Trujillo Emparedados y helados','Ana Trujillo','Owner','Avda. de la Constitución 2222','México D.F.',NULL,'05021','Mexico',55554729,55553745,'','')
INSERT "Customers" VALUES('ANTON','Antonio Moreno Taquería','Antonio Moreno','Owner','Mataderos  2312','México D.F.',NULL,'05023','Mexico',55554729,55553745,'','')
INSERT "Customers" VALUES('AROUT','Around the Horn','Thomas Hardy','Sales Representative','120 Hanover Sq.','London',NULL,'WA1 1DP','UK',55554729,55553745,'','')
INSERT "Customers" VALUES('BERGS','Berglunds snabbköp','Christina Berglund','Order Administrator','Berguvsvägen  8','Luleå',NULL,'S-958 22','Sweden',55554729,55553745,'','')
INSERT "Customers" VALUES('BLAUS','Blauer See Delikatessen','Hanna Moos','Sales Representative','Forsterstr. 57','Mannheim',NULL,'68306','Germany',55554729,55553745,'','')
INSERT "Customers" VALUES('BLONP','Blondesddsl père et fils','Frédérique Citeaux','Marketing Manager','24, place Kléber','Strasbourg',NULL,'67000','France',55554729,55553745,'','')
INSERT "Customers" VALUES('BOLID','Bólido Comidas preparadas','Martín Sommer','Owner','C/ Araquil, 67','Madrid',NULL,'28023','Spain',55554729,55553745,'','')
INSERT "Customers" VALUES('BONAP','Bon app''','Laurence Lebihan','Owner','12, rue des Bouchers','Marseille',NULL,'13008','France',55554729,55553745,'','')
INSERT "Customers" VALUES('BOTTM','Bottom-Dollar Markets','Elizabeth Lincoln','Accounting Manager','23 Tsawassen Blvd.','Tsawassen','BC','T2F 8M4','Canada',55554729,55553745,'','')
SELECT * FROM Customers

INSERT "Employees" VALUES('Davolio','Nancy','Sales Representative','Ms.','12/08/1948','05/01/1992','507 - 20th Ave. E.Apt. 2A','Seattle','WA','98122','USA',2065559857,'5467','Education includes a BA in psychology from Colorado State University in 1970.  She also completed "The Art of the Cold Call."  Nancy is a member of Toastmasters International.',2)
INSERT "Employees" VALUES('Davolio','Nancy','Sales Representative','Ms.','12/08/1948','05/01/1992','507 - 20th Ave. E.Apt. 2A','Seattle','WA','98122','USA',2065559857,'5467','Education includes a BA in psychology from Colorado State University in 1970.  She also completed "The Art of the Cold Call."  Nancy is a member of Toastmasters International.',2)
INSERT "Employees" VALUES('Suyama','Michael','Sales Representative','Mr.','07/02/1963','10/17/1993','Coventry House Miner Rd.','London',NULL,'EC2 7JR','UK',715557773,'428','Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses "Multi-Cultural Selling" and "Time Management for the Sales Professional."  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.',5)

SELECT * FROM Employees

INSERT "OrderDetails" VALUES(42,9.8,10,0)
INSERT "OrderDetails" VALUES(72,34.8,5,0)
INSERT "OrderDetails" VALUES(14,18.6,9,0)
INSERT "OrderDetails" VALUES(51,42.4,40,0)
INSERT "OrderDetails" VALUES(41,7.7,10,0)
INSERT "OrderDetails" VALUES(51,42.4,35,0.15)
INSERT "OrderDetails" VALUES(65,16.8,15,0.15)
INSERT "OrderDetails" VALUES(22,16.8,6,0.05)
INSERT "OrderDetails" VALUES(57,15.6,15,0.05)
GO

USE AdventureWorks2019
GO

SELECT * FROM Person.ContactType WHERE ContactTypeID >=3 AND ContactTypeID <=9
SELECT * FROM Person.ContactType WHERE ContactTypeID BETWEEN 3 AND 9
SELECT * FROM Person.ContactType WHERE ContactTypeID BETWEEN 3 AND 9
SELECT * FROM Person.ContactType WHERE ContactTypeID IN (2,4,6,8)
SELECT * FROM Person.Person WHERE LastName LIKE '%a'
SELECT * FROM Person.Person WHERE LastName LIKE '[RB]%e'
SELECT * FROM Person.Person WHERE LastName LIKE '[RB]__e'
SELECT * FROM Person.Person WHERE LastName LIKE '%a%'
SELECT * FROM Person.Person WHERE LastName LIKE 'e%'
SELECT * FROM Person.Person WHERE LastName LIKE '[^ab]'
SELECT DISTINCT Title FROM Person.Person
SELECT Title FROM Person.Person GROUP BY Title
SELECT Title, COUNT(*)[Title Num] FROM Person.Person GROUP BY Title
SELECT Title, COUNT(*) AS [Title Num] FROM Person.Person GROUP BY Title
SELECT Title, COUNT(*)[Title Num] FROM Person.Person WHERE Title LIKE 'Mr%' GROUP BY ALL Title
SELECT Title, COUNT(*)[Title Num] FROM Person.Person GROUP BY ALL Title HAVING Title LIKE 'Mr%'
SELECT Title, COUNT(*)[Title Num] FROM Person.Person GROUP BY ALL Title HAVING COUNT(*) > 10
SELECT Title, COUNT(*)[Title Num] FROM Person.Person WHERE Title LIKE 'Mr%' GROUP BY ALL Title HAVING COUNT(*) > 10
SELECT Title, COUNT(*)[Title Num] FROM Person.Person GROUP BY Title WITH CUBE
SELECT Title, COUNT(*)[Title Num] FROM Person.Person GROUP BY Title WITH ROLLUP
SELECT * FROM Person.Person ORDER BY FirstName, LastName DESC
GO

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee

SELECT * FROM Person.Person WHERE BusinessEntityID IN (
	SELECT BusinessEntityID FROM HumanResources.Employee)

	SELECT * FROM Person.Person C WHERE EXISTS (
	SELECT BusinessEntityID FROM HumanResources.Employee WHERE BusinessEntityID=C.BusinessEntityID)

SELECT * FROM Person.ContactType WHERE ContactTypeID IN (2,4,6,8)
UNION
SELECT * FROM Person.ContactType WHERE ContactTypeID IN (1,2,3,4,6,8)

SELECT * FROM Person.ContactType WHERE ContactTypeID IN (2,4,6,8)
UNION ALL
SELECT * FROM Person.ContactType WHERE ContactTypeID IN (1,2,3,4,6,8)

SELECT * FROM HumanResources.Employee AS E
	INNER JOIN Person.Person AS L
	ON E.BusinessEntityID = L.BusinessEntityID
ORDER BY L.LastName

SELECT DISTINCT p1.ProductSubcategoryID, p1.ListPrice
FROM Production.Product p1 INNER JOIN Production.Product p2 
	ON p1.ProductSubcategoryID = p2.ProductSubcategoryID AND p1.ListPrice <>p2.ListPrice
WHERE p1.ListPrice < $15 AND p2.ListPrice < $15
ORDER BY ProductSubcategoryID;




--LAB6

CREATE DATABASE LAB6
USE LAB6
GO

CREATE TABLE PhongBan (
 MaPB varchar(7)PRIMARY KEY  not null,
 TenPB nvarchar(50) not null
);
GO

CREATE TABLE NhanVien  (
 MaNV varchar(7)PRIMARY KEY not null,
 TenNV nvarchar(50) not null,
 NgaySinh datetime not null check ( NgaySinh <(getdate())),
 SoCMND char(9) not null check( ISNUMERIC(SoCMND) = 1) ,
 GioiTinh char(1) not null DEFAULT 'M' CHECK (GioiTinh = 'M' OR GioiTinh ='F'),
 DiaChi nvarchar(100) not null,
 NgayVaoLam datetime not null ,
 MaPB varchar(7)
 FOREIGN KEY (MaPB) REFERENCES phongban(MaPB),
 check (DATEDIFF(year, NgayVaoLam, NgaySinh) <= -20)
);
GO

CREATE TABLE LuongDA  (
 MaDA varchar(8),
 MaNV varchar(7) not null,
 NgayNhan Datetime not null default (getdate()),
 SoTien money not null check (SoTien > 0),
 CONSTRAINT PK_maDANV PRIMARY KEY (MaDA, MaNV),
 FOREIGN KEY (MaNV) REFERENCES nhanvien(MaNV)
);
GO

--1 Thực hiện chèn dữ liệu vào các bảng vừa tạo (ít nhất 5 bản ghi cho mỗi bảng)
INSERT Phongban (MaPB,TenPB)       
VALUES ('0000001',N'Kế Toán'),('0000002',N'Nhân Sự'), ('0000003',N'Kinh Doanh'),
  ('0000004',N'Dự Án'),('0000005',N'Đầu Tư');
SELECT * FROM PhongBan 
INSERT Phongban (MaPB,TenPB)       
VALUES('0000006',N'Hành Chính')

INSERT NhanVien (MaNV, TenNV, NgaySinh,SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB)       
VALUES ('1',N'NGUYỄN KHÁNH LINH','1980-09-03','123456789','M',N'HÀ NỘI','2012-09-03','0000001'),
  ('2',N'NGUYỄN KHÁNH TOÀN','1980-09-03','112345679','F',N'HÀ NỘI','2012-09-03','0000002'),
  ('3',N'NGUYỄN ĐỨC HẬU','1980-09-03','123456898','F',N'HƯNG YÊN','2012-09-03','0000003'),
  ('4',N'TRẦN CAO TRUNG','1980-09-03','435678932','M',N'QUẢNG NINH','2012-09-03','0000004'),
  ('5',N'NGUYỄN MINH NHẬT','1980-09-03','097456434','F',N'CÀ MAU','2012-09-03','0000005'),
  ('6',N'TRẦN QUANG KHẢI','1980-12-12','345231657','M',N'NHA TRANG','2012-09-03','0000001'),
  ('7',N'PHAM THANH THANH','1980-12-12','234561267','M',N'HÀ NỘI','2012-09-03','0000006');
  GO
INSERT NhanVien (MaNV, TenNV, NgaySinh,SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB)       
VALUES ('8',N'PHAM THANH THANH','1980-12-12','234561267','M',N'HÀ NỘI','2012-09-03','0000006')

INSERT luongDA (MaDA ,MaNV,SoTien)      
VALUES ('DA01','1',900000000),
  ('DA02','2',900000000),
  ('DA03','3',900000000),
  ('DA04','4',900000000),
  ('DA05','5',900000000),
  ('DA06','6',900000000),
  ('DA07','7',900000000),
  ('DX02','9',900000000);
  GO

--2 Viết một query để hiển thị thông tin về các bảng LUONGDA, NHANVIEN, PHONGBAN.
SELECT * FROM PhongBan;
SELECT * FROM NhanVien;
SELECT * FROM LuongDA;
GO

--3 Viết một query để hiển thị những nhân viên có giới tính là ‘F’
SELECT * FROM nhanvien WHERE GioiTinh='F';
GO

--4 Hiển thị tất cả các dự án, mỗi dự án trên 1 dòng
SELECT MaDA AS'Ten DA' from luongDA;
GO

--5 Hiển thị tổng lương của từng nhân viên (dùng mệnh đề GROUP BY)
SELECT MaNV, SUM(SoTien) FROM LuongDA GROUP BY MaNV;
GO

--6 Hiển thị tất cả các nhân viên trên một phòng ban cho trước
SELECT * FROM nhanvien WHERE MaPB='0000006'

--7 Hiển thị mức lương của những nhân viên phòng hành chính
CREATE VIEW NVhanhchinh AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB FROM  NhanVien 
WHERE MaPB='0000006'
WITH CHECK OPTION;

SELECT * from NVhanhchinh;

CREATE VIEW LuongNVHanhChinh AS
SELECT  TenNV, SoTien, GioiTinh
     FROM NVhanhchinh
     INNER JOIN LuongDA
     ON NVhanhchinh.MaNV = LuongDA.MaNV;

SELECT * FROM LuongNVHanhChinh;
GO

--8 Hiển thị số lượng nhân viên của từng phòng
CREATE VIEW NVKT AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  NhanVien
 WHERE MaPB='0000001'
 WITH CHECK OPTION;

SELECT * FROM NVKT;

CREATE VIEW NVNS AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  NhanVien
 WHERE MaPB='0000002'
 WITH CHECK OPTION;

SELECT * FROM NVNS;

CREATE VIEW NVKD AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  NhanVien
 WHERE MaPB='0000003'
 WITH CHECK OPTION;

SELECT * FROM NVKD;

CREATE VIEW NVTK AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  NhanVien
 WHERE MaPB='0000004'
 WITH CHECK OPTION;

SELECT * FROM NVTK;

CREATE VIEW NVHC AS
SELECT MaNV, TenNV, NgaySinh, SoCMND, GioiTinh, DiaChi, NgayVaoLam, MaPB
 FROM  nhanvien
 WHERE MaPB='0000006'
 WITH CHECK OPTION;

SELECT * FROM NVHC;

SELECT COUNT(*) AS N'Nhân viên kế toán' FROM NVKT ;
SELECT COUNT(*) AS N'Nhân viên nhân sự' FROM NVNS ;
SELECT COUNT(*) AS N'Nhân viên kinh doanh' FROM NVKD ;
SELECT COUNT(*) AS N'Nhân viên thiết kế' FROM NVTK ;
SELECT COUNT(*) AS N'Nhân viên hành chính' FROM NVHC ;

--9 Viết một query để hiển thị những nhân viên mà tham gia ít nhất vào một dự án
SELECT * FROM LuongDA WHERE MaDA!='';

--10 Viết một query hiển thị phòng ban có số lượng nhân viên nhiều nhất
SELECT MAX(MaPB) as NVMax FROM PhongBan;

--11 Tính tổng số lượng của các nhân viên trong phòng Hành chính
SELECT COUNT(*) AS N' Tổng số NV hành chính' FROM NVHC ;

--12 Hiển thị tống lương của các nhân viên có số CMND tận cùng bằng 9
/*SELECT RIGHT(SoCMND, 1), SoCMND
FROM NhanVien
WHERE RIGHT(SoCMND, 1) = '9'*/

SELECT * FROM NhanVien NV, LuongDA LGDA
WHERE RIGHT(nv.SoCMND, 1) = '9'  and NV.MaNV = LGDA.MaNV

--13 Tìm nhân viên có số lương cao nhất
SELECT MAX(SoTien) AS 'Lương Cao Nhất' FROM LuongDA;

--14 Tìm nhân viên ở phòng Hành chính có giới tính bằng ‘M’ và có mức lương > 1200000
SELECT * FROM LuongNVHanhChinh
WHERE (GioiTinh='M') AND (SoTien >1200000);

--15 Tìm tổng lương trên từng phòng
SELECT PB.MaPB, PB.TenPB, TONGTIEN FROM PhongBan PB,(
SELECT MaPB, SUM(SoTien) AS TONGTIEN FROM NhanVien AS NV, LuongDA AS LUONG WHERE NV.MaNV = LUONG.MaNV 
GROUP BY MaPB ) KETQUA WHERE PB.MaPB = KETQUA.MaPB;

--16 Liệt kê các dự án có ít nhất 2 người tham gia.
SELECT MaDA FROM LuongDA
 GROUP By MaDA
 Having COUNT(MaNV) >= 2;

--17 Liệt kê thông tin chi tiết của nhân viên có tên bắt đầu bằng ký tự ‘N’
SELECT RIGHT(TenNV, 1), TenNV, MaNV, NgaySinh, SoCMND,GioiTinh,DiaChi,NgayVaoLam
FROM NhanVien
WHERE RIGHT(TenNV, 1)='N';

--18 Hiển thị thông tin chi tiết của nhân viên được nhận tiền dự án trong năm 2021
SELECT * FROM LuongDA WHERE NgayNhan= '2021-07-01';

--19 Hiển thị thông tin chi tiết của nhân viên không tham gia bất cứ dự án nào
SELECT * FROM LuongDA WHERE MaDA='';

--20 Xoá dự án có mã dự án là DXD02
DELETE FROM LuongDA WHERE MaDA='DX02'

--21 Xoá đi từ bảng LuongDA những nhân viên có mức lương 2000000
DELETE FROM LuongDA WHERE SoTien='2000000';

--22Cập nhật lại lương cho những người tham gia dự án XDX01 thêm 10% lương cũ
INSERT LuongDA(MaDA ,MaNV,NgayNhan,SoTien)      
VALUES ('XDX01','1',21-11-2016,9000000000);
UPDATE LuongDA
SET SoTien = '990000000'
WHERE MaDA = 'XDX01';
SELECT * FROM LuongDA;

--23 Xoá các bản ghi tương ứng từ bảng NhanVien đối với những nhân viên không có mã nhân viên tồn tại trong bảng LuongDA.
DELETE FROM NhanVien WHERE MaNV NOT IN (SELECT MaNV FROM LuongDA );

--24 Viết một truy vấn đặt lại ngày vào làm của tất cả các nhân viên thuộc phòng hành chính là ngày 12/02/1999
UPDATE NVHC
SET NgayVaoLam = 12/02/1999;
select * from NVHC;