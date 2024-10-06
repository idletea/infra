locals {
  cloudflare_account = "a0e9a519a696e7d8c04087b2ea84dfba"
}

variable "STATE_KEY" {
  type     = string
  nullable = false
}

terraform {
  encryption {
    key_provider "pbkdf2" "key" {
      passphrase = var.STATE_KEY
    }

    method "aes_gcm" "method" {
      keys = key_provider.pbkdf2.key
    }

    plan {
      enforced = true
      method   = method.aes_gcm.method
    }

    state {
      enforced = true
      method   = method.aes_gcm.method
    }

    remote_state_data_sources {
      default {
        method = method.aes_gcm.method
      }
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32"
    }
  }

  backend "s3" {
    region                      = "auto"
    bucket                      = "tofu"
    key                         = "kubernetes.tofu"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_s3_checksum            = true
    endpoints = {
      s3 = "https://${local.cloudflare_account}.r2.cloudflarestorage.com"
    }
  }
}

provider "kubernetes" {
  config_path = "../../.kube-config"
}
