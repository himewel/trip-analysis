import os
from datetime import datetime

from pydantic import BaseModel
from google.cloud import pubsub


class Trip(BaseModel):
    region: str
    origin_coord: str
    destination_coord: str
    datetime: datetime
    datasource: str

def publish(message):
    client = pubsub.PublisherClient()
    project_id = os.getenv("PROJECT_ID", "jobsity-14022023")
    topic_name = os.getenv("TOPIC_NAME", "new-trip-14022023")

    topic_url = client.topic_path(project_id, topic_name)
    future = client.publish(topic_url, str.encode(message))
    return future.result()

def new_trip(request):
   request_json = request.get_json(silent=True)

   message = Trip.parse_obj(request_json)
   message_id = publish(message.json())
   return message_id