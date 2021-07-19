--LAB GUIDE – SEMESTER 1 – MSSQL I.10 COURSE: MSSQL LAB: 9
--Phần I: Làm theo hướng dẫn – 15 phút
--Bài 1: Tạo và sử dụng một khung nhìn đơn giản
--1. Tạo một CSDL có tên là Lab11.
CREATE DATABASE Lab11
GO
USE Lab11
GO
--2. Tạo một khung nhìn có tên là ProductList, khung nhìn này sử dụng các cột ProductID và Name của bảng Production.Product của CSDL AdventureWorks.
CREATE VIEW ProductList
AS
SELECT ProductID, Name FROM AdventureWorks2019.Production.Product
--3. Sử dụng khung nhìn vừa tạo bằng một câu lệnh truy vấn đơn giản
SELECT * FROM ProductList
--Bài 2: Tạo khung nhìn có sử dụng câu lệnh JOIN.
--11. Tạo một khung nhìn có tên là SalesOrderDetail sử dụng 2 bảng Sales.SalesOrderDetail và Production.Product của CSDL AdventureWorks. Khung nhìn này sẽ tham chiếu đến các cột ProductID và Name của bảng Production.Product, các cột UnitPrice và OrderQty của bảng Sales.SalesOrderDetail, ngoài ra thì khung nhìn còn chứa một cột có tên [Total Price] được tính dựa trên 2 cột UnitPrice và UnitPrice.
CREATE VIEW SalesOrderDetail
AS
SELECT pr.ProductID, pr.Name, od.UnitPrice, od.OrderQty,
od.UnitPrice*od.OrderQty as [Total Price]
FROM AdventureWorks2019.Sales.SalesOrderDetail od
JOIN AdventureWorks2019.Production.Product pr
ON od.ProductID=pr.ProductID
--2. Sử dụng khung nhìn vừa tạo bằng cách thực hiện một câu lệnh truy vấn đến khung nhìn này:
SELECT * FROM SalesOrderDetail
--Phần III: Bài tập tự làm – 45 phút : Tạo một CSDL dựa vào sơ đồ sau:
CREATE TABLE Customer
(
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
CustomerName VARCHAR(50),
Address VARCHAR(100),
Phone VARCHAR(12)
)
GO

CREATE TABLE Book
(
BookCode INT PRIMARY KEY,
Category VARCHAR(50),
Author VARCHAR(50),
Publisher VARCHAR(50),
Title VARCHAR(100),
Price INT,
InStore INT
)
GO

CREATE TABLE BookSold
(
BookSoldID INT PRIMARY KEY,
CustomerID INT CONSTRAINT FK_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
BookCode INT CONSTRAINT FK_BookCode FOREIGN KEY(BookCode) REFERENCES Book(BookCode),
Date DATETIME,
Price INT,
Amount INT,
)
GO

--Chèn ít nhất 5 bản ghi vào bảng Books, 5 bản ghi vào bảng Customer và 10 bản ghi vào bảng BookSold.
INSERT INTO Book VALUES (1000,'Van Hoc','Hoai Nam','Kim Dong','Con duong hoa nau do',59000,20)
INSERT INTO Book VALUES (1001,'IT','Viet My','Viet Nam','SQl Server Book',29000,30)
INSERT INTO Book VALUES (1002,'Toan Hoc','Hoang Minh','Kim Dong','Toan 12',39000,40)
INSERT INTO Book VALUES (1003,'Lich Su','Hoang Minh','Kim Dong','Ly 12',29000,20)
INSERT INTO Book VALUES (1004,'Dia Ly','Hoang Minh','Kim Dong','Dia Ly 11',49000,20)
GO

INSERT INTO Customer VALUES ('Vu Hoai Dang','Ha Noi','938293')
INSERT INTO Customer VALUES ('Vu Ngan Trang','Ha Noi','938234')
INSERT INTO Customer VALUES ('Ta Hoang Ha','Ha Noi','939949')
INSERT INTO Customer VALUES ('Hoang Nam Giang','Ho Chi Minh','934568')
INSERT INTO Customer VALUES ('Hoang Ngan Thanh','Bac Ninh','939343')
GO

