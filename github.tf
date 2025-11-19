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

resource "github_repository" "terrafomcreategcpnew" {
  name        = "fromgcpnew"
  description = "This repository created using terraform"
  visibility  = "public"
}


