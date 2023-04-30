from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    "feats_dbt_weekly_run",
    default_args=default_args,
    description="Run dbt weekly to generate customer segmentation features",
    schedule_interval=timedelta(weeks=1),
    start_date=datetime(2023, 4, 28),
    catchup=False,
    tags=["dbt", "weekly"],
) as dag:
    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/dbt/feats_dbt && dbt run",
        dag=dag,
    )

    dbt_run
