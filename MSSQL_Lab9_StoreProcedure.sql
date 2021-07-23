--                                        Store Procedure
--                                        Thủ Tục Lưu Trữ 
--Phần 1: Làm theo hướng dẫn
--Bài 1:Thực hiện câu lệnh và quan sát kết quả thu được:
USE AdventureWorks2019
GO
--Tạo một thủ tục lưu trữ lấy ra toàn bộ nhân viên vào làm theo năm có tham số đầu vào là một năm
CREATE PROCEDURE sp_DisplayEmployeesHireYear
@HireYear int
AS
SELECT * FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)=@HireYear
GO
--Để chạy thủ tục này cần phải truyền tham số vào là năm mà nhân viên vào làm
EXECUTE sp_DisplayEmployeesHireYear 2009
GO
--Tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có tham số đầu vào là một năm,
-- tham số đầu ra là số người vào làm trong năm này
CREATE PROCEDURE sp_EmployeesHireYearCount
@HireYear int,
@Count int OUTPUT
AS
SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)=@HireYear
GO
--Chạy thủ tục lưu trữ cần phải truyền vào 1 tham số đầu vào và một tham số đầu ra.
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount 2009, @Number OUTPUT
PRINT @Number
GO
----Tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có tham số đầu vào là một năm, hàm trả về số người vào làm năm đó
CREATE PROCEDURE sp_EmployeesHireYearCount2
@HireYear int
AS
DECLARE @Count int
SELECT @Count=COUNT(*) FROM HumanResources.Employee
WHERE DATEPART(YY, HireDate)=@HireYear
RETURN @Count
GO
--Chạy thủ tục lưu trữ cần phải truyền vào 1 tham số đầu và lấy về số người làm trong năm đó.
DECLARE @Number int
EXECUTE @Number = sp_EmployeesHireYearCount2 2009
PRINT @Number
GO
--Tạo bảng tạm #Student
CREATE TABLE #Students
(
RollNo varchar(6) CONSTRAINT PK_Students PRIMARY KEY,
FullName nvarchar(100),
Birthday datetime constraint DF_StudentsBirthday DEFAULT
DATEADD(yy, -18, GETDATE())
)
GO
--Tạo thủ tục lưu trữ tạm để chèn dữ liệu vào bảng tạm
CREATE PROCEDURE #spInsertStudents
@rollNo varchar(6),
@fullName nvarchar(100),
@birthday datetime
AS BEGIN
IF(@birthday IS NULL)
SET @birthday=DATEADD(YY, -18, GETDATE())
INSERT INTO #Students(RollNo, FullName, Birthday)
VALUES(@rollNo, @fullName, @birthday)
END
GO
--Sử dụng thủ tục lưu trữ để chèn dữ liệu vào bảng tạm
EXEC #spInsertStudents 'A12345', 'abc', NULL
EXEC #spInsertStudents 'A54321', 'abc', '12/24/2011'
SELECT * FROM #Students
--Tạo thủ tục lưu trữ tạm để xóa dữ liệu từ bảng tạm theo RollNo
CREATE PROCEDURE #spDeleteStudents
@rollNo varchar(6)
AS BEGIN
DELETE FROM #Students WHERE RollNo=@rollNo
END
--Xóa dữ liệu sử dụng thủ tục lưu trữ
EXECUTE #spDeleteStudents 'A12345'
GO
SELECT * FROM #Students
--Tạo một thủ tục lưu trữ sử dung lệnh RETURN để trả về một số nguyên
CREATE PROCEDURE Cal_Square @num int=0 AS
BEGIN
RETURN (@num * @num);
END
GO
--Chạy thủ tục lưu trữ
DECLARE @square int;
EXEC @square = Cal_Square 12;
PRINT @square;
GO
--Xem định nghĩa thủ tục lưu trữ bằng hàm OBJECT_DEFINITION
SELECT
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalI
nfo')) AS DEFINITION
--Xem định nghĩa thủ tục lưu trữ bằng
SELECT definition FROM sys.sql_modules
WHERE
object_id=OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO
--Thủ tục lưu trữ hệ thống xem các thành phần mà thủ tục lưu trữ phụ thuộc
sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO
USE AdventureWorks2019
GO
--Tạo thủ tục lưu trữ sp_DisplayEmployees
CREATE PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
GO
--Thay đổi thủ tục lưu trữ sp_DisplayEmployees
ALTER PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
GO
--Chạy thủ tục lưu trữ sp_DisplayEmployees
EXEC sp_DisplayEmployees
GO
--Xóa một thủ tục lưu trữ
DROP PROCEDURE sp_DisplayEmployees
GO



