-- ======================================================
-- 1. Backup existing database
-- ======================================================
USE [ZAGI_Source];
GO
BACKUP DATABASE ZAGI_Source
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\ZAGI_Source.bak'
WITH INIT;
GO

-- ======================================================
-- 2. Drop & recreate database
-- ======================================================
USE master;
GO
ALTER DATABASE ZAGI_Source SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE ZAGI_Source;
GO
CREATE DATABASE ZAGI_Source;
GO
ALTER DATABASE ZAGI_Source SET MULTI_USER;
GO

USE [ZAGI_Source];
GO

-- ======================================================
-- 3. Create user
-- ======================================================
CREATE USER [airflowuser] FOR LOGIN [airflowuser] WITH DEFAULT_SCHEMA = [dbo];
GO

-- ======================================================
-- 4. Create tables
-- ======================================================
CREATE TABLE dbo.Vendor (
    VendorID CHAR(2) NOT NULL PRIMARY KEY,
    VendorName VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Category (
    CategoryID CHAR(2) NOT NULL PRIMARY KEY,
    CategoryName VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Contractor (
    ContractorID CHAR(2) NOT NULL PRIMARY KEY,
    ContractorName VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Region (
    RegionID CHAR(1) NOT NULL PRIMARY KEY,
    RegionName VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Store (
    StoreID CHAR(2) NOT NULL PRIMARY KEY,
    StoreZip VARCHAR(10) NULL,
    RegionID CHAR(1) NULL
);
GO

CREATE TABLE dbo.CheckoutSystem (
    CSID CHAR(2) NOT NULL PRIMARY KEY,
    SystemName VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Layout (
    LayoutID CHAR(1) NOT NULL PRIMARY KEY,
    LayoutName VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.Product (
    ProductID VARCHAR(5) NOT NULL PRIMARY KEY,
    ProductName VARCHAR(50) NULL,
    ProductPrice DECIMAL(10,2) NULL,
    VendorID CHAR(2) NULL,
    CategoryID CHAR(2) NULL
);
GO

CREATE TABLE dbo.Customer (
    CustomerID VARCHAR(10) NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(50) NULL,
    CustomerZip VARCHAR(10) NULL
);
GO

CREATE TABLE dbo.SalesTransaction (
    TransactionID VARCHAR(10) NOT NULL PRIMARY KEY,
    CustomerID VARCHAR(10) NULL,
    StoreID CHAR(2) NULL,
    TransactionDate DATE NULL,
    TransactionTime TIME(7) NULL
);
GO

CREATE TABLE dbo.BuiltBy (
    StoreID CHAR(2) NULL,
    ContractorID CHAR(2) NULL
);
GO

CREATE TABLE dbo.StoreDetails (
    StoreID CHAR(2) NULL,
    StoreSize INT NULL,
    CSID CHAR(2) NULL,
    LayoutID CHAR(1) NULL
);
GO

CREATE TABLE dbo.ExternalCustomer (
    CustomerID VARCHAR(10) NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(50) NULL,
    Gender VARCHAR(10) NULL,
    MaritalStatus VARCHAR(10) NULL,
    EducationLevel VARCHAR(50) NULL,
    CreditScore INT NULL
);
GO

CREATE TABLE dbo.Includes (
    ProductID VARCHAR(5) NULL,
    TransactionID VARCHAR(10) NULL,
    Quantity INT NULL
);
GO

-- ======================================================
-- 5. Add foreign keys
-- ======================================================
ALTER TABLE dbo.Product
ADD CONSTRAINT FK_Product_Vendor FOREIGN KEY (VendorID) REFERENCES dbo.Vendor(VendorID),
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID) REFERENCES dbo.Category(CategoryID);
GO

ALTER TABLE dbo.Store
ADD CONSTRAINT FK_Store_Region FOREIGN KEY (RegionID) REFERENCES dbo.Region(RegionID);
GO

ALTER TABLE dbo.SalesTransaction
ADD CONSTRAINT FK_SalesTransaction_Customer FOREIGN KEY (CustomerID) REFERENCES dbo.Customer(CustomerID),
    CONSTRAINT FK_SalesTransaction_Store FOREIGN KEY (StoreID) REFERENCES dbo.Store(StoreID);
GO

ALTER TABLE dbo.BuiltBy
ADD CONSTRAINT FK_BuiltBy_Contractor FOREIGN KEY (ContractorID) REFERENCES dbo.Contractor(ContractorID),
    CONSTRAINT FK_BuiltBy_Store FOREIGN KEY (StoreID) REFERENCES dbo.Store(StoreID);
GO

ALTER TABLE dbo.StoreDetails
ADD CONSTRAINT FK_StoreDetails_CheckoutSystem FOREIGN KEY (CSID) REFERENCES dbo.CheckoutSystem(CSID),
    CONSTRAINT FK_StoreDetails_Layout FOREIGN KEY (LayoutID) REFERENCES dbo.Layout(LayoutID),
    CONSTRAINT FK_StoreDetails_Store FOREIGN KEY (StoreID) REFERENCES dbo.Store(StoreID);
GO

ALTER TABLE dbo.Includes
ADD CONSTRAINT FK_Includes_Product FOREIGN KEY (ProductID) REFERENCES dbo.Product(ProductID),
    CONSTRAINT FK_Includes_SalesTransaction FOREIGN KEY (TransactionID) REFERENCES dbo.SalesTransaction(TransactionID);
GO

-- ======================================================
-- 6. Insert data in correct order
-- ======================================================

-- Vendor
INSERT INTO dbo.Vendor (VendorID, VendorName) VALUES ('MK', 'Mountain King'), ('PG', 'Pacifica Gear');

-- Category
INSERT INTO dbo.Category (CategoryID, CategoryName) VALUES ('CP', 'Camping'), ('FW', 'Footwear');

-- Contractor
INSERT INTO dbo.Contractor (ContractorID, ContractorName) VALUES ('C1', 'Acme Construction'),
                                                                 ('C2', 'GIN Builders'),
                                                                 ('C3', 'Rauker G.C.');

-- Region
INSERT INTO dbo.Region (RegionID, RegionName) VALUES ('C', 'Chicagoland'), ('T', 'Tristate');

-- Store
INSERT INTO dbo.Store (StoreID, StoreZip, RegionID) VALUES ('S1', '60600', 'C'), ('S2', '60605', 'C'), ('S3', '35401', 'T');

-- CheckoutSystem
INSERT INTO dbo.CheckoutSystem (CSID, SystemName) VALUES ('AC', 'Self Service'), ('CR', 'Cashiers'), ('MX', 'Mixed');

-- Layout
INSERT INTO dbo.Layout (LayoutID, LayoutName) VALUES ('M', 'Modern'), ('T', 'Traditional');

-- Product
INSERT INTO dbo.Product (ProductID, ProductName, ProductPrice, VendorID, CategoryID) VALUES
('1X1', 'Zzz Bag', 100.00, 'PG', 'CP'),
('2X2', 'Easy Boot', 70.00, 'MK', 'FW'),
('3X3', 'Cosy Sock', 15.00, 'MK', 'FW'),
('4X4', 'Dura Boot', 90.00, 'PG', 'FW'),
('5X5', 'Tiny Tent', 150.00, 'MK', 'CP'),
('6X6', 'Biggy Tent', 250.00, 'MK', 'CP');

-- Customer
INSERT INTO dbo.Customer (CustomerID, CustomerName, CustomerZip) VALUES ('1-2-333', 'Tina', '60137'),
                                                                        ('2-3-444', 'Tony', '60611'),
                                                                        ('3-4-555', 'Pam', '35401');

-- SalesTransaction
INSERT INTO dbo.SalesTransaction (TransactionID, CustomerID, StoreID, TransactionDate, TransactionTime) VALUES
('T1000', '2-3-444', 'S2', '2020-01-02', '09:57:43'),
('T111', '1-2-333', 'S1', '2020-01-01', '08:23:59'),
('T222', '2-3-444', 'S1', '2020-01-01', '08:24:30'),
('T333', '1-2-333', 'S2', '2020-01-02', '08:30:00'),
('T444', '3-4-555', 'S3', '2020-01-02', '08:30:43'),
('T555', '3-4-555', 'S3', '2020-01-02', '09:00:00'),
('T666', '1-2-333', 'S2', '2020-01-02', '09:40:50'),
('T777', '2-3-444', 'S1', '2020-01-02', '09:45:00'),
('T888', '2-3-444', 'S3', '2020-01-02', '09:47:33'),
('T999', '1-2-333', 'S1', '2020-01-02', '09:50:00');

-- BuiltBy
INSERT INTO dbo.BuiltBy (StoreID, ContractorID) VALUES ('S1', 'C1'), ('S1', 'C2'), ('S1', 'C3'),
                                                        ('S2', 'C1'), ('S2', 'C3'), ('S3', 'C1'), ('S3', 'C3');

-- StoreDetails
INSERT INTO dbo.StoreDetails (StoreID, StoreSize, CSID, LayoutID) VALUES
('S1', 51000, 'CR', 'M'),
('S2', 35000, 'AC', 'T'),
('S3', 55000, 'MX', 'T');

-- ExternalCustomer
INSERT INTO dbo.ExternalCustomer (CustomerID, CustomerName, Gender, MaritalStatus, EducationLevel, CreditScore)
VALUES ('1-2-333', 'Tina', 'Female', 'Single', 'College', 700),
       ('2-3-444', 'Tony', 'Male', 'Single', 'High School', 650),
       ('3-4-555', 'Pammy', 'Female', 'Married', 'College', 623);

-- Includes
INSERT INTO dbo.Includes (ProductID, TransactionID, Quantity) VALUES
('1X1', 'T111', 1), ('2X2', 'T222', 1), ('1X1', 'T333', 1), ('3X3', 'T333', 5),
('4X4', 'T444', 1), ('4X4', 'T555', 4), ('5X5', 'T555', 2), ('6X6', 'T555', 1),
('3X3', 'T777', 2), ('1X1', 'T888', 1), ('1X1', 'T1000', 3), ('4X4', 'T1000', 2),
('2X2', 'T444', 2), ('1X1', 'T666', 1), ('2X2', 'T777', 1), ('1X1', 'T999', 3),
('3X3', 'T999', 4), ('4X4', 'T999', 2), ('3X3', 'T1000', 4);
GO

-- Validation
select * from [dbo].[BuiltBy]
select * from [dbo].[Category]
select * from [dbo].[CheckoutSystem]
select * from [dbo].[Contractor]
select * from [dbo].[Customer]
select * from [dbo].[ExternalCustomer]
select * from [dbo].[Includes]
select * from [dbo].[Layout]
select * from [dbo].[Product]
select * from [dbo].[Region]
select * from [dbo].[SalesTransaction]
select * from [dbo].[Store]
select * from [dbo].[StoreDetails]
select * from [dbo].[Vendor]
