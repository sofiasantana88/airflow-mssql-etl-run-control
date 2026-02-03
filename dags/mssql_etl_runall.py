from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.operators.python import PythonOperator
import pendulum

def pre():
    print("Preprocessing ...")

with DAG(
    dag_id="mssql_etl_runall",
    start_date=pendulum.datetime(2024, 1, 1, tz="UTC"),
    schedule="@daily",
    catchup=False,
    tags=["mssql", "run_control"],
) as dag:

    log_start = SQLExecuteQueryOperator(
        task_id="log_etl_start",
        conn_id="mssql_default",
        autocommit=True,
        sql="""
        EXEC ZAGI_DW.dbo.ETL_RunStart
             @AirflowRunID  = '{{ run_id }}',
             @DagID         = '{{ dag.dag_id }}',
             @StartTime     = '{{ ts }}',
             @ProcedureName = 'ETL_RunAll';
        """
    )

    dummy = PythonOperator(
        task_id= "pre",
        python_callable = pre)


    run_etl = SQLExecuteQueryOperator(
        task_id="run_etl",
        conn_id="mssql_default",
        autocommit=True,
        sql="""EXEC ZAGI_DW.dbo.ETL_RunAll @RunDate='{{ ds }}';;"""
    )


    log_end = SQLExecuteQueryOperator(
        task_id="log_etl_end",
        conn_id="mssql_default",
        autocommit=True,
        trigger_rule="all_done",
        sql="""
        EXEC ZAGI_DW.dbo.ETL_RunEnd
             @AirflowRunID = '{{ run_id }}',
             @EndTime      = '{{ ts }}',
             @Status       = '{{ ti.xcom_pull(task_ids="run_etl", key="state") }}',
             @ErrorMessage = '{{ ti.xcom_pull(task_ids="run_etl", key="exception") }}';
        """
    )

    log_start >> dummy >> run_etl >> log_end
