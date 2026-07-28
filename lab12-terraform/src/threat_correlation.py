import json


def lambda_handler(event, context):
    print("Threat Correlation Agent invoked")
    print(json.dumps(event))

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Threat Correlation completed"
        })
    }