import os
import psycopg2
import requests
import boto3

def lambda_handler(event, context):
    conn = psycopg2.connect(
        host=os.environ["DB_HOST"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"]
    )

    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM your_table LIMIT 1")
        row = cursor.fetchone()
        colnames = [desc[0] for desc in cursor.description]
        data = dict(zip(colnames, row))

    conn.close()

    headers = {
        "Authorization": f"Bearer {os.environ['CARBONE_API_TOKEN']}",
        "Content-Type": "application/json"
    }

    payload = {
        "data": data,
        "templateId": os.environ["CARBONE_TEMPLATE_ID"],
        "convertTo": "pdf"
    }

    render = requests.post("https://api.carbone.io/render", headers=headers, json=payload)
    render.raise_for_status()
    render_id = render.json()["data"]["renderId"]

    result = requests.get(f"https://api.carbone.io/render/{render_id}", headers=headers)
    result.raise_for_status()

    s3 = boto3.client("s3")
    s3.put_object(
        Bucket=os.environ["PROCESSED_BUCKET"],
        Key="documents/output.pdf",
        Body=result.content,
        ContentType="application/pdf"
    )

    return {"statusCode": 200, "message": "File saved to S3"}