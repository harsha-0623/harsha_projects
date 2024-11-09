import boto3
from botocore.exceptions import ClientError
import json

def get_secret():
    secret_name = "my-key"
    region_name = "us-east-1"
    print("Starting the secret retrieval process...")

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )
    print("Client created successfully")

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        print("Secret retrieved successfully")
    except ClientError as e:
        print(f"An error occurred: {e}")
        raise e

    # Parse the secret value
    secret = get_secret_value_response['SecretString']
    print(f"Secret string: {secret}")
    secret_dict = json.loads(secret)
    return secret_dict

if __name__ == "__main__":
    print("Running the get_secret function...")
    secret_data = get_secret()
    print("Retrieved secret data:", secret_data)
