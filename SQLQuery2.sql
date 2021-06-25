CREATE DATABASE Example4
ON PRIMARY
(
NAME='Example4',
FILENAME='D:\Example4.mdf'
)
LOG ON
(
NAME = 'Customer_DB_log',
FILENAME='D:\Example4_DB_log.ldf'
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO

IF (DB_ID('Example4') IS NOT NULL)
DROP DATABASE Example4

USE Example4
GO
EXECUTE sp_changedbowner @loginame='sa'
EXEC sp_changedbowner 'sa'
ALTER DATABASE CUST_DB SET AUTO_SHRINK ON
GO

CREATE DATABASE Example4
ON PRIMARY
  ( NAME='Example4_Primary',
	FILENAME='D:\Example4.mdf',
	SIZE=4MB,
	MAXSIZE=7MB,
	FILEGROWTH=1MB),
FILEGROUP Example4_FG1
(
NAME = 'Example4_FG1_Dat1',
FILENAME= 'D:\Example4_FG1_1.ndf',
	SIZE=1MB,
	MAXSIZE=10MB,
	FILEGROWTH=1MB
),
(
NAME = 'Example4_FG1_Dat2',
FILENAME= 'D:\Example4_FG1_2.ndf',
	SIZE=1MB,
	MAXSIZE=10MB,
	FILEGROWTH=1MB
)
LOG ON
(
NAME = 'Customer_DB_log',
FILENAME='D:\Example4_DB_log.ldf'
)
COLLATE SQL_Latin1_General_CP1_CI_AS
GO