
provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "my-bucket-for-tf-123"
    prefix = "terraform/state"
  }
}
