--MSSQL Assignment 03
--1,2 Viết các câu lệnh để tạo các bảng như thiết kế
Create Database ASM03

Go
Use ASM03

Go

Create Table KhachHang
(
 MaKH smallint Constraint PK_Customer Primary Key (MaKH),
 TenKH varchar(60) NOT NULL,
 SoCMND int Constraint CK_IdentityCard Check (SoCMND > 0),
 DiaChi varchar(120)
)
GO
Create Table ThueBao
(
 MaTB char(5) Constraint PK_Subscription Primary Key (MaTB),
 SoThueBao bigint Constraint CK_Number Check (SoThueBao > 0) NOT NULL,
 LoaiThueBao varchar(30) NOT NULL
)
GO
Create Table DangKy
(
 MaKH smallint Constraint FK_Customer Foreign Key (MaKH) References KhachHang(MaKH),
 MaTB char(5) Constraint FK_Subscription Foreign Key (MaTB) References ThueBao(MaTB),
 NgayDangKy date
)
GO
--3) Viết các câu lệnh để thêm dữ liệu vào các bảng
Insert Into ThueBao Values ('TB001', '0917463454', 'Tra truoc')
Insert Into ThueBao Values ('TB007', '0123456789', 'Tra truoc')
Insert Into ThueBao Values ('TB002', '0942998858', 'Tra truoc')
Insert Into ThueBao Values ('TB003', '0913812802', 'Tra truoc')
Insert Into ThueBao Values ('TB004', '01247610319', 'Tra truoc')
Insert Into ThueBao Values ('TB005', '0936255596', 'Tra sau')
Insert Into ThueBao Values ('TB006', '01259586979', 'Tra truoc')
GO
Insert Into KhachHang Values ('101', 'Vu Hoang Nam', '013273654', 'Hoang Dao Thuy, Ha Noi')
Insert Into KhachHang Values ('102', 'Ngo Minh Duc', NULL, 'Phuong Mai, Ha Noi')
Insert Into KhachHang Values ('103', 'Nguyen Van Hoc', NULL, 'Le Van Luong, Ha Noi')
Insert Into KhachHang Values ('104', 'Nguyen Viet Anh', NULL, 'Cu Loc, Ha Noi')
Insert Into KhachHang Values ('105', 'Nguyen Viet Anh', '123456789', 'Cu Loc, Ha Noi')
GO
Insert Into DangKy Values ('101', 'TB001', '2015-02-14')
Insert Into DangKy Values ('105', 'TB002', '2009-12-12')
Insert Into DangKy Values ('102', 'TB003', '2014-12-31')
Insert Into DangKy Values ('103', 'TB005', '2013-12-31')
Insert Into DangKy Values ('104', 'TB006', '2011-09-05')
Insert Into DangKy Values ('105', 'TB007', '2011-09-05')
GO
--4) Viết các câu lệnh để thêm dữ liệu vào các bảng
--a) Hiển thị toàn bộ thông tin của các khách hàng của công ty
Select * From KhachHang
--b) Hiển thị toàn bộ thông tin của các số thuê bao của công ty
Select * From ThueBao
--5) Viết các câu lệnh truy vấn để lấy
--a) Hiển thị toàn bộ thông tin của thuê bao có số: 0123456789
Declare @Number bigint
Set @Number = 0123456789
Select * From ThueBao
Where SoThueBao = @Number
--b) Hiển thị thông tin về khách hàng có số CMTND: 123456789
Declare @Card int
Set @Card = 123456789
Select * From KhachHang
Where SoCMND = @Card
--c) Hiển thị các số thuê bao của khách hàng có số CMTND:123456789
Select TenKH, SoCMND, SoThueBao, LoaiThueBao From DangKy As C
Inner Join KhachHang As A On A.MaKH = C.MaKH
Inner Join ThueBao As B On B.MaTB = C.MaTB
Where SoCMND = 123456789
--d) Liệt kê các thuê bao đăng ký vào ngày 12/12/09
Select SoThueBao, LoaiThueBao, NgayDangKy From DangKy As C
Inner Join ThueBao As B On B.MaTB = C.MaTB
Where NgayDangKy = '2009-12-12'
GO
--e) Liệt kê các thuê bao có địa chỉ tại Hà Nội
Select TenKH, DiaChi, SoThueBao, LoaiThueBao From DangKy As C
Inner Join ThueBao As B On B.MaTB = C.MaTB
Inner Join KhachHang As A On A.MaKH = C.MaKH
Where DiaChi like '%Ha Noi%'
GO
--6) Viết các câu lệnh truy vấn để lấy
--a) Tổng số khách hàng của công ty
Select Count(*) From KhachHang
--b) Tổng số thuê bao của công ty
Select Count(*) From ThueBao
--c) Tổng số thuê bao đăng ký ngày 12/12/09
Select Count(SoThueBao) AS TongsoTBDKNgay From DangKy As C
Inner Join ThueBao As B On B.MaTB = C.MaTB
Where NgayDangKy = '2009-12-12'

