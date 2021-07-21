---                        INDEX - Chỉ Mục
--Phần 1: Làm theo hướng dẫn – 15phút
--1. Dùng SQL Management Studio tạo một cơ sở dữ liệu tên là Lab10:
CREATE DATABASE Lab10
USE Lab10
GO
--2.Sao dữ liệu từ bảng WorkOrder của cơ sở dữ liệu AdventueWorks sang cơ sở dữ liệu Lab10 vừa tạo bằng cách sử dụng những câu lệnh sau:
USE AdventureWorks2019
SELECT*INTO Lab10.dbo.WorkOrder FROM Production.WorkOrder
--3.Sao dữ liệu từ bảng WorkOrder của cơ sở dữ liệu Lab10 sang bảng WorkOrderIX của cơ sở dữ liệu Lab10:
USE Lab10
SELECT*INTO WorkOrderIX FROM WorkOrder
--4. Xem dữ liệu ở cả hai bảng:
SELECT*FROM WorkOrder
--Tại SQL Management Studio từ Menu chọn Query->Display Estimated Excution Plan. Cửa sổ hiển thị như sau:
SELECT*FROM WorkOrderIX
--6. Tạo một chỉ mục trên cột WorkOrderID của bảng WorkOrderIX bằng câu lệnh sau:
CREATE INDEX IX_WorkOrderID ON WorkOrderIX(WorkOrderID)
--7. Thực hiện 2 câu lệnh select sau:
SELECT*FROM WorkOrder where WorkOrderID=72000
SELECT*FROM WorkOrderIX where WorkOrderID=72000
--8. Thực hiện lại bước 5 và so sánh kết quả (trước và sau khi tạo index)



---                          Phần 2: Bài tập tự làm – 45phút
--Tạo cơ sở dữ liệu tên là CodeLean, trong đó tạo bảng Classes với cấu trúc như sau:
CREATE DATABASE CodeLearn
USE CodeLearn
GO

CREATE TABLE Classes
(
ClassName CHAR(6),
Teacher VARCHAR(30),
TimeSlot VARCHAR(30),
Class INT,
Lab INT
)
GO

--1. Tạo an unique, clustered index tên là MyClusteredIndex trên trường ClassName
CREATE UNIQUE CLUSTERED INDEX MyClusteredIndex
ON Classes(ClassName)
GO

--2.Tạo a nonclustered index tên là TeacherIndex trên trường Teacher
CREATE NONCLUSTERED INDEX TeacherIndex
ON Classes(Teacher)
GO

--3.Xóa chỉ mục TeacherIndex
DROP INDEX TeacherIndex
ON Classes

--Xây dựng lại MyClusteredIndex với các thuộc tính FILLFACTOR
ALTER INDEX MyClusteredIndex 
ON Classes REBUILD WITH (FILLFACTOR = 70)
GO

--5. Tạo một composite index tên là ClassLabIndex trên 2 trường Class và Lab.
CREATE NONCLUSTERED INDEX ClassLabIndex
ON Classes(Class,Lab)
GO

--6. Viết câu lệnh xem toàn bộ các chỉ mục của cơ sở dữ liệu CodeLean.
EXEC sp_helpindex 'Classes'


--                              Phần 3: Bài tập về nhà

--1. TẠO BẢNG và chèn dữ liệu phù hợp
CREATE TABLE Student
(
StudentNo INT PRIMARY KEY,
StudentName NVARCHAR(50),
StudentAddress NVARCHAR(100),
PhoneNo INT
)
GO

CREATE TABLE Department
(
DeptNo INT PRIMARY KEY,
DeptName NVARCHAR(50),
ManagerName NVARCHAR(30)
)
GO

CREATE TABLE Assignment
(
AssignmentNo INT PRIMARY KEY,
Description NVARCHAR(100)
)
GO

CREATE TABLE Works_Assign
(
JobID INT PRIMARY KEY,
StudentNo INT CONSTRAINT FK_StudentNo FOREIGN KEY(StudentNo) REFERENCES Student(StudentNo),
AssignmentNo INT CONSTRAINT FK_AssignmentNo FOREIGN KEY(AssignmentNo) REFERENCES Assignment(AssignmentNo),
TotalHours INT,
JobDetails NVARCHAR(450)
)
GO

INSERT INTO Student VALUES (1000,N'Ta Hoang Ha',N'Ha Noi',987653)
INSERT INTO Student VALUES (1001,N'Nguyen Van Nam',N'Ha Noi',987634)
INSERT INTO Student VALUES (1002,N'Ho Thi Thuy',N'Ha Noi',987343)
INSERT INTO Student VALUES (1003,N'Ngo Thu Thao',N'Ha Noi',987323)
INSERT INTO Student VALUES (1004,N'Dinh Hoang Nam',N'Ha Noi',912653)
GO

INSERT INTO Department VALUES (201,N'Ten Lua',N'Nguyen Van Nam')
INSERT INTO Department VALUES (202,N'Qui Dao',N'Dinh Hoang Trung')
INSERT INTO Department VALUES (203,N'Thien Thach',N'Nguyen Van Nam')
INSERT INTO Department VALUES (204,N'Big Bang',N'Nguyen Van Nam')
INSERT INTO Department VALUES (205,N'Earth',N'Dinh Hoang Trung')
GO

INSERT INTO Assignment VALUES (1,'Thong ke cac hanh tinh co trong he mat troi')
INSERT INTO Assignment VALUES (2,'Thong ke cac hanh tinh xa mat troi nhat')
INSERT INTO Assignment VALUES (3,'Thong ke cac hanh tinh gan mat troi nhat')
INSERT INTO Assignment VALUES (4,'Thong ke cac hanh tinh co su song trong he mat troi')
INSERT INTO Assignment VALUES (5,'Thong ke luc hut cac hanh tinh trong he mat troi')
GO

INSERT INTO Works_Assign VALUES (100,1000,1,72,N'Hoan Thanh')
INSERT INTO Works_Assign VALUES (101,1001,2,36,N'Hoan Thanh')
INSERT INTO Works_Assign VALUES (102,1002,3,42,N'Hoan Thanh')
INSERT INTO Works_Assign VALUES (103,1003,4,12,N'Hoan Thanh')
INSERT INTO Works_Assign VALUES (104,1004,5,24,N'Hoan Thanh')
GO

--2. Tạo một clustered index tên là IX_Student trên cột StudentNo của bảng Student
CREATE NONCLUSTERED INDEX IX_Student
ON Student(StudentNo)
GO

--3. Chỉnh sửa và xây dựng lại (rebuild) IX_Student đã được tạo trên bảng Student
ALTER INDEX IX_Student ON Student REBUILD
GO

--4. Tạo một chỉ non clustered index tên là IX_Dept trên bảng Department sử dụng 2 trường không khóa DeptName và DeptManagerNo.
CREATE NONCLUSTERED INDEX  IX_Dept
ON Department(DeptName, DeptNo)
GO