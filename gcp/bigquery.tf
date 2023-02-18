resource "google_bigquery_dataset" "jobsity_trips" {
  dataset_id = "jobsity_trips"
}

resource "google_bigquery_table" "landing_trips" {
  deletion_protection = false
  table_id            = "landing_trips"
  dataset_id          = google_bigquery_dataset.jobsity_trips.dataset_id

  labels              = {}

  schema = "${file("schema.json")}"
}

resource "google_bigquery_table" "refined_trips" {
  deletion_protection = false
  table_id = "refined_trips"
  dataset_id = google_bigquery_dataset.jobsity_trips.dataset_id

  materialized_view {
    query = <<EOF
SELECT
  region,
  ST_GEOGFROMTEXT(origin_coord) origin_coord,
  ST_GEOGFROMTEXT(destination_coord) destination_coord,
  datetime,
  datasource
FROM ${google_bigquery_table.landing_trips.dataset_id}.${google_bigquery_table.landing_trips.table_id}
EOF
  }

  depends_on = [
    google_bigquery_table.landing_trips
  ]
}