Go
--d) Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao
Select * From KhachHang AS A
INNER JOIN DangKy AS C ON C.MaKH = A.MaKH
INNER JOIN ThueBao AS B ON B.MaTB = C.MaTB
GO

--7) Thay đổi những thay đổi sau trên cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày đăng ký là not null
Alter Table DangKy
Alter Column NgayDangKy date NOT NULL
--b) Viết câu lệnh để thay đổi trường ngày đăng ký là trước hoặc bằng ngày hiện tại
Alter Table DangKy
Add Constraint CK_RegistrationDate Check (NgayDangKy < GetDate() or NgayDangKy = GetDate())
--c) Viết câu lệnh để thêm trường số điểm thưởng cho mỗi số thuê bao
Alter Table ThueBao
Add SoDiemThuong tinyint Check (SoDiemThuong >= 0)
--d)  Viết câu lệnh để thay đổi số điện thoại phải bắt đầu 09
ALTER TABLE ThueBao
DROP COLUMN SoThueBao
GO
ALTER TABLE ThueBao
  ADD SoThueBao VARCHAR(10);
 GO
ALTER TABLE ThueBao
ADD CONSTRAINT CK_Phone CHECK (SoThueBao LIKE '09%')
GO
SELECT * FROM ThueBao
--8) Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (Index) cho cột Tên khách hàng của bảng chứa thông tin khách hàng
Alter Table DangKy
Drop Constraint FK_Customer

Alter Table KhachHang
Drop Constraint PK_Customer

Create Unique Clustered Index IX_CustomerName
On KhachHang(TenKH)

Alter Table KhachHang
Add Constraint PK_Customer Primary Key (MaKH)

Alter Table DangKy
Add Constraint FK_Customer Foreign Key (MaKH) References KhachHang(MaKH)

Go
Alter Table ThongTinKhachHang
Add Constraint PK_CustomerID Primary Key (MaKhachHang)

Go
--b) Viết các View sau:
---View_KhachHang: Hiển thị các thông tin Mã khách hàng, Tên khách hàng, địa chỉ
Create View View_KhachHang
As
Select MaKH, TenKH, DiaChi
From KhachHang

Go
Select * From View_KhachHang

Go
---View_KhachHang_ThueBao: Hiển thị thông tin Mã khách hàng, Tên khách hàng, Số thuê bao
Create View View_KhachHang_ThueBao
As
Select TenKH, SoThueBao
From DangKy As C
Inner Join KhachHang As A On A.MaKH = C.MaKH
Inner Join ThueBao As B On B.MaTB = C.MaTB

Go
Select * From View_KhachHang_ThueBao

Go

--c) Viết các Store Procedure sau:
---SP_TimKH_ThueBao: Hiển thị thông tin của khách hàng với số thuê bao nhập vào
Create Procedure SP_TimKH_ThueBao
 @Number bigint
As
Select TenKH, SoCMND, DiaChi
From DangKy As C
Inner Join KhachHang As A On A.MaKH = C.MaKH
Inner Join ThueBao As B On B.MaTB = C.MaTB
Where SoThueBao = @Number

Go
Execute SP_TimKH_ThueBao '01259586979'

Go
---SP_TimTB_KhachHang: Liệt kê các số điện thoại của khách hàng theo tên truyền vào
Create Procedure SP_TimTB_KhachHang
 @Name char(60)
As
Select TenKH, SoThueBao As SoDienThoai
From DangKy As C
Inner Join KhachHang As A On A.MaKH = C.MaKH
Inner Join ThueBao As B On B.MaTB = C.MaTB
Where TenKH = @Name

Go
Execute SP_TimTB_KhachHang 'Nguyen Van Hoc'

Go
---SP_ThemTB: Thêm mới một thuê bao cho khách hàng
Create Procedure SP_ThemTB
 @SubscriptionID char(5),
 @SubscriptionNumber bigint,
 @SubscriptionType varchar(30)
As
Begin
 Insert Into ThueBao (MaTB, SoThueBao, LoaiThueBao)
 Values (@SubscriptionID, @SubscriptionNumber, @SubscriptionType)
End

Go
Execute SP_ThemTB 'N1007', '0984262810', 'Tra truoc'

Go
---SP_HuyTB_MaKH: Xóa bỏ thuê bao của khách hàng theo Mã khách hàng
Create Procedure SP_HuyTB_MaKH
 @CustomerID int
As
Begin
 Delete From DangKy
 Where MaKH = @CustomerID
End

Go
Execute SP_HuyTB_MaKH 104

Go