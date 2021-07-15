--ASM-MSQL 2
--1,2) VIẾT CÂU LẸNH TẠO BẢNG 
CREATE DATABASE HANGSP
USE HANGSP
GO

CREATE TABLE DSHang
(
IDHang CHAR(5) PRIMARY KEY,
TenHang VARCHAR(20),
DiaChi VARCHAR(20),
DienThoai BIGINT
)
GO

CREATE TABLE SanPham
(
IDSanPham CHAR(5) PRIMARY KEY,
IDHang CHAR(5) CONSTRAINT FK_IDHang FOREIGN KEY(IDHang) REFERENCES DSHang(IDHang),
TenSP VARCHAR(20),
MotaSP VARCHAR(20),
Donvi CHAR(5),
Gia MONEY,
SoluongTon INT,
)
GO

--3) Them vao du lieu trong bang
INSERT INTO DSHang VALUES ('123','Asus','USA','983232'),
						  ('120','FPT','VNA','948383'),
						  ('121','VIN','VNA','938483'),
						  ('122','SAM','KOR','974637');
GO

INSERT INTO SanPham VALUES ('00006','121','VinSmart 1560','Dien thoai dang hot','Chiec',300,0),
						   ('00005','121','VinSmart 2560','Dien thoai dang hot','Chiec',300,100),
						   ('00001','120','May Tinh T450','May nhap cu','Chiec',1000,10),
						   ('00002','123','Nokia 5670','Dien thoai dang hot','Chiec',200,200),
						   ('00003','122','May In Samsung 450','May in dang loai','Chiec',100,10),
						   ('00004','121','VinSmart 3560','Dien thoai dang hot','Chiec',300,100);
GO

--4) Viet cau lenh truy van de
--a) Hien thi tat ca hang san xuat
SELECT IDHang, TenHang FROM DSHang
--b) Hien thi tat ca san pham
SELECT IDSanPham, IDHang, TenSP FROM SanPham
GO

--5) Viet cau lenh truy van de
--a) Liet ke danh sach hang theo thu tu nguoc alphabet ten
SELECT TenHang FROM DSHang ORDER BY TenHang DESC
--b) Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần
SELECT TenSP, Gia FROM SanPham ORDER BY Gia DESC 
--c) Hiển thị thông tin của hãng Asus
SELECT * FROM DSHang WHERE TenHang LIKE 'Asus'
--d) Liệt kê danh sách sản phẩm còn ít hơn 11 chiếc trong kho
SELECT TenSP, SoluongTon FROM SanPham WHERE SoluongTon < 11
--e) Liệt kê danh sách sản phẩm của hãng Asus
SELECT TenSP FROM SanPham AS A
INNER JOIN DSHang AS B ON A.IDHang = B.IDHang
WHERE B.TenHang LIKE 'Asus'
--6 Viết các câu lệnh truy vấn để lấy
--a) Số hãng sản phẩm mà cửa hàng có
SELECT COUNT(IDHang) AS SoHangCuaHangCo FROM SanPham
--b) Số mặt hàng mà cửa hàng bán
SELECT COUNT(TenSP) AS SoSPCuaHangBan FROM SanPham
--c) Tổng số loại sản phẩm của mỗi hãng có trong cửa hàng
SELECT TenHang, COUNT(IDSanPham) AS TongSoLoaiSPMoiHang
FROM SanPham AS A
INNER JOIN DSHang AS B ON A.IDHang = B.IDHang
GROUP BY TenHang
--d) Tổng số đầu sản phẩm của toàn cửa hàng
SELECT COUNT(IDSanPham) AS TongsodauSP FROM SanPham
GO

--7) Thay đổi những thay đổi sau trên cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0)
ALTER TABLE SanPham ADD CONSTRAINT CK_GIATIEN CHECK(Gia>0)
--b) Viết câu lệnh để thay đổi số điện thoại phải bắt đầu bằng 0
ALTER TABLE DSHang
DROP COLUMN DienThoai
GO
ALTER TABLE DSHang
  ADD DienThoai VARCHAR(10);
 GO
ALTER TABLE DSHang
ADD CONSTRAINT CK_Phone CHECK (Dienthoai LIKE '0%')
GO
SELECT * FROM DSHang
--c) Viết các câu lệnh để xác định các khóa ngoại và khóa chính của các bảng


--8) Thực hiện các yêu cầu sau
--a) Thiết lập chỉ mục (Index) cho các cột sau: Tên hàng và Mô tả hàng để tăng hiệu suất truy vấn dữ liệu từ 2 cột này
CREATE NONCLUSTERED INDEX IX_TenSP ON SanPham(TenSP)
GO
CREATE NONCLUSTERED INDEX IX_Mota ON SanPham(MotaSP)

GO
EXEC sp_helpindex 'SanPham'
GO
--b) View_SanPham: với các cột Mã sản phẩm, Tên sản phẩm, Giá bán
CREATE VIEW View_SanPham AS SELECT IDSanPham,TenSP,Gia FROM SanPham

GO
SELECT * FROM View_SanPham
GO
---View_SanPham_Hang: với các cột Mã SP, Tên sản phẩm, Hãng sản xuất
CREATE VIEW View_SanPham_Hang 
AS SELECT IDSanPham, TenSP, TenHang 
FROM SanPham AS A
INNER JOIN DSHang AS B ON A.IDHang = B.IDHang
SELECT * FROM View_SanPham_Hang
GO
--c) SP_SanPham_TenHang: Liệt kê các sản phẩm với tên hãng truyền vào store
CREATE PROCEDURE SP_SanPham_TenSP AS
SELECT a.TenSP,b.TenHang FROM SanPham a INNER JOIN DSHang b ON a.IDHang=b.IDHang
GO
EXECUTE SP_SanPham_TenSP

GO
---SP_SanPham_Gia: Liệt kê các sản phẩm có giá bán lớn hơn hoặc bằng giá bán truyền vào
CREATE PROCEDURE SP_SanPham_Gia AS
SELECT TenSP,Gia FROM SanPham
WHERE Gia
GO
---Liệt kê các sản phẩm đã hết hàng (số lượng = 0)
CREATE PROCEDURE SP_SanPham_HetHang AS
SELECT TenSP,SoluongTon FROM SanPham
WHERE SoluongTon = 0
GO
EXECUTE SP_SanPham_HetHang
GO
--d) Viết Trigger sau
---TG_Xoa_Hang: Ngăn không cho xóa hãng
CREATE TRIGGER TG_Xoa_Hang
ON DSHang
FOR DELETE
AS
 IF UPDATE(IDHang)
 PRINT N'Khong Duoc Xoa';
 ROLLBACK TRANSACTION;
GO
DELETE  FROM DSHang
  WHERE IDHang='122';
GO

---TG_Xoa_SanPham: Chỉ cho phép xóa các sản phẩm đã hết hàng (số lượng = 0)
CREATE TRIGGER TG_Xoa_SanPham
ON SanPham
FOR DELETE
AS
 BEGIN
  IF EXISTS(SELECT *FROM SanPham WHERE SoluongTon =0)
  BEGIN
   PRINT N'Không được xóa sản phẩm vẫn còn hàng';
   ROLLBACK TRANSACTION;
  END
 END
GO
DELETE  FROM SanPham
  WHERE TenSP='VinSmart 1560';