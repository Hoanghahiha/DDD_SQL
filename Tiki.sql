CREATE DATABASE TIKI
GO
DROP TABLE Product

CREATE TABLE Product
(CusID INT,
Name TEXT,
Email NVARCHAR(50),
Phone INT,
Level INT,
Status NVARCHAR(50))
GO

INSERT INTO Product VALUES (1, 'Hoang Ha', 'hata@gmail.com',987634,3,'Good')
INSERT INTO Product VALUES (2, 'Thanh Thanh', 'tahnh@gmail.com',987634,1,'Good')
INSERT INTO Product VALUES (3, 'Quang Khai', 'khai@gmail.com',987634,2,'Good')
INSERT INTO Product VALUES (4, 'Van Hau', 'hau@gmail.com',987634,4,'Good')
INSERT INTO Product VALUES (5, 'Hoang Yen', 'yen@gmail.com',987634,5,'Good')
GO

UPDATE Product SET Name = 'Trung Kien' WHERE Email='yen@gmail.com'
DELETE FROM Product WHERE CusID = 4


SELECT * FROM Product