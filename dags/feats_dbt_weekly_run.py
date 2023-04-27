from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 5, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'dbt_weekly_run',
    default_args=default_args,
    description='Run dbt weekly',
    schedule_interval=timedelta(weeks=1),
    catchup=False,
    max_active_runs=1,
)

dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command='cd feats_dbt/ && dbt run',
    dag=dag,
)
