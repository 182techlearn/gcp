terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
}

resource "github_repository" "terrafomcreategcp" {
  name        = "fromgcp"
  description = "This repository created using terraform"
  visibility  = "public"
}


