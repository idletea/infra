terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.19"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.24"
    }
  }

  backend "s3" {
    region = "auto"
    bucket = "opentofu"
    key    = "infra/base.tf"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_s3_checksum            = true

    endpoints = {
      s3 = "https://a0e9a519a696e7d8c04087b2ea84dfba.r2.cloudflarestorage.com"
    }
  }
}
