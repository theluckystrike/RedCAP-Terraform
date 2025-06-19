import boto3
import os
import tempfile
import openpyxl
import psycopg2

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    with tempfile.NamedTemporaryFile(suffix=".xlsx") as tmp:
        s3.download_file(bucket, key, tmp.name)
        workbook = openpyxl.load_workbook(tmp.name)
        sheet = workbook.active

        rows = []
        for i, row in enumerate(sheet.iter_rows(values_only=True)):
            if i == 0:
                headers = row
            else:
                rows.append(row)

    conn = psycopg2.connect(
        host=os.environ['DB_HOST'],
        dbname=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        port=5432
    )
    cur = conn.cursor()
    for row in rows:
        cur.execute("INSERT INTO patients (name, age, diagnosis) VALUES (%s, %s, %s)", row)
    conn.commit()
    cur.close()
    conn.close()

    return {"status": "success", "file": key}