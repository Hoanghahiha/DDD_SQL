CREATE DATABASE BookLibrary
GO

DROP DATABASE BookLibrary
GO

USE BookLibrary
GO

CREATE TABLE BookS
(
BookCode INT DEFAULT(1) PRIMARY KEY,
BookTitle VARCHAR(100) NOT NULL,
Author VARCHAR(50) NOT NULL,
Edition INT DEFAULT(1),
BookPrice MONEY DEFAULT(10),
Copies INT DEFAULT(1)
)
GO

CREATE TABLE MemberS
(
MemberCode INT DEFAULT(1) PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Address VARCHAR(100) NOT NULL,
PhoneNumber INT DEFAULT(456789),
)
GO

CREATE TABLE IssueDetails
(
BookCode INT DEFAULT(1) CONSTRAINT fk_bookcode FOREIGN KEY (BookCode) REFERENCES BookS(BookCode),
MemberCode INT DEFAULT(1) CONSTRAINT fk_mebercode FOREIGN KEY (MemberCode) REFERENCES MemberS(MemberCode),
IssueDate DATETIME,
ReturnDate DATETIME,
)

ALTER TABLE IssueDetails
	DROP CONSTRAINT fk_bookcode, fk_mebercode;
GO

ALTER TABLE IssueDetails ADD CONSTRAINT fk_bookcode FOREIGN KEY (BookCode) REFERENCES BookS(BookCode)
ALTER TABLE IssueDetails ADD CONSTRAINT fk_membercode FOREIGN KEY (MemberCode) REFERENCES MemberS(MemberCode)
GO
ALTER TABLE BookS ADD CONSTRAINT CHK_Price CHECK(BookPrice<100)
ALTER TABLE BookS ADD CONSTRAINT CHK_Price CHECK(BookPrice BETWEEN 1 AND 199)
ALTER TABLE BookS 
	DROP CONSTRAINT CHK_Price;
GO

ALTER TABLE MemberS ADD CONSTRAINT UNI_Phone UNIQUE(PhoneNumber)
GO

ALTER TABLE IssueDetails
	ALTER COLUMN BookCode INT NOT NULL
GO
ALTER TABLE IssueDetails
	ALTER COLUMN MemberCode INT NOT NULL
GO

ALTER TABLE IssueDetails ADD CONSTRAINT pk_book_membercode PRIMARY KEY (BookCode,MemberCode)
ALTER TABLE IssueDetails 
	DROP CONSTRAINT pk_membercode;
GO

INSERT INTO BookS(BookTitle,Author) VALUES('I LOVE YOU', 'QUANG KHAI')
SELECT * FROM BookS
INSERT INTO MemberS(Name,Address) VALUES('HOANG HA','TRUNG MAU')
SELECT * FROM MemberS
SELECT * FROM IssueDetails
INSERT INTO IssueDetails(BookCode) VALUES(1)