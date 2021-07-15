--MSSQL Assignment 04
--1,2 Viết các câu lệnh để tạo các bảng như thiết kế
CREATE DATABASE ASM04
USE ASM04
GO

CREATE TABLE SanPham
(
MaSP CHAR(15) PRIMARY KEY,
NgaySX DATETIME,
TenloaiSP VARCHAR(50),
MaloaiSP VARCHAR(5)
)
CREATE TABLE NhanVien
(
IDNhanVien VARCHAR(15) PRIMARY KEY,
TenNV VARCHAR(20)
)
CREATE TABLE TrachNhiem
(
IDNhanVien VARCHAR(15) CONSTRAINT FK_IDNV FOREIGN KEY(IDNhanVien) REFERENCES NhanVien(IDNhanVien),
MaSP CHAR(15) CONSTRAINT FK_MASP FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
)
--3) Viết các câu lệnh để thêm dữ liệu vào các bảng
INSERT INTO SanPham VALUES ('Z37 111111','2009-12-12','Máy tính sách tay Z37','Z37E')
INSERT INTO SanPham VALUES ('Z37 111112','2009-12-12','Máy tính sách tay Z37','Z37E')
INSERT INTO SanPham VALUES ('P37 111111','2009-12-12','Dien thoai P37','P37E')
GO
INSERT INTO NhanVien VALUES ('987688','Nguyễn Văn An')
INSERT INTO NhanVien VALUES ('987687','Nguyễn Văn Linh')
GO
INSERT INTO TrachNhiem VALUES ('987688','Z37 111111')
INSERT INTO TrachNhiem VALUES ('987688','P37 111111')
INSERT INTO TrachNhiem VALUES ('987687','P37 111111')
GO
--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách loại sản phẩm của công ty
SELECT MaloaiSP FROM SanPham
--b) Liệt kê danh sách sản phẩm của công ty.
SELECT MaSP, TenloaiSP FROM SanPham
--c) Liệt kê danh sách người chịu trách nhiệm của công ty.
SELECT TenNV, IDNhanVien FROM NhanVien
--5. Viết các câu lệnh truy vấn để lấy
--a) Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
SELECT DISTINCT MaloaiSP, TenloaiSP FROM SanPham ORDER BY TenloaiSP ASC
--b) Liệt kê danh sách người chịu trách nhiệm của công ty theo thứ tự tăng dần của tên
SELECT TenNV FROM NhanVien ORDER BY TenNV ASC
--c) Liệt kê các sản phẩm của loại sản phẩm có mã số là Z37E.
SELECT MaSP, TenloaiSP FROM SanPham WHERE MaloaiSP LIKE 'Z37E'
--d) Liệt kê các sản phẩm Nguyễn Văn An chịu trách nhiệm theo thứ tự giảm đần của mã.
SELECT TenNV ,TenloaiSP, MaloaiSP FROM SanPham AS A
INNER JOIN TrachNhiem AS B ON B.MaSP = A.MaSP
INNER JOIN NhanVien AS C ON C.IDNhanVien = B.IDNhanVien
WHERE TenNV = 'Nguyễn Văn An'
ORDER BY MaloaiSP DESC
--6. Viết các câu lệnh truy vấn để
--a) Số sản phẩm của từng loại sản phẩm
SELECT MaloaiSP ,COUNT(MaSP) AS Sosanphamtungloai FROM SanPham 
GROUP BY MaloaiSP
--c) Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm.
SELECT * FROM SanPham AS A
INNER JOIN TrachNhiem AS B ON B.MaSP = A.MaSP
INNER JOIN NhanVien AS C ON C.IDNhanVien = B.IDNhanVien
--Hiển thị toàn bộ thông tin về người chịu trách nhiêm, loại sản phẩm và sản phẩm
SELECT * FROM NhanVien AS A
INNER JOIN TrachNhiem AS B ON B.IDNhanVien = A.IDNhanVien
INNER JOIN SanPham AS C ON C.MaSP = B.MaSP
--7. Thay đổi những thư sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sản xuất là trước hoặc bằng ngày hiện tại
ALTER TABLE SanPham
ADD CONSTRAINT CK_RegistrationDate CHECK (NgaySX < GetDate() or NgaySX = GetDate())
--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.