--
CREATE PROCEDURE sp_EmployeeHire3
AS
BEGIN
--Hiển thị
EXECUTE sp_DisplayEmployeesHireYear 2009
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount 2009, @Number OUTPUT
PRINT N'Số nhân viên vào làm năm 2009 là: ' +
CONVERT(varchar(3),@Number)
END
GO
--Chạy thủ tục lưu trữ
EXEC sp_EmployeeHire3
GO
--Thay đổi thủ tục lưu trữ sp_EmployeeHire có khối TRY ... CATCH
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
BEGIN TRY
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
--Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ truyền 2 tham số mà ta truyền 3
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT,
'123'
PRINT N'Số nhân viên vào làm năm là: ' +
CONVERT(varchar(3),@Number)
END TRY
BEGIN CATCH
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
END CATCH
PRINT N'Kết thúc thủ tục lưu trữ'
END
GO
--Chạy thủ tục sp_EmployeeHire
EXEC sp_EmployeeHire 1999
--Xem thông báo lỗi bên Messages không phải bên Result
--Thay đổi thủ tục lưu trữ sp_EmployeeHire sử dụng hàm @@ERROR
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
--Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ truyền 2 tham số mà ta truyền 3
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT,
'123'
IF @@ERROR <> 0
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
PRINT N'Số nhân viên vào làm năm là: ' +
CONVERT(varchar(3),@Number)
END
GO
--Chạy thủ tục sp_EmployeeHire
EXEC sp_EmployeeHire 1999



--                          Phần 2: Bài tập tự làm
CREATE DATABASE Toy
USE Toy
GO

CREATE TABLE Toys
(
ProductCode VARCHAR(5),
Name VARCHAR(30),
Category VARCHAR(30),
Manufacturer VARCHAR(40),
AgeRange VARCHAR(15),
UnitPrice MONEY,
Netweight INT,
QtyOnHand INT,
CONSTRAINT pk_productcode PRIMARY KEY(ProductCode)
)
GO

INSERT INTO Toys VALUES ('1000','Bup Be','Do choi be gai','HuangZhou','3+','20000',500,300)
INSERT INTO Toys VALUES ('1001','O to','Do choi be trai','HuangZhou','3+','50000',200,400)
INSERT INTO Toys VALUES ('1002','Xe lu','Do choi be trai','HuangZhou','3+','50000',100,100)
INSERT INTO Toys VALUES ('1003','Lego','Do choi lap ghep','HuangZhou','3+','100000',1000,30)
INSERT INTO Toys VALUES ('1004','Cau Ca','Do choi tri tue','HuangZhou','3+','20000',500,30)
INSERT INTO Toys VALUES ('1005','Bai Yugioh','Do choi tri tue','HuangZhou','3+','20000',500,110)
INSERT INTO Toys VALUES ('1006','Linh gac','Do choi','HuangZhou','3+','20000',400,600)
INSERT INTO Toys VALUES ('1007','Bong da','Do choi','HuangZhou','3+','20000',600,200)
INSERT INTO Toys VALUES ('1008','Khung long','Do choi','HuangZhou','3+','20000',100,100)
INSERT INTO Toys VALUES ('1009','Xep hinh','Do choi lap ghep','HuangZhou','3+','20000',700,50)
INSERT INTO Toys VALUES ('1010','Cung ten','Do choi','HuangZhou','3+','20000',600,40)
INSERT INTO Toys VALUES ('1011','Bida','Do choi tri tue','HuangZhou','3+','20000',200,240)
INSERT INTO Toys VALUES ('1012','Ngua go','Do choi','HuangZhou','3+','20000',600,300)
INSERT INTO Toys VALUES ('1013','Hop am nhac','Do choi','HuangZhou','3+','20000',500,30)
INSERT INTO Toys VALUES ('1014','Xep go','Do choi lap ghep','HuangZhou','3+','20000',300,300)
GO

--2. Viết câu lệnh tạo Thủ tục lưu trữ có tên là HeavyToys cho phép liệt kê tất cả các loại đồ chơi có trọng lượng lớn hơn 500g.
CREATE PROCEDURE HeavyToys
AS
SELECT * FROM Toys
WHERE Netweight > 500
GO

EXEC HeavyToys

GO

