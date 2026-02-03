USE [ZAGI_DW]
GO
/****** Object:  StoredProcedure [dbo].[ETL_RunStart]    Script Date: 1/12/2026 7:11:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ETL_RunStart]
	@AirflowRunID varchar(50) = ''
	,@DagID varchar(50) = '0'
	,@StartTime datetime2(7) = NULL
	,@Status varchar(10) = 'Started'
	,@ProcedureName varchar(50) = ''
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO ETL_RunLog (AirflowRunID, DagID, StartTime, ProcedureName, Status)
        VALUES (@AirflowRunID, @DagID, @StartTime, @ProcedureName, @Status);
    END TRY
    BEGIN CATCH
        INSERT INTO ETL_RunLog (AirflowRunID, DagID, StartTime, ProcedureName, ErrorMessage, Status)
        VALUES (@AirflowRunID, @DagID, @StartTime, @ProcedureName, ERROR_MESSAGE(), 'Failed');
        THROW;
    END CATCH
END;