SELECT * FROM Customer
GO

INSERT INTO BookSold VALUES (100,1,1000,'2020-07-12',60000,5)
INSERT INTO BookSold VALUES (101,2,1001,'2020-07-12',30000,15)
INSERT INTO BookSold VALUES (102,3,1002,'2020-07-12',40000,5)
INSERT INTO BookSold VALUES (103,4,1003,'2020-07-12',30000,10)
INSERT INTO BookSold VALUES (104,5,1004,'2020-07-12',50000,7)
GO

--2. Tạo một khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã bán được của mỗi cuốn sách.
CREATE VIEW BooksView
AS
SELECT A.BookCode, A.Title, A.Price, B.Amount FROM Book A
JOIN BookSold B
ON A.BookCode = B.BookCode
GO

SELECT * FROM BooksView
GO

--Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm theo số lượng các cuốn sách mà khách hàng đó đã mua.
CREATE VIEW CustomerBuyView
AS
SELECT A.CustomerID, A.CustomerName, A.Address, B.Amount FROM Customer A
JOIN BookSold B
ON A.CustomerID = B.CustomerID
GO

SELECT * FROM CustomerBuyView
GO

--4. Tạo một khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) đã mua sách vào tháng trước, kèm theo tên các cuốn sách mà khách hàng đã mua.
CREATE VIEW CustomerBuyViewBooks
AS
SELECT A.CustomerID, A.CustomerName, A.Address, C.Title FROM Customer A
JOIN BookSold B
ON A.CustomerID = B.CustomerID
JOIN Book C
ON C.BookCode = B.BookCode
WHERE Date < GETDATE() AND Date > '2021-06-19'

SELECT * FROM CustomerBuyViewBooks
GO

--5. Tạo một khung nhìn chứa danh sách các khách hàng kèm theo tổng tiền mà mỗi khách hàng đã chi cho việc mua sách.
CREATE VIEW CustomerBuyMoneyView
AS
SELECT A.CustomerID, A.CustomerName, B.Amount*B.Price AS [Tong Chi] FROM Customer A
JOIN BookSold B
ON A.CustomerID = B.CustomerID
GO

SELECT * FROM CustomerBuyMoneyView
GO







---                    Phần IV: Bài tập về nhà 

--Tạo một cơ sở dữ liệu dựa vào sơ đồ sau:
CREATE TABLE Class
(
ClassCode varchar(10) primary key,
HeadTeacher varchar(30),
Room varchar(30),
TimeSlot char,
CloseDate datetime
)
Go

CREATE TABLE Student
(
RollNo varchar(10) primary key,
ClassCode varchar(10) constraint fk_ClassCode foreign key(ClassCode) references Class(ClassCode),
FullName varchar(30),
Male bit,
Birthdate datetime,
Address varchar(30),
Provice char(2),
Email varchar(30)
)
Go

CREATE TABLE Subject
(
SubjectCode varchar(10)  primary key,
SubjectName varchar(40),
WMark bit,
PMark bit,
WTest_per int,
PTest_per int
)
Go

CREATE TABLE Mark
(
RollNo varchar(10) constraint fk_rollno foreign key(RollNo) references Student(RollNo),
SubjectCode varchar(10) constraint fk_Sbcode foreign key(SubjectCode) references Subject(SubjectCode),
WMark float,
PMark float,
Mark float,
Primary key(RollNo,SubjectCode)
)

--1. Chèn ít nhất 5 bản ghi cho từng bảng ở trên.
INSERT INTO Class VALUES ('TM203','Dang Kim Thi','Class 06','M','2023-07-19')
INSERT INTO Class VALUES ('TM204','Nguyen Van Luan','Class 05','L','2023-07-19')
INSERT INTO Class VALUES ('TM205','Hoang Hoai Giang','Class 04','A','2023-07-19')
INSERT INTO Class VALUES ('TM206','Nguyen Mi Linh','Class 03','N','2023-07-19')
INSERT INTO Class VALUES ('TM207','Ly Van Vinh','Class 02','M','2023-07-19')
GO

