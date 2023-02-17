resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "bucket" {
  name                        = "${random_id.bucket_prefix.hex}-gcf-source"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  name   = "new_trip.zip"
  bucket = google_storage_bucket.bucket.name
  source = "../functions/new_trip.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "new-trip"
  description = "Function to receive a JSON file and ingest it into PubSub"
  runtime     = "python310"

  available_memory_mb          = 128
  source_archive_bucket        = google_storage_bucket.bucket.name
  source_archive_object        = google_storage_bucket_object.object.name
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = "new_trip"

  environment_variables = {
    PROJECT_ID = var.project
    TOPIC_NAME = google_pubsub_topic.landing.name
  }
}

output "function_uri" {
  value = google_cloudfunctions_function.function.https_trigger_url
}