--3. Viết câu lệnh tạo Thủ tục lưu trữ có tên là PriceIncreasecho phép tăng giá của tất cả các loại đồ chơi lên thêm 10 đơn vị giá.
CREATE PROCEDURE PriceIncreasecho AS
SELECT ProductCode,Name,UnitPrice+10 AS SauKhiTangGia FROM Toys
GO

EXEC PriceIncreasecho

GO
--Viết câu lệnh tạo Thủ tục lưu trữ có tên là QtyOnHand làm giảm số lượng đồ chơi còn trong của hàng mỗi thứ 5 đơn vị
CREATE PROCEDURE QtyOnHand1 AS
SELECT ProductCode,Name,QtyOnHand,QtyOnHand-5 AS Tonsauthaydoi FROM Toys
GO

EXEC QtyOnHand1

GO



--                           Phần 3: Bài tập về nhà

--1. Ta đã có 3 thủ tục lưu trữ tên là HeavyToys,PriceIncrease, QtyOnHand. Viết các câu lệnh xem
--định nghĩa củacác thủ tục trên dùng 3 cách sau:
--- Thủ tục lưu trữ hệ thống sp_helptext:
sp_helptext HeavyToys
go
sp_helptext PriceIncreasecho
go
sp_helptext QtyOnHand
go
--- Khung nhìn hệ thống sys.sql_modules
SELECT definition FROM sys.sql_modules
WHERE
object_id=OBJECT_ID('QtyOnHand')
GO
SELECT definition FROM sys.sql_modules
WHERE
object_id=OBJECT_ID('HeavyToys')
GO
SELECT definition FROM sys.sql_modules
WHERE
object_id=OBJECT_ID('PriceIncreasecho')
GO
--- Hàm OBJECT_DEFINITION()
SELECT OBJECT_DEFINITION (OBJECT_ID(N'HeavyToys')) AS [ThucHienLenh]; 
SELECT OBJECT_DEFINITION (OBJECT_ID(N'PriceIncreasecho')) AS [ThucHienLenh]; 
SELECT OBJECT_DEFINITION (OBJECT_ID(N'QtyOnHand')) AS [ThucHienLenh]; 
--2. Viết câu lệnh hiển thị các đối tượng phụ thuộc của mỗi thủ tục lưu trữ trên
EXECUTE sp_depends HeavyToys
EXECUTE sp_depends PriceIncreasecho
EXECUTE sp_depends QtyOnHand
GO
--3. Chỉnh sửa thủ tục PriceIncreasevà QtyOnHandthêm câu lệnh cho phép hiển thị giá trị mới đã được cập nhật của các trường (UnitPrice,QtyOnHand).
ALTER PROCEDURE PriceIncreasecho AS
UPDATE Toys SET UnitPrice=UnitPrice+10000
GO
EXEC PriceIncreasecho
SELECT *FROM Toys
GO

ALTER PROCEDURE QtyOnHand AS
UPDATE Toys SET QtyOnHand=QtyOnHand-5
GO
EXEC QtyOnHand
SELECT *FROM Toys
GO
--4. Viết câu lệnh tạo thủ tục lưu trữ có tên là SpecificPriceIncrease thực hiện cộng thêm tổng số sản phẩm (giá trị trường QtyOnHand)vào giá của sản phẩm đồ chơi tương ứng
CREATE PROCEDURE SpecificPriceIncrease AS
UPDATE Toys SET UnitPrice=UnitPrice+QtyOnHand
GO
EXEC SpecificPriceIncrease
SELECT *FROM Toys
GO
--5. Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho thêm tính năng trả lại tổng số các bản ghi được cập nhật.
ALTER PROCEDURE SpecificPriceIncrease 
@number INT OUTPUT AS
UPDATE Toys SET UnitPrice=UnitPrice+QtyOnHand
SELECT ProductCode,Name,UnitPrice as Price,QtyOnHand FROM Toys
WHERE QtyOnHand>0
SELECT @number = @@Rowcount
GO
DECLARE @num int
EXECUTE SpecificPriceIncrease @num OUTPUT
PRINT @num
--6. Chỉnh sửa thủ tục lưu trữ SpecificPriceIncrease cho phép gọi thủ tục HeavyToysbên trong nó
ALTER PROCEDURE SpecificPriceIncrease 
@number int OUTPUT AS
UPDATE Toys SET UnitPrice=UnitPrice+QtyOnHand
SELECT ProductCode,Name,UnitPrice as Price,QtyOnHand FROM Toys
WHERE QtyOnHand>0
SELECT @number = @@Rowcount
EXECUTE HeavyToys
--7. Thực hiện điều khiển xử lý lỗi cho tất cả các thủ tục lưu trữ được tạo ra.
--8. Xóa bỏ tất cả các thủ tục lưu trữ đã được tạo ra
DROP PROCEDURE HeavyToys
DROP PROCEDURE PriceIncreasecho
DROP PROCEDURE QtyOnHand



