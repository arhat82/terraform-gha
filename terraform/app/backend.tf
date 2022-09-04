terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "PVCompany"

    workspaces {
      name = "test"
    }
  }
}
