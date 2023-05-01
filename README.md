# customer-segmentation-feats-etl
The customer-segmentation-feats-etl project is a data pipeline designed to process and transform customer segmentation data using Apache Airflow and dbt. 
It automates customer data's weekly extraction, transformation, and loading (ETL) into Google BigQuery. 
The project utilizes Docker for containerization, ensuring a smooth and consistent execution environment across different platforms.

Here's a step-by-step instruction for setting up and running your customer-segmentation-feats-etl project using Airflow and dbt:

### Prerequisites
You need to have an active BigQuery project and a service account with following roles:
- BigQuery Connection Service Agent
- BigQuery Data Editor
- BigQuery Data Viewer
- BigQuery Job User
- BigQuery User

### Step 1: Create .env file
Create a new file named `.env` in the root directory of your project (customer-segmentation-feats-etl). 
You may use `example.env` as an example.
Add the required variables to the file.
Make sure to replace examples with the appropriate paths on your system.

### Step 2: Install dependencies
Install Python dependencies in a virtual environment.
```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
You also need to install dbt dependencies.
```
cd feats_dbt
dbt deps
cd ..
```

### Step 3: Build Docker images
Open a terminal and navigate to the root directory of your project. Run the following command to build the Docker images:
```
docker compose build
```

### Step 4: Run Docker containers
After building the images, run the following command to start the Docker containers:
```
docker compose up
```
This command will start the Airflow webserver, scheduler, and the PostgreSQL database.

### Step 5: Access Airflow webserver
Open your web browser and navigate to [0.0.0.0:8080](0.0.0.0:8080). 
This will open the Airflow webserver interface, where you can see your DAGs and manage your workflows.

### Step 6: Run the DAG
Find the `feats_dbt_weekly_run` DAG in the list of available DAGs. 
Click the "play" button next to the DAG to trigger a manual run. 
This will start the DAG, and you can monitor its progress through the Airflow web interface.

### Step 7: Check the table in BigQuery
After completing the DAG run, log in to your Google Cloud Platform account and navigate to the BigQuery console. 
Check the dataset and table specified in your dbt project configuration to verify that the expected data has been processed and loaded correctly.

The final table should look like this:
![my_project.dbt_segmentation_feats.customer_segmentation_features](https://user-images.githubusercontent.com/38642966/235524476-e14040c9-5111-42f3-bd5d-d08dc89600de.png)

Feel free to ask for assistance if you encounter any issues or have any questions during this process.