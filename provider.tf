terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.86.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }

  }
}

################################
## Google Provider
################################

provider "google" {}

################################
## Azure Provider
################################

provider "azurerm" {
  features {}
}

################################
## AWS Provider
################################

provider "aws" {}