variable "project_id" {
  description = "Project_ID"
  default     = "datazoomcamp-project-420918"
}

variable "region" {
  description = "Project_region"
  default     = "us-central1"
}

variable "gcs_bucket_name" {
  description = "storage bucket name"
  default     = "nyc_noise_complaints"
}

variable "location" {
  description = "project location"
  default     = "US"
}

variable "storage_class" {
  description = "storage class"
  default     = "STANDARD"
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic"
  default     = "nyc-noise-complaints-topic"
}


variable "bucket_name" {
  description = "Name of the Google Cloud Storage bucket to store the function code"
  default     = "cloud_function_source_bucket_unique_identifier"
}