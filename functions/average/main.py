import os
import json

from google.cloud import bigquery


def get_bounding_box_average(request_json):
    client = bigquery.Client()

    project_id = os.getenv("PROJECT_ID", "trip-analysis-18022023")
    dataset_id = os.getenv("DATASET_ID", "jobsity_trips")
    view_id = os.getenv("VIEW_ID", "refined_trips")

    query = """
        SELECT 
            EXTRACT(YEAR FROM datetime) as date_year, 
            EXTRACT(WEEK FROM datetime) as date_week, 
            COUNT(1) count
        FROM `{}.{}.{}`
        WHERE ST_COVERS(
            ST_GEOGFROMTEXT('POLYGON(({}, {}, {}, {}, {}))'), 
            destination_coord
        )
        GROUP BY EXTRACT(YEAR FROM datetime), EXTRACT(WEEK FROM datetime);
    """.format(
        project_id,
        dataset_id,
        view_id,
        request_json["upper_left"], 
        request_json["upper_right"], 
        request_json["lower_left"], 
        request_json["lower_right"],
        request_json["upper_left"]
    )

    job = client.query(query)
    rows = job.result()

    records = [dict(row) for row in rows]
    return json.dumps(str(records), indent=4)

def get_region_average(request_json):
    client = bigquery.Client()

    project_id = os.getenv("PROJECT_ID", "trip-analysis-18022023")
    dataset_id = os.getenv("DATASET_ID", "jobsity_trips")
    view_id = os.getenv("VIEW_ID", "refined_trips")

    query = """
        SELECT 
            EXTRACT(YEAR FROM datetime) as date_year, 
            EXTRACT(WEEK FROM datetime) as date_week, 
            COUNT(1) as count
        FROM `{}.{}.{}`
        WHERE region = '{}'
        GROUP BY EXTRACT(YEAR FROM datetime), EXTRACT(WEEK FROM datetime);
    """.format(
        project_id,
        dataset_id,
        view_id,
        request_json["region"]
    )

    job = client.query(query)
    rows = job.result()

    records = [dict(row) for row in rows]
    return json.dumps(str(records), indent=4)

def average(request):
    request_json = request.get_json(silent=True)
    req_type = request_json.get("type", "bounding_box")

    if req_type == "bounding_box":
        return get_bounding_box_average(request_json)
    elif req_type == "region":
        return get_region_average(request_json)
    else:
        raise Exception("Type not specified")