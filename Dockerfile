FROM apache/airflow:2.5.3
COPY dbt_requirements.txt .
RUN pip install -r dbt_requirements.txt
