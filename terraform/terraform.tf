terraform {
  backend "local" {}
  #   backend "s3" {
  #     bucket = "BUCKET_NAME"
  #     key    = "path/to/key"
  #     endpoints = {
  #       s3 = "https://object.storage.eu01.onstackit.cloud"
  #     }
  #     region                      = "eu01"
  #     skip_credentials_validation = true
  #     skip_region_validation      = true
  #     skip_s3_checksum            = true
  #     skip_requesting_account_id  = true
  #     secret_key                  = "SECRET_KEY"
  #     access_key                  = "ACCESS_KEY"
  #   }
  required_providers {
    stackit = {
      source  = "stackitcloud/stackit"
      version = "~> 0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.4"
    }
  }
  required_version = ">= 0.14.0"
}


# Token flow
provider "stackit" {
  default_region = "eu01"
}


provider "vault" {
  address          = "https://prod.sm.eu01.stackit.cloud"
  skip_child_token = true

  auth_login_userpass {
    password = stackit_secretsmanager_user.this.password
    username = stackit_secretsmanager_user.this.username
  }
}

