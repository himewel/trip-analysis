import requests
import subprocess
import pandas as pd


_URL = "https://us-central1-trip-analysis-18022023.cloudfunctions.net/new-trip"
gcloud_auth = subprocess.Popen(
        args="gcloud auth print-identity-token", 
        stdout=subprocess.PIPE, 
        shell=True
    ).communicate()
token = str(gcloud_auth[0])[2:-3]

def make_request(message, token):
    print("sending message...")
    res = requests.post(
        _URL, 
        json=message, 
        headers={"Authorization": f"Bearer {token}"}
    )
    print(res, str(res.content))

df = pd.read_csv("./scripts/trips.csv")
for record in df.to_dict("records"):
    make_request(record, token)