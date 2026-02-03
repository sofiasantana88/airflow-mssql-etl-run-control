-- ======================================================
-- 1. Backup existing database
-- ======================================================
USE [ZAGI_DW];
GO
BACKUP DATABASE ZAGI_DW
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\ZAGI_DW.bak'
WITH INIT;
GO

-- ======================================================
-- 2. Drop & recreate database
-- ======================================================
USE master;
GO
ALTER DATABASE ZAGI_DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE ZAGI_DW;
GO
CREATE DATABASE ZAGI_DW;
GO
ALTER DATABASE ZAGI_DW SET MULTI_USER;
GO

USE [ZAGI_DW];
GO

-- ======================================================
-- 3. Create user
-- ======================================================
USE [ZAGI_DW]
GO

/****** Object:  User [airflowuser]    Script Date: 1/2/2026 12:28:42 AM ******/
CREATE USER [airflowuser] FOR LOGIN [airflowuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [airflowuser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [airflowuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [airflowuser]
GO
/****** Object:  Table [dbo].[DIM_CALENDAR]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_CALENDAR](
	[CalendarKey] [int] IDENTITY(1,1) NOT NULL,
	[FullDate] [date] NULL,
	[DayOfWeek] [varchar](20) NULL,
	[DayOfMonth] [int] NULL,
	[MonthName] [varchar](20) NULL,
	[Qtr] [varchar](5) NULL,
	[Year] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CalendarKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_CUSTOMER]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_CUSTOMER](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [varchar](10) NULL,
	[CustomerName] [varchar](50) NULL,
	[CustomerZip] [varchar](10) NULL,
	[CustomerMaritalStatus] [varchar](20) NULL,
	[CustomerGender] [varchar](10) NULL,
	[CustomerEducationLevel] [varchar](50) NULL,
	[CustomerCreditScore] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_PRODUCT]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_PRODUCT](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [varchar](5) NULL,
	[ProductName] [varchar](50) NULL,
	[ProductPrice] [decimal](10, 2) NULL,
	[ProductVendorName] [varchar](50) NULL,
	[ProductCategoryName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_STORE]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_STORE](
	[StoreKey] [int] IDENTITY(1,1) NOT NULL,
	[StoreID] [char](2) NULL,
	[StoreZip] [varchar](10) NULL,
	[StoreRegionName] [varchar](50) NULL,
	[StoreSize] [int] NULL,
	[StoreSystem] [varchar](50) NULL,
	[StoreLayout] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[StoreKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ETL_RunLog]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETL_RunLog](
	[RunID] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [datetime] NULL,
	[ProcedureName] [sysname] NOT NULL,
	[Status] [varchar](20) NULL,
	[ErrorMessage] [varchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[RunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FACT_SALES]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACT_SALES](
	[SalesKey] [int] IDENTITY(1,1) NOT NULL,
	[CalendarKey] [int] NULL,
	[StoreKey] [int] NULL,
	[CustomerKey] [int] NULL,
	[ProductKey] [int] NULL,
	[Quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ETL_RunLog] ADD  DEFAULT (getdate()) FOR [RunDate]
GO
ALTER TABLE [dbo].[FACT_SALES]  WITH CHECK ADD  CONSTRAINT [FK_FACT_SALES_DIM_CALENDAR] FOREIGN KEY([CalendarKey])
REFERENCES [dbo].[DIM_CALENDAR] ([CalendarKey])
GO
ALTER TABLE [dbo].[FACT_SALES] CHECK CONSTRAINT [FK_FACT_SALES_DIM_CALENDAR]
GO
ALTER TABLE [dbo].[FACT_SALES]  WITH CHECK ADD  CONSTRAINT [FK_FACT_SALES_DIM_CUSTOMER] FOREIGN KEY([CustomerKey])
REFERENCES [dbo].[DIM_CUSTOMER] ([CustomerKey])
GO
ALTER TABLE [dbo].[FACT_SALES] CHECK CONSTRAINT [FK_FACT_SALES_DIM_CUSTOMER]
GO
ALTER TABLE [dbo].[FACT_SALES]  WITH CHECK ADD  CONSTRAINT [FK_FACT_SALES_DIM_PRODUCT] FOREIGN KEY([ProductKey])
REFERENCES [dbo].[DIM_PRODUCT] ([ProductKey])
GO
ALTER TABLE [dbo].[FACT_SALES] CHECK CONSTRAINT [FK_FACT_SALES_DIM_PRODUCT]
GO
ALTER TABLE [dbo].[FACT_SALES]  WITH CHECK ADD  CONSTRAINT [FK_FACT_SALES_DIM_STORE] FOREIGN KEY([StoreKey])
REFERENCES [dbo].[DIM_STORE] ([StoreKey])
GO
ALTER TABLE [dbo].[FACT_SALES] CHECK CONSTRAINT [FK_FACT_SALES_DIM_STORE]
GO
/****** Object:  StoredProcedure [dbo].[ETL_LoadCalendar]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_LoadCalendar]
AS
BEGIN
	--TRUNCATE TABLE DIM_CALENDAR;
	DELETE FROM DIM_CALENDAR;

	-- L: Load (preparation) – remove existing rows from the dimension table
	INSERT INTO DIM_CALENDAR (
		FullDate
		,DayOfWeek
		,DayOfMonth
		,MonthName
		,Qtr
		,Year
		)
	-- L: Load – define target table and columns
	SELECT DISTINCT TransactionDate
		,-- E: Extract – source transaction date
		DATENAME(WEEKDAY, TransactionDate)
		,-- T: Transform – derive day of week
		DAY(TransactionDate)
		,-- T: Transform – derive day of month
		DATENAME(MONTH, TransactionDate)
		,-- T: Transform – derive month name
		CONCAT (
			'Q'
			,DATEPART(QUARTER, TransactionDate)
			)
		,-- T: Transform – derive quarter
		YEAR(TransactionDate) -- T: Transform – derive year
	FROM [ZAGI_Source]..[SALESTRANSACTION];
		-- E: Extract – read data from source system table
END;
GO
/****** Object:  StoredProcedure [dbo].[ETL_LoadCustomer]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_LoadCustomer]
AS
BEGIN
	--TRUNCATE TABLE DIM_CUSTOMER;
	DELETE FROM DIM_CUSTOMER;

	-- L: Load (preparation) – remove existing data from the customer dimension table
	INSERT INTO DIM_CUSTOMER (
		CustomerID
		,CustomerName
		,CustomerZip
		,CustomerMaritalStatus
		,CustomerGender
		,CustomerEducationLevel
		,CustomerCreditScore
		)
	-- L: Load – specify target dimension table and columns
	SELECT C.CustomerID
		,-- E: Extract – CustomerID from source CUSTOMER table
		C.CustomerName
		,-- E: Extract – CustomerName from source CUSTOMER table
		C.CustomerZip
		,-- E: Extract – CustomerZip from source CUSTOMER table
		EC.MaritalStatus
		,-- E: Extract – MaritalStatus from external source table
		EC.Gender
		,-- E: Extract – Gender from external source table
		EC.EducationLevel
		,-- E: Extract – EducationLevel from external source table
		EC.CreditScore -- E: Extract – CreditScore from external source table
	FROM [ZAGI_Source]..[CUSTOMER] C
	-- E: Extract – read customer base data from source system
	JOIN [ZAGI_Source]..[EXTERNALCUSTOMER] EC ON C.CustomerID = EC.CustomerID;
		-- T: Transform – integrate data from multiple source tables using a join
END;
GO
/****** Object:  StoredProcedure [dbo].[ETL_LoadFactSales]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_LoadFactSales]
AS
BEGIN
	--TRUNCATE TABLE FACT_SALES;
	DELETE FROM FACT_SALES;

	-- L: Load (preparation) – remove existing rows from the fact table
	INSERT INTO FACT_SALES (
		CalendarKey
		,StoreKey
		,CustomerKey
		,ProductKey
		,Quantity
		)

	-- L: Load – define target fact table and columns
	SELECT C.CalendarKey
		,-- T: Transform – look up surrogate CalendarKey from DIM_CALENDAR
		S.StoreKey
		,-- T: Transform – look up surrogate StoreKey from DIM_STORE
		CU.CustomerKey
		,-- T: Transform – look up surrogate CustomerKey from DIM_CUSTOMER
		P.ProductKey
		,-- T: Transform – look up surrogate ProductKey from DIM_PRODUCT
		I.Quantity -- E: Extract – Quantity from source INCLUDES table
	FROM [ZAGI_Source]..[INCLUDES] I
	-- E: Extract – read sales line item data from INCLUDES table
	JOIN [ZAGI_Source]..[SALESTRANSACTION] T ON I.TransactionID = T.TransactionID
	-- T: Transform – associate line items with transaction dates and stores
	JOIN

	DIM_CALENDAR C ON C.FullDate = T.TransactionDate
	-- T: Transform – map transaction date to calendar surrogate key
	JOIN

	DIM_STORE S ON S.StoreID = T.StoreID
	-- T: Transform – map store business key to store surrogate key
	JOIN

	DIM_CUSTOMER CU ON CU.CustomerID = T.CustomerID
	-- T: Transform – map customer business key to customer surrogate key
	JOIN

	DIM_PRODUCT P ON P.ProductID = I.ProductID
		-- T: Transform – map product business key to product surrogate key
END;
GO
/****** Object:  StoredProcedure [dbo].[ETL_LoadProduct]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_LoadProduct]
AS
BEGIN
	--TRUNCATE TABLE DIM_PRODUCT;
	DELETE FROM DIM_PRODUCT;

	-- L: Load (preparation) – remove existing rows from the product dimension table
	INSERT INTO DIM_PRODUCT (
		ProductID
		,ProductName
		,ProductPrice
		,ProductVendorName
		,ProductCategoryName
		)
	-- L: Load – specify target dimension table and columns
	SELECT P.ProductID
		,-- E: Extract – ProductID from PRODUCT source table
		P.ProductName
		,-- E: Extract – ProductName from PRODUCT source table
		P.ProductPrice
		,-- E: Extract – ProductPrice from PRODUCT source table
		V.VendorName
		,-- E: Extract – VendorName from VENDOR source table
		C.CategoryName -- E: Extract – CategoryName from CATEGORY source table
	FROM [ZAGI_Source]..[PRODUCT] P
	-- E: Extract – read product data from source PRODUCT table
	JOIN [ZAGI_Source]..[VENDOR] V ON P.VendorID = V.VendorID
	-- T: Transform – join product data with vendor information
	JOIN [ZAGI_Source]..[CATEGORY] C ON P.CategoryID = C.CategoryID;
		-- T: Transform – join product data with category information
END;
GO
/****** Object:  StoredProcedure [dbo].[ETL_LoadStore]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_LoadStore]
AS
BEGIN
	--TRUNCATE TABLE DIM_STORE;
	DELETE FROM DIM_STORE;

	-- L: Load (preparation) – remove existing rows from the store dimension table
	INSERT INTO DIM_STORE (
		StoreID
		,StoreZip
		,StoreRegionName
		,StoreSize
		,StoreSystem
		,StoreLayout
		)
	-- L: Load – define target dimension table and columns
	SELECT S.StoreID
		,-- E: Extract – StoreID from STORE source table
		S.StoreZip
		,-- E: Extract – StoreZip from STORE source table
		R.RegionName
		,-- E: Extract – RegionName from REGION source table
		ST.StoreSize
		,-- E: Extract – StoreSize from StoreDetails source table
		CS.SystemName
		,-- E: Extract – Checkout system from CHECKOUTSYSTEM table
		L.LayoutName -- E: Extract – Layout from LAYOUT table
	FROM [ZAGI_Source]..[STORE] S
	-- E: Extract – read base store data from STORE table
	JOIN [ZAGI_Source]..[REGION] R ON S.RegionID = R.RegionID
	-- T: Transform – join store data with region information
	JOIN [ZAGI_Source]..[StoreDetails] ST ON S.StoreID = ST.StoreID
	-- T: Transform – join store data with store attributes
	JOIN [ZAGI_Source]..[CHECKOUTSYSTEM] CS ON ST.CSID = CS.CSID
	-- T: Transform – join store data with checkout system details
	JOIN [ZAGI_Source]..[LAYOUT] L ON ST.LayoutID = L.LayoutID
		-- T: Transform – join store data with layout information
END;
GO
/****** Object:  StoredProcedure [dbo].[ETL_RunAll]    Script Date: 1/2/2026 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ETL_RunAll]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO ETL_RunLog (ProcedureName, Status)
        VALUES ('ETL_RunAll', 'Started');

		DELETE FROM [dbo].[FACT_SALES]
		DELETE FROM [dbo].[DIM_CALENDAR]
		DELETE FROM [dbo].[DIM_CUSTOMER]
		DELETE FROM [dbo].[DIM_PRODUCT]
		DELETE FROM [dbo].[DIM_STORE]

        EXEC dbo.ETL_LoadCalendar;
        EXEC dbo.ETL_LoadStore;
        EXEC dbo.ETL_LoadCustomer;
        EXEC dbo.ETL_LoadProduct;
        EXEC dbo.ETL_LoadFactSales;

        INSERT INTO ETL_RunLog (ProcedureName, Status)
        VALUES ('ETL_RunAll', 'Completed');
    END TRY
    BEGIN CATCH
        INSERT INTO ETL_RunLog (ProcedureName, Status, ErrorMessage)
        VALUES (
            'ETL_RunAll',
            'Failed',
            ERROR_MESSAGE()
        );

        THROW;
    END CATCH
END;
GO

SELECT * INTO stg_builtby FROM [ZAGI_Source].[dbo].[BUILTBY] WHERE 1 = 0;
SELECT * INTO stg_checkoutsystem FROM [ZAGI_Source].[dbo].[CHECKOUTSYSTEM] WHERE 1 = 0;
SELECT * INTO stg_category FROM [ZAGI_Source].[dbo].[CATEGORY] WHERE 1 = 0;
SELECT * INTO stg_contractor FROM [ZAGI_Source].[dbo].[CONTRACTOR] WHERE 1 = 0;
SELECT * INTO stg_customer FROM [ZAGI_Source].[dbo].[CUSTOMER] WHERE 1 = 0;
SELECT * INTO stg_external_customer_table FROM [ZAGI_Source].[dbo].[EXTERNALCUSTOMER] WHERE 1 = 0;
SELECT * INTO stg_includes FROM [ZAGI_Source].[dbo].[INCLUDES] WHERE 1 = 0;
SELECT * INTO stg_layout FROM [ZAGI_Source].[dbo].[LAYOUT] WHERE 1 = 0;
SELECT * INTO stg_product FROM [ZAGI_Source].[dbo].[PRODUCT] WHERE 1 = 0;
SELECT * INTO stg_region FROM [ZAGI_Source].[dbo].[REGION] WHERE 1 = 0;
SELECT * INTO stg_sales_transaction FROM [ZAGI_Source].[dbo].[SALESTRANSACTION] WHERE 1 = 0;
SELECT * INTO stg_store FROM [ZAGI_Source].[dbo].[STORE] WHERE 1 = 0;
SELECT * INTO stg_store_details FROM [ZAGI_Source].[dbo].[STOREDetails] WHERE 1 = 0;
SELECT * INTO stg_vendor FROM [ZAGI_Source].[dbo].[VENDOR] WHERE 1 = 0;

-- 1. BuiltBy
-- =====================================================
DELETE FROM stg_builtby;
INSERT INTO stg_builtby
SELECT * FROM [ZAGI_Source].[dbo].[BuiltBy];

-- =====================================================
-- 2. Category
-- =====================================================
DELETE FROM stg_category;
INSERT INTO stg_category
SELECT * FROM [ZAGI_Source].[dbo].[Category];

-- =====================================================
-- 3. CheckoutSystem
-- =====================================================
DELETE FROM stg_checkoutsystem;
INSERT INTO stg_checkoutsystem
SELECT * FROM [ZAGI_Source].[dbo].[CheckoutSystem];

-- =====================================================
-- 4. Contractor
-- =====================================================
DELETE FROM stg_contractor;
INSERT INTO stg_contractor
SELECT * FROM [ZAGI_Source].[dbo].[Contractor];

-- =====================================================
-- 5. Customer
-- =====================================================
DELETE FROM stg_customer;
INSERT INTO stg_customer
SELECT * FROM [ZAGI_Source].[dbo].[Customer];

-- =====================================================
-- 6. ExternalCustomer
-- =====================================================
DELETE FROM stg_external_customer_table;
INSERT INTO stg_external_customer_table
SELECT * FROM [ZAGI_Source].[dbo].[ExternalCustomer];

-- =====================================================
-- 7. Includes
-- =====================================================
DELETE FROM stg_includes;
INSERT INTO stg_includes
SELECT * FROM [ZAGI_Source].[dbo].[Includes];

-- =====================================================
-- 8. Layout
-- =====================================================
DELETE FROM stg_layout;
INSERT INTO stg_layout
SELECT * FROM [ZAGI_Source].[dbo].[Layout];

-- =====================================================
-- 9. Product
-- =====================================================
DELETE FROM stg_product;
INSERT INTO stg_product
SELECT * FROM [ZAGI_Source].[dbo].[Product];

-- =====================================================
-- 10. Region
-- =====================================================
DELETE FROM stg_region;
INSERT INTO stg_region
SELECT * FROM [ZAGI_Source].[dbo].[Region];

-- =====================================================
-- 11. SalesTransaction
-- =====================================================
DELETE FROM stg_sales_transaction;
INSERT INTO stg_sales_transaction
SELECT * FROM [ZAGI_Source].[dbo].[SalesTransaction];

-- =====================================================
-- 12. Store
-- =====================================================
DELETE FROM stg_store;
INSERT INTO stg_store
SELECT * FROM [ZAGI_Source].[dbo].[Store];

-- =====================================================
-- 13. StoreDetails
-- =====================================================
DELETE FROM stg_store_details;
INSERT INTO stg_store_details
SELECT * FROM [ZAGI_Source].[dbo].[StoreDetails];

-- =====================================================
-- 14. Vendor
-- =====================================================
DELETE FROM stg_vendor;
INSERT INTO stg_vendor
SELECT * FROM [ZAGI_Source].[dbo].[Vendor];

-- Validation
select * from [dbo].[stg_builtby]
select * from [dbo].[stg_category]
select * from [dbo].[stg_checkoutsystem]
select * from [dbo].[stg_contractor]
select * from [dbo].[stg_customer]
select * from [dbo].[stg_external_customer_table]
select * from [dbo].[stg_includes]
select * from [dbo].[stg_layout]
select * from [dbo].[stg_product]
select * from [dbo].[stg_region]
select * from [dbo].[stg_sales_transaction]
select * from [dbo].[stg_store]
select * from [dbo].[stg_store_details]
select * from [dbo].[stg_vendor]

select * from [dbo].[DIM_CALENDAR]
select * from [dbo].[DIM_CUSTOMER]
select * from [dbo].[DIM_PRODUCT]
select * from [dbo].[DIM_STORE]
select * from [dbo].[FACT_SALES]
select * from [dbo].[ETL_RunLog]

-- Stored Name
USE ZAGI_DW;
SELECT name
FROM sys.procedures
ORDER BY name;

USE ZAGI_DW;
EXEC dbo.ETL_RunAll;

--Verification
SELECT t.name AS TableName, p.rows
FROM sys.tables t
JOIN sys.partitions p ON p.object_id = t.object_id
WHERE p.index_id IN (0,1)
ORDER BY p.rows DESC, t.name;
