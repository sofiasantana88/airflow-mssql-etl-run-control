USE [ZAGI_DW]
GO
/****** Object:  StoredProcedure [dbo].[ETL_RunEnd]    Script Date: 1/12/2026 7:11:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ETL_RunEnd]
	@AirflowRunID varchar(50) = ''
	,@DagID varchar(50) = '0'
	,@EndTime datetime2(7) = NULL
	,@Status varchar(10) = 'Started'
	,@ErrorMessage varchar(50) = ''
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO ETL_RunLog (AirflowRunID, DagID, EndTime, ErrorMessage, Status)
        VALUES (@AirflowRunID, @DagID, @EndTime, @ErrorMessage, @Status);
    END TRY
    BEGIN CATCH
        INSERT INTO ETL_RunLog (AirflowRunID, DagID, EndTime, ErrorMessage, Status)
        VALUES (@AirflowRunID, @DagID, @EndTime, @ErrorMessage, 'Failed');
        THROW;
    END CATCH
END;

