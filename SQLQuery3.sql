--Sử dụng Database
USE AdventureWorks2019
SELECT * FROM Production.Product
GO

--Khai báo biến, đặt giá trị cho biến và cách lấy giá trị bằng biến
DECLARE @depID INT
SET @depID = 1
SELECT Name, ProductNumber FROM Production.Product WHERE ProductID = @depID
GO
DECLARE @depID INT
SET @depID = 1
SELECT * FROM Production.Product WHERE ProductID = @depID
GO
DECLARE @ballID INT
SET @ballID = 1
SELECT ProductID FROM Production.Product WHERE MakeFlag = @ballID

--Gọi biến toàn cục 
SELECT @@CONNECTIONS
SELECT @@TOTAL_WRITE
GO

--Hàm trong SQL
SELECT * FROM Purchasing.ShipMethod

GO

SELECT SUM(ShipBase) FROM Purchasing.ShipMethod
SELECT AVG(ShipBase) FROM Purchasing.ShipMethod
SELECT MIN(ShipBase) FROM Purchasing.ShipMethod
SELECT MAX(ShipBase) FROM Purchasing.ShipMethod
SELECT COUNT(ShipBase) FROM Purchasing.ShipMethod
GO

SELECT GETDATE()
--Lấy ra giờ hệ thống
SELECT DATEPART(HH,GETDATE())
--Định dạng ngày dùng hàm Convert
SELECT CONVERT(Varchar(50), GETDATE(),103)
GO

--Lấy ra định danh cơ sở dữ liệu
SELECT DB_ID('Adventureworks2019')
GO

--Tạo cơ sở dữ liệu, bảng
CREATE DATABASE Ha
SELECT DB_ID('Ha')
SELECT DB_NAME(9)
GO

USE EXAMPLE3
SELECT * FROM dbo.Contacts

DELETE FROM dbo.Contacts
WHERE Telephonenumber = 9877667
GO

ALTER TABLE Contacts ADD ID INT
UPDATE Contacts SET ID = 1 WHERE Address='Ha Noi'
GO

INSERT INTO Contacts VALUES ('hata@gmail.com', N'Ta Hoang Ha',9548329339,N'Ha Noi',2)

CREATE LOGIN Ha FROM LOGIN Ha

CREATE TABLE Email
(Mail CHAR(20),
Name TEXT,
ID INT)