INSERT INTO Student VALUES ('A0001','TM203','Ta Hoang Ha','1','1993-11-18','Ha Noi','HN','hatavn93@gmail.com')
INSERT INTO Student VALUES ('A0002','TM204','Vo Hoai Thanh','0','2003-11-10','Ha Noi','HN','hoaithanh@gmail.com')
INSERT INTO Student VALUES ('A0003','TM205','Nguyen Van Vu','1','1999-11-8','Bac Ninh','BN','vanvu@gmail.com')
INSERT INTO Student VALUES ('A0004','TM206','Hoang Ngan Trang','0','1993-1-18','Ha Noi','HN','ngantrang@gmail.com')
INSERT INTO Student VALUES ('A0005','TM207','Ly Lien Kiet','1','1990-11-8','Can Tho','CT','lienkiet@gmail.com')
GO

INSERT INTO Subject VALUES ('H0001','HTML5','1','1','10','10')
INSERT INTO Subject VALUES ('C0001','Elementary Programing with C','1','1','10','10')
INSERT INTO Subject VALUES ('J0001','Javascript','1','1','10','10')
INSERT INTO Subject VALUES ('D0001','Database Design & Development','1','1','10','10')
INSERT INTO Subject VALUES ('B0001','BootStrap and jQuery ','1','1','10','10')
GO

INSERT INTO Mark VALUES ('A0001','H0001','8.0','10.0','9.0')
INSERT INTO Mark VALUES ('A0001','B0001','8.5','10.0','9.25')
INSERT INTO Mark VALUES ('A0002','C0001','7.0','8.0','7.5')
INSERT INTO Mark VALUES ('A0003','J0001','7.0','9.0','8.0')
INSERT INTO Mark VALUES ('A0004','D0001','4.0','8.0','6.0')
INSERT INTO Mark VALUES ('A0005','B0001','5.0','8.0','6.5')
GO

--2. Tạo một khung nhìn chứa danh sách các sinh viên đã có ít nhất 2 bài thi (2 môn học khác nhau).
CREATE VIEW Studenttwosubject
AS
SELECT FullName, Male, Birthdate, Address, Email, SubjectCode FROM Student A
JOIN Mark B
ON A.RollNo = B.RollNo
WHERE COUNT(B.SubjectCode) > 1

--3. Tạo một khung nhìn chứa danh sách tất cả các sinh viên đã bị trượt ít nhất là một môn.
CREATE VIEW Studentdropsubject
AS
SELECT FullName, Male, Birthdate, Address, Email, SubjectCode FROM Student A
JOIN Mark B
ON A.RollNo = B.RollNo
WHERE WMark < 6.0 OR PMark < 6.0
SELECT * FROM Studentdropsubject

--4. Tạo một khung nhìn chứa danh sách các sinh viên đang học ở TimeSlot M.
CREATE VIEW Studenttimesubject
AS
SELECT FullName, Male, Birthdate, Address, Email, TimeSlot FROM Student A
JOIN Class B
ON A.ClassCode = B.ClassCode
WHERE TimeSlot = 'M'
SELECT * FROM Studenttimesubject

--5. Tạo một khung nhìn chứa danh sách các giáo viên có ít nhất 3 học sinh thi trượt ở bất cứ môn nào
CREATE VIEW TeacherdropStudent
AS
SELECT A.ClassCode, HeadTeacher FROM Class A
JOIN Student C
ON C.ClassCode = A.ClassCode
JOIN Mark B
ON B.RollNo = C.RollNo
WHERE WMark < 6.0 OR PMark < 6.0
SELECT * FROM TeacherdropStudent
--6. Tạo một khung nhìn chứa danh sách các sinh viên thi trượt môn EPC của từng lớp. Khung nhìn này phải chứa các cột: Tên sinh viên, Tên lớp, Tên Giáo viên, Điểm thi môn EPC.
CREATE VIEW StudentsdropSubCode
AS
SELECT FullName, A.ClassCode, HeadTeacher, WMark, PMark, Mark FROM Student A
JOIN Class B ON B.ClassCode = A.ClassCode
JOIN Mark C ON C.RollNo = A.RollNo
WHERE WMark < 6.0 OR PMark < 6.0
SELECT * FROM StudentsdropSubCode