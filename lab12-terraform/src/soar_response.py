import json


def lambda_handler(event, context):
    print("SOAR Response Agent invoked")
    print(json.dumps(event))

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "SOAR response completed"
        })
    }