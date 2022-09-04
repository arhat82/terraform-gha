terraform {
  cloud {
    organization = "example-org-6e7769"

    workspaces {
      name = "newtest"
    }
  }
}
