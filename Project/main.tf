terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  credentials = file("datazoomcamp-project-420918-99d1e68c183f.json")
  project     = var.project_id
  region      = var.region
}

resource "google_storage_bucket" "nyc_noise_complaints" {
  name                        = var.gcs_bucket_name
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 5 // Example: objects are deleted after 10 years
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    env = "production"
  }
}

output "bucket_url" {
  value = "gs://${google_storage_bucket.nyc_noise_complaints.name}"
}

# Create a Pub/Sub topic
resource "google_pubsub_topic" "nyc_noise_complaints_topic" {
  name = var.topic_name
}

resource "google_storage_bucket" "function_source_bucket" {
  name     = var.bucket_name
  location = var.region
}

# Create the Cloud Function (2nd Gen) with HTTP trigger
resource "google_cloudfunctions2_function" "fetch_and_publish_function" {
  name        = "fetch-and-publish-function"
  location    = var.region
  description = "My 2nd gen Cloud Function with HTTP trigger"

  build_config {
    entry_point = "fetch_and_publish"
    runtime     = "python39"
    source {
      storage_source {
        bucket = "cloud_function_source_bucket_unique_identifier"
        object = "cloud_functions.zip"
      }
    }
  }

  service_config {
    available_memory = "256M"
    environment_variables = {
      TOPIC_NAME = var.topic_name
    }
    ingress_settings = "ALLOW_ALL"
  }
}

output "cloud_function_url" {
  value = google_cloudfunctions2_function.fetch_and_publish_function.service_config[0].uri
}