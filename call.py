import json
import argparse
import google.auth
import requests
from google.cloud import tasks_v2
from urllib.parse import urlparse
from google.auth import impersonated_credentials


def async_call(
    client: tasks_v2.CloudTasksClient, queue: str, url: str, service_account: str
):
    url_parts = urlparse(url)
    task = {
        "http_request": {
            "http_method": tasks_v2.HttpMethod.GET,
            "url": url,
            "oidc_token": {
                "service_account_email": service_account,
                "audience": url_parts.hostname,
            },
        }
    }
    try:
        response = client.create_task(request={"parent": queue, "task": task})
    except Exception as e:
        print(f"ERROR: failed to create task, {e}")
        exit(1)

    print("INFO: Created task {}".format(response.name))


def main():
    parser = argparse.ArgumentParser(description="invoke http target via cloud tasks")

    parser.add_argument(
        "--impersonate-service-account",
        required=False,
        help="to queue the task with",
    )
    parser.add_argument("--queue", required=True, help="to use")
    parser.add_argument("--url", required=True, help="of service to invoke")
    parser.add_argument(
        "--service-account", required=True, help="to invoke the service with"
    )
    args = parser.parse_args()

    credentials, project_id = google.auth.default()

    if args.impersonate_service_account:
        print(f"INFO: call impersonated as {args.impersonate_service_account}")
        try:
            credentials = impersonated_credentials.Credentials(
                source_credentials=credentials,
                target_principal=args.impersonate_service_account,
                target_scopes=["https://www.googleapis.com/auth/cloud-platform"],
                lifetime=60,
            )
        except Exception as e:
            print(e)
            exit(1)

    if isinstance(credentials, google.oauth2.service_account.Credentials):
        print(
            "INFO: invoke using service account: " + credentials.service_account_email
        )

    client = tasks_v2.CloudTasksClient(credentials=credentials)
    async_call(
        client, queue=args.queue, url=args.url, service_account=args.service_account
    )


if __name__ == "__main__":
    main()