--                          MSSQL Lab 12
--1. Xác định thuộc tính khóa (khóa chính, khóa ngoại) và viết câu lệnh thay đổi các trường với thuộc
--tính khóa vừa xác định.
--2. Thêm dữ liệu cho các bảng
CREATE DATABASE Practice
USE Practice
GO

CREATE TABLE Employee
(
EmployeeID INT,
Name VARCHAR(100),
Tel CHAR(11),
Email VARCHAR(30)
CONSTRAINT PK_EmployeeID PRIMARY KEY(EmployeeID)
)
GO

CREATE TABLE Project
(
ProjectID INT,
ProjectName VARCHAR(30),
StartDate DATETIME,
EndDate DATETIME,
Period INT,
Cost MONEY
CONSTRAINT PK_ProjectID PRIMARY KEY(ProjectID)
)
GO


CREATE TABLE Groups
(
GroupID INT,
GroupName VARCHAR(30),
LeaderID INT,
ProjectID INT CONSTRAINT FK_ProjectID FOREIGN KEY(ProjectID) REFERENCES Project(ProjectID)
CONSTRAINT PK_GroupID PRIMARY KEY(GroupID)
)
GO


CREATE TABLE GroupDetail
(
GroupID INT CONSTRAINT FK_GroupID FOREIGN KEY(GroupID) REFERENCES Groups(GroupID),
EmployeeID INT CONSTRAINT FK_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
Status CHAR(20)
)

INSERT INTO Employee VALUES (1000,'Ta Hoang Ha','0393946293','ha@gmail.com')
INSERT INTO Employee VALUES (1001,'Nguyen Kim Chung','0393942938','chung@gmail.com')
INSERT INTO Employee VALUES (1002,'Le Thi Lan','0393912443','lan@gmail.com')
INSERT INTO Employee VALUES (1003,'Pham Thanh Thanh','0393945693','thanh@gmail.com')
INSERT INTO Employee VALUES (1004,'Nguyen Van Ai','0393946224','ai@gmail.com')
GO

INSERT INTO Project VALUES (100,'Chinh phu dien tu','12/08/2010','12/10/2011',14,200000)
INSERT INTO Project VALUES (101,'Chinh phu so hoa','12/08/2010','12/10/2012',16,300000)
GO

INSERT INTO Groups VALUES (1,'TKLCBO',100215,100)
INSERT INTO Groups VALUES (2,'TKLNGT',100210,100)
GO

INSERT INTO GroupDetail VALUES (1,1000,'Da Lam')
INSERT INTO GroupDetail VALUES (1,1001,'Da Lam')
INSERT INTO GroupDetail VALUES (2,1002,'Dang Lam')
INSERT INTO GroupDetail VALUES (2,1003,'Sap Lam')
INSERT INTO GroupDetail VALUES (2,1004,'Sap Lam')
--3. Viết câu lệnh truy vấn để:
--a. Hiển thị thông tin của tất cả nhân viên
SELECT * FROM Employee
--b. Liệt kê danh sách nhân viên đang làm dự án “Chính phủ điện tử”
SELECT * FROM Employee A
INNER JOIN GroupDetail B ON B.EmployeeID = A.EmployeeID
INNER JOIN Groups C ON C.GroupID = B.GroupID
INNER JOIN Project D ON D.ProjectID = C.ProjectID
WHERE ProjectName = 'Chinh phu dien tu'
--c. Thống kê số lượng nhân viên đang làm việc tại mỗi nhóm
SELECT COUNT(EmployeeID) AS Tong_NV_Nhom, GroupID

FROM GroupDetail

