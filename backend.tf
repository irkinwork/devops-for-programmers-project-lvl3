terraform {
  backend "remote" {
    organization = "irkin-club"
    workspaces {
      name = "project3"
    }
  }
}
