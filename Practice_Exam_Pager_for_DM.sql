--					Practice Exam Pager for DM – Database Management (SQL Server)

--1. Create a database as requested above.
CREATE DATABASE SellingPoint
USE SellingPoint
GO

--2. Create table based on the above design.
CREATE TABLE Categories
(
CateID CHAR(6),
CateName NVARCHAR(100) NOT NULL,
Description NVARCHAR(200)
CONSTRAINT PK_CateID PRIMARY KEY(CateID)
)
GO

CREATE TABLE Parts
(
PartID INT IDENTITY,
PartName NVARCHAR(100) NOT NULL,
CateID CHAR(6) CONSTRAINT FK_CateID FOREIGN KEY(CateID) REFERENCES Categories(CateID),
Description NVARCHAR(1000),
Price MONEY NOT NULL DEFAULT(0),
Quantity INT DEFAULT(0),
Warranty INT DEFAULT(1),
Photo NVARCHAR(200) DEFAULT('photo/nophoto.png')
CONSTRAINT PK_PartID PRIMARY KEY(PartID)
)
GO

--3. Insert into each table at least three records.
INSERT INTO Categories VALUES ('N0001',N'RAM',N'Random-access memory (RAM; /ræm/) is a form of computer memory that can be read and changed in any order, typically used to store working data and machine code')
INSERT INTO Categories VALUES ('N0002',N'CPU',N'Also called a central processor, main processor or just processor, is the electronic circuitry that executes instructions comprising a computer program')
INSERT INTO Categories VALUES ('N0003',N'HDD',N'Is an electro-mechanical data storage device that stores and retrieves digital data using magnetic storage and one or more rigid rapidly rotating platters coated with magnetic material')
SELECT * FROM Categories
GO

INSERT INTO Parts(PartName,CateID,Description,Price,Quantity,Warranty) VALUES (N'Transistor','N0001',N'Provide stable power for RAM','200',1,2)
INSERT INTO Parts(PartName,CateID,Description,Price,Quantity,Warranty) VALUES (N'Core i7','N0002',N'Intel® Core™ i7 Processors. 11th Gen Intel® Core™ mobile processors power the ultimate thin & light laptops with industry-leading CPU performance','2000',1,5)
INSERT INTO Parts(PartName,CateID,Description,Price,Quantity,Warranty) VALUES (N'Core i5','N0002',N'Intel® Core™ i5 Processors. 11th Gen Intel® Core™ mobile processors power the ultimate thin & light laptops with industry-leading CPU performance','1000',1,3)
INSERT INTO Parts(PartName,CateID,Description,Price,Quantity,Warranty) VALUES (N'Reader cluster','N0003',N'The reader cluster includes: Data read/write head. Need to move the reader.','2000',1,3)
INSERT INTO Parts(PartName,CateID,Description,Price,Quantity,Warranty) VALUES (N'Jum','N0003',N'Use to enable specific types of settings','20',1,7)

SELECT * FROM Parts
GO

--4. List all parts in the store with price > 100$
SELECT * FROM Parts
WHERE Price > 100
GO

--5. List all parts of the category ‘CPU’.
SELECT * FROM Parts A
INNER JOIN Categories B ON B.CateID = A.CateID
WHERE CateName = 'CPU'
GO

--6. Create a view v_Parts contains the following information (PartID, PartName, CateName, Price, Quantity) from table Parts and Categories.
CREATE VIEW v_Parts
AS
SELECT PartID, PartName, CateName, Price, Quantity FROM Parts A
INNER JOIN Categories B ON B.CateID = A.CateID
GO

SELECT * FROM v_Parts
GO

--7. Create a view v_TopParts about 5 parts with the most expensive price.
CREATE VIEW v_TopParts
AS
SELECT TOP(5) * FROM Parts
ORDER BY
Price DESC
GO

SELECT * FROM v_TopParts
GO