GROUP BY GroupID;
--d. Liệt kê thông tin cá nhân của các trưởng nhó
SELECT * FROM Groups
--e. Liệt kê thông tin về nhóm và nhân viên đang làm các dự án có ngày bắt đầu làm trước ngày 12/10/2010
SELECT Name, GroupName, LeaderID, ProjectName FROM Employee A
INNER JOIN GroupDetail B ON B.EmployeeID = A.EmployeeID
INNER JOIN Groups C ON C.GroupID = B.GroupID
INNER JOIN Project D ON D.ProjectID = C.ProjectID
WHERE StartDate < '12/10/2010'
--f. Liệt kê tất cả nhân viên dự kiến sẽ được phân vào các nhóm làm việc
SELECT * FROM Employee A
INNER JOIN GroupDetail B ON B.EmployeeID = A.EmployeeID
WHERE Status = 'Sap Lam'
--g. Liệt kê tất cả thông tin về nhân viên, nhóm làm việc, dự án của những dự án đã hoàn thành
SELECT * FROM Employee A
INNER JOIN GroupDetail B ON B.EmployeeID = A.EmployeeID
WHERE Status = 'Da Lam'
--4. Viết câu lệnh kiểm tra:
--a. Ngày hoàn thành dự án phải sau ngày bắt đầu dự án
ALTER TABLE Project
ADD CONSTAINT ck_ngayduan
 CHECK (GETDATE(EndDate) > GETDATE(StartDate));
--b. Trường tên nhân viên không được null
ALTER TABLE Employee
ADD CONSTAINT ck_tenNV 
 CHECK (Name IS NOT NULL);
--c. Trường trạng thái làm việc chỉ nhận một trong 3 giá trị: inprogress, pending, done
ALTER TABLE GroupDetail
ADD CONSTAINT ck_status
 CHECK (Status ='Inprogress' OR Status = 'Pending' OR Status = 'Done');
--d. Trường giá trị dự án phải lớn hơn 1000
ALTER TABLE Project
ADD CONSTAINT ck_cost
 CHECK (Cost > 1000);
--e. Trưởng nhóm làm việc phải là nhân viên
ALTER TABLE Groups
ADD CONSTAINT ck_leader
 CHECK (Groups.LeaderID = Employee.EmployeeID);
--f. Trường điện thoại của nhân viên chỉ được nhập số và phải bắt đầu bằng số 0
ALTER TABLE Employee
ADD CONSTAINT ck_phone
 CHECK (Tel   );
--5. Tạo các thủ tục lưu trữ thực hiện:
--a. Tăng giá thêm 10% của các dự án có tổng giá trị nhỏ hơn 2000
CREATE PROCEDURE CostIncrease AS
SELECT ProjectID,ProjectName,Cost+Cost*0.1 AS SauKhiTang FROM Project
WHERE Cost < 2000
GO

EXEC CostIncrease

GO
--b. Hiển thị thông tin về dự án sắp được thực hiện
CREATE PROCEDURE SP_GroupDetailsaplam
AS
SELECT * FROM GroupDetail a
INNER JOIN Groups b on b.GroupID = a.GroupID
WHERE Status = 'Sap Lam'
GO

EXEC SP_GroupDetailsaplam

GO
--c. Hiển thị tất cả các thông tin liên quan về các dự án đã hoàn thành
CREATE PROCEDURE SP_GroupDetaildalam
AS
SELECT * FROM GroupDetail a
INNER JOIN Groups b on b.GroupID = a.GroupID
INNER JOIN Employee c ON c.EmployeeID = a.EmployeeID
WHERE Status = 'Da Lam'
GO

EXEC SP_GroupDetaildalam

GO
--6. Tạo các chỉ  mục:
--a. Tạo chỉ mục duy nhất tên là IX_Group trên 2 trường GroupID và EmployeeID của bảng GroupDetail
CREATE CLUSTERED INDEX IX_Group
ON GroupDetail(GroupID,EmployeeID)
GO
--b. Tạo chỉ mục tên là IX_Project trên trường ProjectName của bảng Project gồm các trường StartDate và EndDate
ALTER TABLE Project DROP CONSTRAINT PK_ProjectID
CREATE CLUSTERED INDEX IX_Project
ON Project(ProjectName)
--7. Tạo các khung nhìn để
--a. Liệt kê thông tin về nhân viên, nhóm làm việc có dự án đang thực hiện

--b. Tạo khung nhìn chứa các dữ liệu sau: tên Nhân viên, tên Nhóm, tên Dự án và trạng thái làm việc của Nhân viên.

--8. Tạo Trigger thực hiện công việc sau:
--a. Khi trường EndDate được cập nhậtthì tự động tính toán tổng thời gian hoàn thành dự án và cập nhật vào trường Period

--b. Đảm bảo rằng khi xóa một Group thì tất cả những bản ghi có liên quan trong bảng GroupDetail cũng sẽ bị xóa theo.

--c. Không cho phép chèn 2 nhóm có cùng tên vào trong bảng Group.