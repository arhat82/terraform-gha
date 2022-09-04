terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "example-org-6e7769"

    workspaces {
      name = "test"
    }
  }
}
