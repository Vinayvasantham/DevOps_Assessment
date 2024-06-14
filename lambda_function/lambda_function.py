import boto3
import os
import json

s3 = boto3.client('s3')
sns = boto3.client('sns')

def lambda_handler(event, context):
    bucket_name = os.environ['BUCKET_NAME']
    agencies = os.environ['AGENCIES'].split(',')
    missing_agencies = []
    
    for agency in agencies:
        prefix = f"{agency}/"
        response = s3.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
        
        if 'Contents' not in response:
            missing_agencies.append(agency)
    
    if missing_agencies:
        message = f"No files uploaded today by the following agencies: {', '.join(missing_agencies)}"
        sns.publish(
            TopicArn=os.environ['SNS_TOPIC_ARN'],
            Message=message,
            Subject="Missing Upload Alert"
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Monitoring complete')
    }
