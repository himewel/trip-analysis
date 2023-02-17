resource "google_pubsub_schema" "schema" {
  name       = "landing-schema"
  type       = "AVRO"
  definition = <<EOT
{
  "type": "record",
  "name": "Avro",
  "fields": [
    {
      "name": "region",
      "type": "string"
    },
    {
      "name": "origin_coord",
      "type": "string"
    },
    {
      "name": "destination_coord",
      "type": "string"
    },
    {
      "name": "datetime",
      "type": "string"
    },
    {
      "name": "datasource",
      "type": "string"
    }
  ]
}
EOT
}

# Creates PubSub topic
resource "google_pubsub_topic" "landing" {
  name = "landing-17022023"
  schema_settings {
    schema   = google_pubsub_schema.schema.id
    encoding = "JSON"
  }
}

# Creates Push subscription calling BigQuery
resource "google_pubsub_subscription" "subscription" {
  name  = "landing-17022023-sub"
  topic = google_pubsub_topic.landing.name

  bigquery_config {
    table = "${google_bigquery_table.landing_trips.project}:${google_bigquery_table.landing_trips.dataset_id}.${google_bigquery_table.landing_trips.table_id}"
  }

  dead_letter_policy {
    dead_letter_topic = google_pubsub_topic.deadletter.id
  }

  depends_on = [
    google_project_iam_member.viewer,
    google_project_iam_member.editor,
  ]
}

data "google_project" "project" {}

resource "google_project_iam_member" "viewer" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "editor" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
