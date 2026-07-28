import json


def lambda_handler(event, context):
    print("WAF Analyzer invoked")
    print(json.dumps(event))

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "WAF Analyzer completed"
        })
    }