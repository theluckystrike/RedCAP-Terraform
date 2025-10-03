import os
import boto3
import pandas as pd
import psycopg2
from psycopg2 import sql
import json

DB_NAME = os.environ['DB_NAME']
DB_PROXY_ENDPOINT = os.environ['DB_PROXY_ENDPOINT']
SECRET_ARN = os.environ['SECRET_ARN']

# Get credentials from Secrets Manager
secrets_client = boto3.client('secretsmanager')
secret = secrets_client.get_secret_value(SecretId=SECRET_ARN)
creds = json.loads(secret['SecretString'])
DB_USER = creds['username']
DB_PASSWORD = creds['password']

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        local_path = f"/tmp/{key.split('/')[-1]}"
        s3.download_file(bucket, key, local_path)

        df = pd.read_excel(local_path)

        # Connect via RDS Proxy
        conn = psycopg2.connect(
            host=DB_PROXY_ENDPOINT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            port=5432
        )
        cursor = conn.cursor()
        table_name = "redcap_data"

        for _, row in df.iterrows():
            columns = list(row.index)
            values = [row[col] for col in columns]
            insert_query = sql.SQL("INSERT INTO {} ({}) VALUES ({})").format(
                sql.Identifier(table_name),
                sql.SQL(', ').join(map(sql.Identifier, columns)),
                sql.SQL(', ').join(sql.Placeholder() * len(values))
            )
            cursor.execute(insert_query, values)

        conn.commit()
        cursor.close()
        conn.close()

    return {"statusCode": 200, "body": f"Processed {len(event['Records'])} files."}