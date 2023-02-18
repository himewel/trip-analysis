import requests
import subprocess
import json


_URL = "https://us-central1-trip-analysis-18022023.cloudfunctions.net/average"
gcloud_auth = subprocess.Popen(
    args="gcloud auth print-identity-token", 
    stdout=subprocess.PIPE, 
    shell=True
).communicate()
token = str(gcloud_auth[0])[2:-3]

def test_region(token):
    params = {
        "type": "region",
        "region": "Prague",
    }
    print("\nrequesting region query...")
    res = requests.post(
        _URL, 
        json=params, 
        headers={"Authorization": f"Bearer {token}"}
    )
    print(res)
    print(res.json())

def test_bounding_box(token):
    params = {
        "type": "bounding_box",
        "upper_left": "0 0",
        "upper_right": "0 90",
        "lower_left": "90 90",
        "lower_right": "90 0",
    }
    print("\nrequesting bounding box query...")
    res = requests.post(
        _URL, 
        json=params, 
        headers={"Authorization": f"Bearer {token}"}
    )
    print(res)
    print(res.json())

test_region(token)
test_bounding_box(token)
