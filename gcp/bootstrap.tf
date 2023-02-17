terraform {
  required_version = ">=0.14"

  backend "gcs" {
    bucket = "tf-backend-17022023"
    prefix = "terraform/"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.34.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
