# airflow-mssql-etl-run-control
End-to-end ETL orchestration using Apache Airflow and SQL Server with run-control logging, backfill, and failure handling.


## Project Overview

This project demonstrates an end-to-end ETL pipeline orchestration using Apache Airflow and Microsoft SQL Server. The pipeline executes SQL-based ETL logic and implements run-control logging to track when each ETL run starts, ends, and whether it succeeds or fails.

The goal of this project is to show real-world data engineering practices, including orchestration, logging, debugging, backfill/catchup, and parameterization using Airflow.

## Technologies Used 
- Apache Airflow (running locally in WSL)
- Microsoft SQL Server
- Pyhton (Airflow DAGs)
- SQL (stored procedures, tables)

## High-level Flow 
1. Airflow triggers the DAG on a schedule or manually.
2. log_start executes the main ETL stored procedure.
3. log_ends logs the end of the ETL run, including success or failure.

## Repository Structure 
airflow-mssql-etl-run-control/
├── dags/
│ └── mssql_etl_runall.py
├── sql/
│ ├── ZAGI_Source.sql
│ ├── ZAGI_DW.sql
│ ├── ETL_RunLog.sql
│ ├── ETL_RunStart.sql
│ └── ETL_RunEnd.sql
├── docs/
│ └── screenshots/
├── .gitignore
└── README.md

## Key Concepts
1. DAG definition and task dependencies
- SQLExecuteQueryOperator and PythonOperator
- Trigger rules (all_done vs all_success)
- Backfill and catchup for multiple logical dates
- Jinja templating ({{ ds }}, {{ ts }}, {{ run_id }})
2. SQL Server ETL Design
- Separate Source and Data Warehouse databases
- Stored procedures for ETL execution
- Permissions and database users
3. Run-Control Logging
- Central ETL_RunLog table
- ETL_RunStart procedure logs start metadata
- ETL_RunEnd procedure logs end metadata
- Captures run ID, DAG ID, timestamps, status, and errors
4. Debugging & Observability
- Task logs in Airflow
- Rendered Templates for SQL inspection
- Handling failures while still logging ETL completion



## SQL Components Explained
ZAGI_Source.sql -> Creates and populates the source database with sample transactional tables and data.

ZAGI_DW.sql -> Creates the data warehouse database, including dimensions and tables used by the ETL process.
ETL_RunLog.sql -> Creates the ETL_RunLog table used to track ETL executions.
ETL_RunStart.sql -> Stored procedure that inserts a record when an ETL run starts.
ETL_RunEnd.sql -> Stored procedure that inserts a record when an ETL run finishes, including status and error messages.


## How to run the project
1. Prerequisites: WSL (Linux Environment), Python 3.10+ , Apache Airflow installed in a virtual environment, Microsoft SQL Server running locally.
2. Start Airflow (Standalone)
- source airflow-venv/bin/activate
- airflow standalone
- http://localhost:8080
3. Configure Airflow Connection: Create a connection in Admin → Connections: Conn ID: mssql_default, Conn Type: Microsoft SQL Server, Host, Login, Password, Schema: your local SQL Server settings

4️. Run the DAG: Trigger manually from the UI or use Backfill to run for multiple dates


## Parameterization & Backfill

The DAG demonstrates dynamic parameterization using Airflow macros:

{{ ds }} → logical execution date

{{ ts }} → execution timestamp

{{ run_id }} → unique DAG run identifier

Backfill allows the same ETL logic to run for multiple historical dates, which is essential for reproducible data pipelines.


## Observing Results

Airflow Grid View shows one row per logical date

Task logs show rendered SQL and execution details

SQL Server ETL_RunLog table records each run with timestamps and status


# Why does this matters?

This project reflects real-world data engineering workflows: Orchestration with Airflow, SQL-based ETL logic, logging and error handling, and debugging though logs and metadata.

## Future Improvements

Add row-count and duration metrics

Update ETL_RunEnd to update start records instead of inserting new rows

Add alerts (email/Slack) on failures

Migrate the pipeline to a cloud database (Azure/AWS)

# This project is for educational and portfolio purposes.


  
