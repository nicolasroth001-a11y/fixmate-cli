import boto3
import json
import requests
import logging
import time

# Setup logging for CloudWatch
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_openai_key():
    client = boto3.client('secretsmanager')
    secret = client.get_secret_value(SecretId='openai/api-key')
    return json.loads(secret['SecretString'])['OPENAI_API_KEY']

def lambda_handler(event, context):
    start_time = time.time()

    error_input = event.get('error', 'No error provided')
    logger.info(f"Received error: {error_input}")

    api_key = get_openai_key()
    prompt = f"Diagnose this AWS error and provide a fix:\n{error_input}"

    try:
        response = requests.post(
            'https://api.openai.com/v1/chat/completions',
            headers={
                'Authorization': f'Bearer {api_key}',
                'Content-Type': 'application/json'
            },
            json={
                "model": "gpt-3.5-turbo",
                "messages": [
                    {
                        "role": "system",
                        "content": (
                            "You are FixMate, a cloud diagnostic assistant. "
                            "Format your response into three sections:\n\n"
                            "Diagnosis:\n[Brief explanation]\n\n"
                            "Fix Steps:\n[Numbered steps]\n\n"
                            "Reference Links:\n[Optional links or AWS docs]"
                        )
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            }
        )

        duration = round(time.time() - start_time, 2)
        logger.info(f"OpenAI response time: {duration} seconds")
        logger.info(f"Raw OpenAI response: {response.text}")

        data = response.json()
        content = data['choices'][0]['message']['content']
        content = f"FixMate v1.0\n\n{content}"
        logger.info(f"Diagnosis preview: {content[:100]}...")

        return {
            'statusCode': 200,
            'body': content
        }

    except Exception as e:
        logger.error("Exception occurred", exc_info=True)
        return {
            'statusCode': 500,
            'body': f"Error: {str(e)}"
        }

# Optional: Local test block for CLI or manual runs
if __name__ == "__main__":
    test_event = {
        "error": "The instance ID 'i-1234567890abcdef0' does not exist"
    }
    result = lambda_handler(test_event, None)
    print("GPT Diagnosis:")
    print(result['body'])
