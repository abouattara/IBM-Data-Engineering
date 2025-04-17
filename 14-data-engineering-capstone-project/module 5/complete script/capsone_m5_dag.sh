from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Define default arguments
default_args = {
    'owner': 'your_name',  # Set the DAG owner
    'start_date': datetime(2024, 3, 27),  # Adjust to a suitable past date
    'email': ['your_email@example.com'],  # Add your email
    'email_on_failure': True,  # Notify on failure
    'email_on_retry': False,   # Do not notify on retry
    'retries': 2,  # Number of retries on failure
    'retry_delay': timedelta(minutes=5),  # Delay before retrying
}

# Instantiate the DAG
dag = DAG(
   'process_web_log',
    default_args=default_args,
    description='Web log processing DAG',
    schedule_interval='@daily',  # Run daily
    catchup=False  # Do not run for past dates
)

# Define the extract_data task
extract_data = BashOperator(
    task_id='extract_data',
    bash_command="awk '{print $1}' /home/project/airflow/dags/capstone/accesslog.txt > /home/project/airflow/dags/capstone/extracted_data.txt",
    dag=dag
)

# Define the transform_data task
transform_data = BashOperator(
    task_id='transform_data',
    bash_command="grep -v '198.46.149.143' /home/project/airflow/dags/capstone/extracted_data.txt > /home/project/airflow/dags/capstone/transformed_data.txt",
    dag=dag
)

# Define the load_data task
load_data = BashOperator(
    task_id='load_data',
    bash_command="tar -cvf /home/project/airflow/dags/capstone/acesslog.tar /home/project/airflow/dags/capstone/transformed_data.txt",
    dag=dag
)

# Define task dependencies
extract_data >> transform_data >> load_data


# Submit my dag
mv process_web_log.py /home/project/airflow/dags/


# To unpause my dag
airflow dags unpause process_web_log

