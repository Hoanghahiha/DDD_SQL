---MSSQL Assignment 06
---Xây dựng CSDL để giải quyết bài toán Quản lý Kho sách
--1. Viết lệnh SQL tạo CSDL có tên như trên, CSDL gồm các file theo yêu cầu sau:
CREATE DATABASE ASM06
USE ASM06
GO
DROP DATABASE ASM06
CREATE TABLE Sach
(
MaSach CHAR(5) PRIMARY KEY,
TenSach VARCHAR(30),
TacGia VARCHAR(30),
NoiDung VARCHAR(500),
LoaiSach VARCHAR(30),
Gia MONEY
)
GO

CREATE TABLE NhaXuatBan
(
NhaXB VARCHAR(20) PRIMARY KEY,
DiaChi VARCHAR(20),
)
GO

CREATE TABLE SachChiTiet
(
MaSach CHAR(5) CONSTRAINT CK_Masach FOREIGN KEY(MaSach) REFERENCES Sach(MaSach),
NhaXB VARCHAR(20) CONSTRAINT CK_NhaXB FOREIGN KEY(NhaXB) REFERENCES NhaXuatBan(NhaXB),
NamXuatBan INT,
SoLanXuatBan INT,
SoLuong INT
)
GO
--2. Viết lệnh SQL chèn vào các bảng của CSDL các dữ liệu mẫu
INSERT INTO Sach VALUES ('B001','Trí tuệ Do Thái','Eran Katz','Bạn có muốn biết: Người Do Thái sáng tạo ra cái gì và nguồn gốc
trí tuệ của họ xuất phát từ đâu không? Cuốn sách này sẽ dần hé lộ
những bí ẩn về sự thông thái của người Do Thái, của một dân tộc
thông tuệ với những phương pháp và kỹ thuật phát triển tầng lớp trí
thức đã được giữ kín hàng nghìn năm như một bí ẩn mật mang tính
văn hóa.','Khoa học xã hội','79000')
GO
INSERT INTO Sach VALUES ('B002','Thinks','Mark Guire','','Khoa học xã hội','129000')
INSERT INTO Sach VALUES ('B003','Now','Zulia Genius','','Viễn Tưởng','29000')
INSERT INTO Sach VALUES ('B004','IT','Chalotte Kid','','Tin Học','229000')

GO
INSERT INTO NhaXuatBan VALUES ('Tri Thức','Nguyễn Du, Hà Nội')
INSERT INTO NhaXuatBan VALUES ('Kim Đồng','Thanh Xuân, Hà Nội')
INSERT INTO SachChiTiet VALUES ('B001','Tri Thức',2010,1,100)
INSERT INTO SachChiTiet VALUES ('B002','Tri Thức',2007,1,100)
INSERT INTO SachChiTiet VALUES ('B003','Tri Thức',20012,1,100)
INSERT INTO SachChiTiet VALUES ('B004','Kim Đồng',20012,1,100)
--3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay
SELECT NamXuatBan, TenSach FROM SachChiTiet AS A
INNER JOIN Sach AS B ON B.MaSach = A.MaSach
WHERE NamXuatBan >= 2008
--4. Liệt kê 10 cuốn sách có giá bán cao nhất
SELECT TOP(2) TenSach, Gia FROM Sach ORDER BY Gia desc
--5. Tìm những cuốn sách có tiêu đề chứa từ “tin học”
SELECT MaSach, TenSach, TacGia, LoaiSach FROM Sach 
WHERE LoaiSach LIKE '%Tin Học%'
--6. Liệt kê các cuốn sách có tên bắt đầu với chữ “T” theo thứ tự giá giảm dần
SELECT TenSach FROM Sach
WHERE TenSach LIKE 'T%'
--7. Liệt kê các cuốn sách của nhà xuất bản Tri thức
SELECT TenSach FROM Sach AS A
INNER JOIN SachChiTiet AS B ON B.MaSach = A.MaSach
WHERE NhaXB = 'Tri Thức'
--8. Lấy thông tin chi tiết về nhà xuất bản xuất bản cuốn sách “Trí tuệ Do Thái”
SELECT * FROM NhaXuatBan AS A
INNER JOIN SachChiTiet AS B ON B.NhaXB = A.NhaXB
INNER JOIN Sach AS C ON C.MaSach = B.MaSach
--9. Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản, Loại sách
SELECT MaSach, TenSach, NamXB, NhaXB, LoaiSach FROM Sach AS A
INNER JOIN SachChiTiet AS B ON B.MaSach = A.MaSach
--10. Tìm cuốn sách có giá bán đắt nhất
SELECT TOP(1) TenSach, MAX(Gia)
 FROM Sach
 GROUP BY TenSach
--11. Tìm cuốn sách có số lượng lớn nhất trong kho
SELECT TOP(1) TenSach, MAX(SoLuong)
 FROM Sach AS A
 INNER JOIN SachChiTiet AS B ON B.MaSach = A.MaSach
 GROUP BY TenSach
--12. Tìm các cuốn sách của tác giả “Eran Katz
SELECT TenSach FROM Sach 
WHERE TacGia = 'Eran Katz'
--13. Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước

--14. Thống kê số đầu sách của mỗi nhà xuất bản
SELECT NhaXB,COUNT(TenSach) FROM NhaXuatBan AS A
INNER JOIN SachChiTiet AS B ON B.NhaXB = A.NhaXB
INNER JOIN Sach AS C ON C.MaSach = B.MaSach
GROUP BY NhaXB
--15. Thống kê số đầu sách của mỗi loại sách
SELECT LoaiSach ,COUNT(TenSach) FROM Sach
GROUP BY LoaiSach
--16. Đặt chỉ mục (Index) cho trường tên sách

--17. Viết view lấy thông tin gồm: Mã sách, tên sách, tác giả, nhà xb và giá bán

--18. Viết Store Procedure:
---◦ SP_Them_Sach: thêm mới một cuốn sách

---◦ SP_Tim_Sach: Tìm các cuốn sách theo từ khóa

---◦ SP_Sach_ChuyenMuc: Liệt kê các cuốn sách theo mã chuyên mục

---19. Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho (số lượng > 0)

---20. Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên mục này

