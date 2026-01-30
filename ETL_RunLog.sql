USE [ZAGI_DW]
GO

ALTER TABLE [dbo].[ETL_RunLog] DROP CONSTRAINT [DF__ETL_RunLo__Inser__7B5B524B]
GO

/****** Object:  Table [dbo].[ETL_RunLog]    Script Date: 1/12/2026 7:16:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETL_RunLog]') AND type in (N'U'))
DROP TABLE [dbo].[ETL_RunLog]
GO

/****** Object:  Table [dbo].[ETL_RunLog]    Script Date: 1/12/2026 7:16:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ETL_RunLog](
	[RunID] [int] IDENTITY(1,1) NOT NULL,
	[AirflowRunID] [nvarchar](100) NULL,
	[DagID] [nvarchar](100) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Status] [nvarchar](20) NULL,
	[ProcedureName] [varchar](15) NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[InsertedDate] [datetime2](7) NULL,
 CONSTRAINT [pk_etl_runlog] PRIMARY KEY CLUSTERED 
(
	[RunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ETL_RunLog] ADD  DEFAULT (getdate()) FOR [InsertedDate]
GO


