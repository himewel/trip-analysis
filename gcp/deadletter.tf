# Creates PubSub topic
resource "google_pubsub_topic" "deadletter" {
  name = "dead-letter-topic"
}

# Gives to PubSub service identity permission to publish in the topic
resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  service  = "pubsub.googleapis.com"
  project = var.project
}

resource "google_pubsub_topic_iam_member" "dlq_publisher" {
  topic  = google_pubsub_topic.deadletter.id
  member = "serviceAccount:${google_project_service_identity.pubsub.email}"
  role   = "roles/pubsub.publisher"
}

# Create a default subscription
resource "google_pubsub_subscription" "default" {
  name  = "default-subscription"
  topic = google_pubsub_topic.deadletter.name
}