--c) Viết câu lệnh để thêm trường phiên bản của sản phẩm.
ALTER TABLE SanPham
ADD PhienBan VARCHAR(20)
--8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (index) cho cột tên người chịu trách nhiệm
CREATE  NONCLUSTERED INDEX IX_TrachNhiem
ON NhanVien(TenNV)
--b) Viết các View sau:
---View_SanPham: Hiển thị các thông tin Mã sản phẩm, Ngày sản xuất, Loại sản phẩm
CREATE VIEW  View_SanPham
AS
SELECT MaSP, NgaySX, MaloaiSP
FROM SanPham

GO
SELECT * FROM View_SanPham

GO
---View_SanPham_NCTN: Hiển thị Mã sản phẩm, Ngày sản xuất, Người chịu trách nhiệm
CREATE VIEW  View_SanPham_NCTN
AS
SELECT MaloaiSP, NgaySX, TenNV 
FROM SanPham AS A
INNER JOIN TrachNhiem AS B ON A.MaSP =  B.MaSP
INNER JOIN NhanVien AS C ON C.IDNhanVien = B.IDNhanVien

GO
SELECT * FROM View_SanPham_NCTN

GO
---View_Top_SanPham: Hiển thị 5 sản phẩm mới nhất (mã sản phẩm, loại sản phẩm, ngày sản xuất)
CREATE VIEW View_Top_SanPham
AS
SELECT TOP(5) MaSP, MaloaiSP, NgaySX FROM SanPham
--c) Viết các Store Procedure sau:
---SP_Them_LoaiSP: Thêm mới một loại sản phẩm
CREATE PROCEDURE SP_Them_LoaiSP
 @SPID CHAR(15),
 @DateSX DATETIME,
 @MaloaiSpx VARCHAR(5),
 @TenloaiSPX VARCHAR(50)
AS
BEGIN
 INSERT INTO SanPham(MaSP,NgaySX,MaloaiSP,TenloaiSP)
 VALUES (@SPID, @DateSX, @MaloaiSpx,@TenloaiSPX)
END

GO
EXECUTE SP_Them_LoaiSP 'Z37 111113','2020-12-12','Máy tính sách tay Z37','Z37E'

GO
---SP_Them_NCTN: Thêm mới người chịu trách nhiệm
CREATE PROCEDURE SP_Them_NCTN
 @NVID VARCHAR(15),
 @TenNVX VARCHAR(20)
AS
BEGIN
 INSERT INTO NhanVien(IDNhanVien, TenNV)
 VALUES (@NVID, @TenNVX)
END

GO
EXECUTE SP_Them_NCTN '987685','Tạ Hoàng Hà'

GO
---SP_Them_SanPham: Thêm mới một sản phẩm
CREATE PROCEDURE SP_Them_SanPham
 @SPXID CHAR(15)
AS
BEGIN
 INSERT INTO SanPham(MaSP)
 VALUES (@SPXID)
END

GO
EXECUTE SP_Them_SanPham 'Z37 111114'

GO
---SP_Xoa_SanPham: Xóa một sản phẩm theo mã sản phẩm
CREATE PROCEDURE SP_Xoa_SanPham
 @SPID CHAR(15)
AS
BEGIN
 DELETE FROM SanPham
 WHERE MaSP = @SPID
END

GO
EXECUTE SP_Xoa_SanPham 'Z37 111114'

GO
---SP_Xoa_SanPham_TheoLoai: Xóa các sản phẩm của một loại nào đó
CREATE PROCEDURE SP_Xoa_SanPham_TheoLoai
 @MLSPID VARCHAR(5)
AS
BEGIN
 DELETE FROM SanPham
 WHERE MaloaiSP = @MLSPID
END

GO
EXECUTE SP_Xoa_SanPham_TheoLoai 'Máy t'

GO
SELECT * FROM SanPham