#!/usr/bin/env python3
import subprocess
import sys
import os
import time
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from dotenv import load_dotenv

load_dotenv("/path/to/.env") # Change to the correct path accordingly.

SLACK_BOT_TOKEN = os.getenv("SLACK_BOT_TOKEN")
SLACK_USER_ID = os.getenv("SLACK_USER_ID")
SLACK_CHANNEL = os.getenv("SLACK_CHANNEL")

def send_slack_notification(command, elapsed_time, status):
    client = WebClient(token=SLACK_BOT_TOKEN)
    blocks = [
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "*[Report]*"
            }
        },
        {
            "type": "section",
            "fields": [
                {
                    "type": "mrkdwn",
                    "text": "*Executed Command:*\n" + f"`{command}  `"
                },
                {
                    "type": "mrkdwn",
                    "text": "*Execution Time:*\n" + f"{elapsed_time:.2f} seconds"
                },
                {
                    "type": "mrkdwn",
                    "text": "*Status:*\n" + f"{status}"
                }
            ]
        },
        {
            "type": "divider"
        }
    ]
    try:
        response = client.chat_postMessage(
            channel=SLACK_CHANNEL, # If you want to send to DM, change to SLACK_USER_ID.
            text="Script Execution Report",
            blocks=blocks
        )
        print(f"Notification sent: {response['ts']}")
    except SlackApiError as e:
        print(f"Error sending message: {e.response['error']}")

def main():
    if len(sys.argv) < 2:
        print("Usage: api.py <script_to_run> [script_args...]")
        sys.exit(1)

    script_to_run = sys.argv[1]
    script_args = sys.argv[2:]
    command = f"{script_to_run} {' '.join(script_args)}"

    start_time = time.time()

    try:
        print(f"Running script: {command}")
        subprocess.run([script_to_run] + script_args, check=True)
        end_time = time.time()
        elapsed_time = end_time - start_time
        send_slack_notification(command, elapsed_time, "Success")
    except subprocess.CalledProcessError as e:
        end_time = time.time()
        elapsed_time = end_time - start_time
        send_slack_notification(command, elapsed_time, f"Error: {e}")
        sys.exit(1)
    except Exception as e:
        end_time = time.time()
        elapsed_time = end_time - start_time
        send_slack_notification(command, elapsed_time, f"Unexpected Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
