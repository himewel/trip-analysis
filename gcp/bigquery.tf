resource "google_bigquery_dataset" "jobsity_trips" {
  dataset_id = "jobsity_trips"
}

resource "google_bigquery_table" "landing_trips" {
  deletion_protection = false
  table_id            = "landing_trips"
  dataset_id          = google_bigquery_dataset.jobsity_trips.dataset_id

  schema = <<EOF
[
    {
        "name": "region",
        "mode": "NULLABLE",
        "type": "STRING",
        "fields": []
    },
    {
        "name": "datetime",
        "mode": "NULLABLE",
        "type": "TIMESTAMP",
        "fields": []
    },
    {
        "name": "datasource",
        "mode": "NULLABLE",
        "type": "STRING",
        "fields": []
    },
    {
        "name": "origin_coord",
        "mode": "NULLABLE",
        "type": "STRING",
        "fields": []
    },
    {
        "name": "destination_coord",
        "mode": "NULLABLE",
        "type": "STRING",
        "fields": []
    },
    {
        "name": "subscription_name",
        "mode": "NULLABLE",
        "type": "STRING",
        "fields": []
    },
    {
        "name": "message_id",
        "mode": "NULLABLE",
        "type": "STRING",
        "fields": []
    },
    {
        "name": "publish_time",
        "mode": "NULLABLE",
        "type": "TIMESTAMP",
        "fields": []
    },
    {
        "name": "data",
        "mode": "NULLABLE",
        "type": "JSON",
        "fields": []
    },
    {
        "name": "attributes",
        "mode": "NULLABLE",
        "type": "JSON",
        "fields": []
    }
]
EOF
}