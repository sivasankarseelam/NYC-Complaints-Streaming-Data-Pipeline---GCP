import os
from flask import Flask, request
import requests
from google.cloud import pubsub_v1

app = Flask(__name__)

def fetch_data_from_nyc_api():
    api_endpoint = "https://data.cityofnewyork.us/resource/fhrw-4uyv.json"
    params = {"complaint_type": "Noise - Residential", "$limit": 100}
    response = requests.get(api_endpoint, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch data from NYC API. Status code: {response.status_code}")
        return None

def publish_to_pubsub(data):
    publisher = pubsub_v1.PublisherClient()
    topic_name = os.getenv("nyc-noise-complaints-topic")  # Correct this to match the environment variable set in the Terraform
    for complaint in data:
        publisher.publish(topic_name, str(complaint).encode())

@app.route("/", methods=["POST"])
def main():
    data = fetch_data_from_nyc_api()
    if data:
        publish_to_pubsub(data)
        return "Data published to Pub/Sub successfully."
    else:
        return "Failed to fetch data from NYC API."

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 8080)))
