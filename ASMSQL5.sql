--MSSQL Assignment 05
--1,2 Viết các câu lệnh để tạo các bảng như thiết kế
Create Database ASM05

Go
Use ASM05

Go
Create Table Person
(
 ID smallint Constraint PK_Contact Primary Key (ID),
 HoVaTen varchar(60) NOT NULL,
 NgaySinh date,
 DiaChi varchar(120)
)

Go
Create Table PhoneNumber
(
 ID smallint Constraint FK_Contact Foreign Key (ID) References Person(ID),
 DienThoai numeric
)

Go
--3. Viết các câu lệnh để thêm dữ liệu vào các bảng
Insert Into Person Values ('101', 'Vu Hoang Nam', '1996-01-08', 'Hoang Dao Thuy, Ha Noi')
Insert Into Person Values ('102', 'Chu Bao Ngoc', '1996-07-11', 'Minh Khai, Ha Noi')
Insert Into Person Values ('103', 'Nguyen Thanh Tung', '1996-07-09', 'Thuy Khue, Ha Noi')
Insert Into Person Values ('104', 'Hoang Dung', '1996-04-20', 'Nguyen Thi Thap, Ha Noi')
Insert Into Person Values ('105', 'Bui Huu Viet Hung', '1996-05-07', NULL)
Insert Into Person Values ('106', 'Vu Hoang Nam', '1996-01-08', 'Hoang Dao Thuy, Ha Noi')
Insert Into Person Values ('107', 'Nguyen Van An', '2009-12-12', 'Hoang Dao Thuy, Ha Noi')
Go
Insert Into PhoneNumber Values ('101', 0917463454)
Insert Into PhoneNumber Values ('102', 01653486187)
Insert Into PhoneNumber Values ('103', 0946510796)
Insert Into PhoneNumber Values ('104', 0984075186)
Insert Into PhoneNumber Values ('105', 01658904232)
Insert Into PhoneNumber Values ('106', 0942998858)
Insert Into PhoneNumber Values ('107', 123456789)

Go
--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách những người trong danh bạ
Select * From Person
go
--b) Liệt kê danh sách số điện thoại có trong danh bạ
Select * From PhoneNumber
go
--5. Viết các câu lệnh truy vấn để lấy
--a) Liệt kê danh sách người trong danh bạ theo thứ thự alphabet.
Select * From Person
Order By HoVaTen ASC

Go
--b) Liệt kê các số điện thoại của người có thên là Nguyễn Văn An.
Select HoVaTen, DienThoai From Person As A
Inner Join PhoneNumber As B On A.ID = B.ID
Where HoVaTen like 'Nguyen Van An'

Go
--c) Liệt kê những người có ngày sinh là 12/12/09
Select * From Person
Where NgaySinh = '2009-12-12'

Go
--6. Viết các câu lệnh truy vấn để
--a) Tìm số lượng số điện thoại của mỗi người trong danh bạ
Select HoVaTen, Count(*) As SoLuongSoDT From PhoneNumber As B
Inner Join Person As A On A.ID = B.ID
Group By HoVaTen

Go
--b) Tìm tổng số người trong danh bạ sinh vào thang 12.
Select Count(HoVaTen) as SoNguoisinhthang12 From Person
Where DatePart(mm, NgaySinh) = 12

Go
--c) Hiển thị toàn bộ thông tin về người, của từng số điện thoại.
Select HoVaTen, NgaySinh, DiaChi, DienThoai
From Person As A
Inner Join PhoneNumber As B On A.ID = B.ID

Go
--d) Hiển thị toàn bộ thông tin về người, của số điện thoại 123456789
Declare @Number bigint
Set @Number = '123456789'
Select HoVaTen, NgaySinh, DiaChi, DienThoai
From Person As A
Inner Join PhoneNumber As B On A.ID = B.ID
Where DienThoai = @Number
--7. Thay đổi những thư sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại.
Alter Table Person
Add Constraint dateofbirth Check (NgaySinh < GetDate())

Go
--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.
Alter Table PhoneNumber Drop Constraint FK_Contact
Alter Table Person Drop Constraint PK_Contact

Alter Table Person Add Constraint PK_Contact Primary Key (ID)
Alter Table Person Add Constraint FK_Contact Foreign Key (ID) References Person(ID)

Go
--c) Viết câu lệnh để thêm trường ngày bắt đầu liên lạc.
Alter Table PhoneNumber
Add NgayBatDauLienLac date

Go
--8. Thực hiện các yêu cầu sau
--a) Thực hiện các chỉ mục sau(Index)
---◦ IX_HoTen : đặt chỉ mục cho cột Họ và tên
Create NonClustered Index IX_FullName
On Person(HoVaTen)

Go
---◦ IX_SoDienThoai: đặt chỉ mục cho cột Số điện thoại
Create NonClustered Index IX_PhoneNumber
On PhoneNumber(DienThoai)

Go
--b) Viết các View sau:
---◦ View_SoDienThoai: hiển thị các thông tin gồm Họ tên, Số điện thoại
Create View View_SoDienThoai
As
Select HoVaTen, DienThoai
From Person As A
Inner Join PhoneNumber As B On A.ID = B.ID

Go
Select * From View_SoDienThoai

Go
---◦ View_SinhNhat: Hiển thị những người có sinh nhật trong tháng hiện tại (Họ tên, Ngày sinh, Số điện thoại)
Create View View_SinhNhat
As
Select HoVaTen, NgaySinh, DienThoai
From Person As A
Inner Join PhoneNumber As B On A.ID = B.ID
Where DatePart(mm, NgaySinh) = GetDate()

Go
Select * From View_SinhNhat

Go
--c) Viết các Store Procedure sau:
---◦ SP_Them_DanhBa: Thêm một người mới vào danh bạn
Create Procedure SP_Them_DanhBa
 @ID smallint,
 @Name char(60),
 @BirthDate date,
 @Address char(120)
As
Begin
 Insert Into Person (ID, HoVaTen, NgaySinh, DiaChi)
 Values (@ID, @Name, @BirthDate, @Address)
End

Go
Execute SP_Them_DanhBa '107', 'Do Huy Phong', '1995-01-25', 'Lang Ha, Ha Noi'
Execute SP_Them_DanhBa '108', 'Trinh Bach', '1995-01-30', NULL

Go
Insert Into PhoneNumber (ID, DienThoai) Values ('107', '0982336668')
Insert Into PhoneNumber (ID, DienThoai) Values ('108', '01697151420')

Go
---◦ SP_Tim_DanhBa: Tìm thông tin liên hệ của một người theo tên (gần đúng)
Create Procedure SP_Tim_DanhBa
 @FullName char(60)
As
Select HoVaTen, NgaySinh, DiaChi, DienThoai
From Person As A
Inner Join PhoneNumber As B On A.ID = B.ID
Where HoVaTen = @FullName

Go
Execute SP_Tim_DanhBa 'Trinh Bach'

Go